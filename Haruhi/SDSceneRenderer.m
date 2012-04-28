//
//  SDSceneRenderer.m
//  Haruhi
//
//  Created by Sylvain Defresne on 15/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import "SDSceneRenderer.h"

#import <OpenGL/gl3.h>

@implementation SDSceneRenderer

- (void)prepare {
}

- (void)render {
  glClearColor(0, 0, 0, 0);
  glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
}

- (void)cleanup {
}

- (void)setViewPortRect:(NSRect)frameRect {
  glViewport(0, 0, frameRect.size.width, frameRect.size.height);
}

@end
