//
//  SDOpenGLView.m
//  Haruhi
//
//  Created by Sylvain Defresne on 15/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import "SDOpenGLView.h"

#import "SDRendering.h"
#import "SDController.h"

#import <QuartzCore/QuartzCore.h>

@interface SDOpenGLView (PrivateMethods)

- (void)reshape;
- (void)drawView;

- (void)setUpDisplayLink:(NSOpenGLPixelFormat*)pixelFormat;
- (void)teadDownDisplayLink;

- (CVReturn)getFrameForTime:(const CVTimeStamp*)outputTime;

@end

// This is the display link C callback.  It need access to the private extension of
// |SDOpenGLView| and is used by the class implementation.  Putting the definition
// save us from using a separate declaration.
static CVReturn SDDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp *now,
                                      const CVTimeStamp *outputTime, CVOptionFlags flagsIn,
                                      CVOptionFlags *flagsOut, void *displayLinkContext) {
  return [(__bridge SDOpenGLView*)displayLinkContext getFrameForTime:outputTime];
}

@implementation SDOpenGLView {
  CVDisplayLinkRef displayLink_;
  CFAbsoluteTime renderTime_;
  id notification_;
}

@synthesize controller = controller_;
@synthesize renderer = renderer_;
@synthesize openGLContext = openGLContext_;

- (id)initWithFrame:(NSRect)frameRect {
  return [self initWithFrame:frameRect shareContext:nil];
}

- (id)initWithFrame:(NSRect)frameRect
       shareContext:(NSOpenGLContext *)context {
  if ((self = [super initWithFrame:frameRect])) {
    NSOpenGLPixelFormatAttribute attribs[] = {
      kCGLPFAAccelerated,
      kCGLPFANoRecovery,
      kCGLPFADoubleBuffer,
      kCGLPFAColorSize, 24,
      kCGLPFADepthSize, 16,
      0,
    };

    NSOpenGLPixelFormat* pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs];
    openGLContext_ = [[NSOpenGLContext alloc] initWithFormat:pixelFormat
                                                shareContext:context];

    // Synchronize buffer swap with vertical refresh rate.
    GLint swapInt = 1;
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
    [[self openGLContext] makeCurrentContext];

    [self setUpDisplayLink:pixelFormat];

    // Look for change in size through |NSNotificationCenter| since |NSView|
    // does not export |-reshape| for override.
    notification_ =
    [[NSNotificationCenter defaultCenter] addObserverForName:NSViewGlobalFrameDidChangeNotification
                                                      object:self
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                    [[note object] reshape];
                                                  }];
  }
  return self;
}

- (void)dealloc {
  [self teadDownDisplayLink];
  [[NSNotificationCenter defaultCenter] removeObserver:notification_];
}

- (BOOL)isAnimating {
  return CVDisplayLinkIsRunning(displayLink_);
}

- (void)setAnimating:(BOOL)animating {
  if ([self isAnimating] == !animating) {
    if (animating) {
      CVDisplayLinkStart(displayLink_);
    } else {
      CVDisplayLinkStop(displayLink_);
    }
  }
}

- (void)drawRect:(NSRect)dirtyRect {
  if (!CVDisplayLinkIsRunning(displayLink_)) {
    [self drawView];
  }
}

- (void)lockFocus {
  [super lockFocus];
  if ([[self openGLContext] view] != self) {
    [[self openGLContext] setView:self];
    [[self renderer] render];
  }
}

@end

@implementation SDOpenGLView (InputEvents)

- (BOOL)acceptsFirstResponder {
  return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
  [[self controller] keyDown:theEvent];
}

- (void)keyUp:(NSEvent *)theEvent {
  [[self controller] keyUp:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent {
  [[self controller] mouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent {
  [[self controller] mouseUp:theEvent];
}

@end

@implementation SDOpenGLView (PrivateMethods)

- (void)reshape {
  // This method will be called from the main thread when resizing the view.
  // Lock the |CGContextObj| to serialize execution.
  CGLLockContext([[self openGLContext] CGLContextObj]);

  @try {
    [[self renderer] setViewPortRect:[self bounds]];
    [[self openGLContext] update];
  }
  @finally {
    CGLUnlockContext([[self openGLContext] CGLContextObj]);
  }
}

- (void)drawView {
  // This method will be called from both the main thread and the display link
  // worker thread.  Lock the |CGContextObj| to serialize execution.
  CGLLockContext([[self openGLContext] CGLContextObj]);

  @try {
    [[self openGLContext] makeCurrentContext];
    [[self renderer] render];
    [[self openGLContext] flushBuffer];
  }
  @finally {
    CGLUnlockContext([[self openGLContext] CGLContextObj]);
  }
}

- (void)setUpDisplayLink:(NSOpenGLPixelFormat*)pixelFormat {
  CVDisplayLinkCreateWithActiveCGDisplays(&displayLink_);
  CVDisplayLinkSetOutputCallback(displayLink_, &SDDisplayLinkCallback, (__bridge void*) self);

  CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
  CGLPixelFormatObj cglPixelFormat = [pixelFormat CGLPixelFormatObj];
  CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink_, cglContext, cglPixelFormat);
}

- (void)teadDownDisplayLink {
  CVDisplayLinkStop(displayLink_);
  CVDisplayLinkRelease(displayLink_);
}

- (CVReturn)getFrameForTime:(const CVTimeStamp *)outputTime {
  // There is no autorelease pool when this method is called as it is called
  // by a background thread.  It is important to create one to prevent leaks.
  @autoreleasepool {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    float deltaTime = currentTime - renderTime_;
    [[self controller] advanceTimeBy:deltaTime];
    renderTime_ = currentTime;

    [self drawView];
  }
  return kCVReturnSuccess;
}

@end
