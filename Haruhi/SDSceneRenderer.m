//
//  SDSceneRenderer.m
//  Haruhi
//
//  Created by Sylvain Defresne on 15/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import "SDSceneRenderer.h"

#import <OpenGL/glu.h>

@implementation SDSceneRenderer

- (void)render {
  glClearColor(0, 0, 0, 0);
  glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
}

- (void)setViewPortRect:(NSRect)frameRect {
  glViewport(0, 0, frameRect.size.width, frameRect.size.height);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(30, frameRect.size.width / frameRect.size.height, 1.0, 1000.0);
  glMatrixMode(GL_MODELVIEW);
}

@end
