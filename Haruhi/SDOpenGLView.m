//
//  SDOpenGLView.m
//  Haruhi
//
//  Created by Sylvain Defresne on 15/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import "SDOpenGLView.h"

#import "SDRenderer.h"
#import "SDController.h"

#import <QuartzCore/QuartzCore.h>

@interface SDOpenGLView (PrivateMethods)

- (void)reshape;
- (void)drawView;

- (void)setUpDisplayLink:(NSOpenGLPixelFormat*)pixelFormat;
- (void)tearDownDisplayLink;

- (CVReturn)getFrameForTime:(const CVTimeStamp*)outputTime;

- (void)withLockedContext:(void (^)(void))block;

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
  id<SDRenderer> renderer_;
  id notification_;
}

@synthesize controller = controller_;
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
      kCGLPFAOpenGLProfile,
      kCGLOGLPVersion_3_2_Core,
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
  [self tearDownDisplayLink];
  [[NSNotificationCenter defaultCenter] removeObserver:notification_];
}

- (BOOL)isAnimating {
  return CVDisplayLinkIsRunning(displayLink_);
}

- (void)setAnimating:(BOOL)animating {
  if ([self isAnimating] == !animating) {
    if (animating) {
      [self postsFrameChangedNotifications];
      renderTime_ = CFAbsoluteTimeGetCurrent();
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
    [self withLockedContext:^{
      [[self openGLContext] setView:self];
      [[self openGLContext] makeCurrentContext];
      [[self renderer] setViewPortRect:[self bounds]];
      [[self renderer] render];
    }];
  }
}

- (id<SDRenderer>)renderer {
  return renderer_;
}

- (void)setRenderer:(id<SDRenderer>)renderer {
  [self withLockedContext:^{
    if (renderer != renderer_) {
      [[self openGLContext] makeCurrentContext];
      renderer_ = renderer;
    }
  }];
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
  [self withLockedContext:^{
    [[self openGLContext] makeCurrentContext];
    [[self renderer] setViewPortRect:[self bounds]];
    [[self openGLContext] update];
  }];
}

- (void)drawView {
  [self withLockedContext:^{
    [[self openGLContext] makeCurrentContext];
    [[self renderer] render];
    [[self openGLContext] flushBuffer];
  }];
}

- (void)setUpDisplayLink:(NSOpenGLPixelFormat*)pixelFormat {
  CVDisplayLinkCreateWithActiveCGDisplays(&displayLink_);
  CVDisplayLinkSetOutputCallback(displayLink_, &SDDisplayLinkCallback, (__bridge void*) self);

  CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
  CGLPixelFormatObj cglPixelFormat = [pixelFormat CGLPixelFormatObj];
  CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink_, cglContext, cglPixelFormat);
}

- (void)tearDownDisplayLink {
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

- (void)withLockedContext:(void (^)(void))block {
  CGLLockContext([[self openGLContext] CGLContextObj]);

  @try {
    block();
  }
  @finally {
    CGLUnlockContext([[self openGLContext] CGLContextObj]);
  }
}

@end
