//
//  SDOpenGLView.h
//  Haruhi
//
//  Created by Sylvain Defresne on 15/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SDController;
@protocol SDRenderer;

@interface SDOpenGLView : NSView

@property SDController* controller;
@property id<SDRenderer> renderer;
@property (strong, readonly, nonatomic) NSOpenGLContext *openGLContext;

- (id)initWithFrame:(NSRect)frameRect;
- (id)initWithFrame:(NSRect)frameRect
       shareContext:(NSOpenGLContext*)context;

- (BOOL)isAnimating;
- (void)setAnimating:(BOOL)animating;

@end
