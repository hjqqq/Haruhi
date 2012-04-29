//
//  SDSceneRenderer.mm
//  Haruhi
//
//  Created by Sylvain Defresne on 15/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import "SDSceneRenderer.h"

#import "SDOpenGLProgram.h"
#include "SDMatrix.h"

#import <OpenGL/gl3.h>

@implementation SDSceneRenderer {
  GLuint perspectiveMatrixUniform_;
  SDOpenGLProgram *program_;
}

- (void)prepare {
  program_ = [[SDOpenGLProgram alloc] init:PROGRAM_WITH_VERTEX|PROGRAM_WITH_FRAGMENT
                                  withName:@"DefaultShader"];

  perspectiveMatrixUniform_ = glGetUniformLocation([program_ program], "perspectiveMatrix");

  glEnable(GL_CULL_FACE);
  glCullFace(GL_BACK);
  glFrontFace(GL_CW);

  glEnable(GL_DEPTH_TEST);
  glDepthMask(GL_TRUE);
  glDepthFunc(GL_LEQUAL);
  glDepthRange(0.0f, 1.0f);
}

- (void)render {
  glClearDepth(1.0f);
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
  glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

  glUseProgram([program_ program]);
  glUseProgram(0);
}

- (void)cleanup {
}

- (void)setViewPortRect:(NSRect)frameRect {
  const float aspectRatio = frameRect.size.height / frameRect.size.width;
  mat4 perspectiveMatrix = BuildPerspectiveMatrix(45.0f, aspectRatio, 1.0f, 3.0f);

  glUseProgram([program_ program]);
  glUniformMatrix4fv(perspectiveMatrixUniform_, 1, GL_FALSE, perspectiveMatrix.v);
  glUseProgram(0);

  glViewport(0, 0, frameRect.size.width, frameRect.size.height);
}

@end
