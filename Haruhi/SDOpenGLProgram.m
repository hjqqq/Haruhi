//
//  SDOpenGLProgram.m
//  Haruhi
//
//  Created by Sylvain Defresne on 28/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import "SDOpenGLProgram.h"

#import <OpenGL/gl3.h>

enum {
  SHADERS_TYPE_COUNT = 3,
};

static NSString *kShaderExt = @"glsl";

static NSString *kShaderSuffix[SHADERS_TYPE_COUNT] = {
  @"v",
  @"f",
  @"g",
};

static NSString* kShaderName[SHADERS_TYPE_COUNT] = {
  @"vertex",
  @"fragment",
  @"geometry",
};

static const GLenum kShaderType[SHADERS_TYPE_COUNT] = {
  GL_VERTEX_SHADER,
  GL_FRAGMENT_SHADER,
  GL_GEOMETRY_SHADER,
};

@interface SDOpenGLProgram (PrivateMethods)

+ (GLuint)loadShader:(GLenum)type
            withName:(NSString*)name;

+ (GLuint)loadProgram:(GLenum)flags
             withName:(NSString*)name;

@end

@implementation SDOpenGLProgram (PrivateMethods)

+ (GLuint)loadShader:(GLenum)type
            withName:(NSString *)name {
  NSError *error = nil;
  NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:kShaderExt];
  NSString *data = [NSString stringWithContentsOfFile:path
                                             encoding:NSUTF8StringEncoding
                                                error:&error];
  if (data == nil) {
    NSLog(@"-[SDOpenGLProgram loadShader:%@ withName:%@]: %@",
          kShaderName[type], path, [error localizedDescription]);
    return 0;
  }

  GLuint shader = glCreateShader(type);

  const GLchar *source = [data UTF8String];
  glShaderSource(shader, 1, &source, NULL);
  glCompileShader(shader);

  GLint shaderCompilationOK;
  glGetShaderiv(shader, GL_COMPILE_STATUS, &shaderCompilationOK);
  if (!shaderCompilationOK) {
    GLint infoLogLength;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLogLength);

    GLchar *infoLog = malloc(infoLogLength);
    glGetShaderInfoLog(shader, infoLogLength, NULL, infoLog);
    NSLog(@"-[SDOpenGLProgram loadShader:%@ withName:%@]: %s",
          kShaderName[type], path, infoLog);

    free(infoLog);
    return 0;
  }

  if (!shaderCompilationOK) {
    glDeleteShader(shader);
  }

  return shader;
}

+ (GLuint)loadProgram:(GLenum)flags
             withName:(NSString*)name {
  GLuint shaders[SHADERS_TYPE_COUNT];
  for (NSUInteger i = 0; i < SHADERS_TYPE_COUNT; i++) {
    if (flags & (1 << i)) {
      NSString *shaderName = [name stringByAppendingPathExtension:kShaderSuffix[i]];
      shaders[i] = [SDOpenGLProgram loadShader:kShaderType[i] withName:shaderName];
      if (shaders[i] == 0) {
        return 0;
      }
    }
  }

  GLuint program = glCreateProgram();
  for (NSUInteger i = 0; i < SHADERS_TYPE_COUNT; i++) {
    if (flags & (1 << i)) {
      glAttachShader(program, shaders[i]);
    }
  }

  GLint programLinkingOK;
  glLinkProgram(program);
  glGetProgramiv(program, GL_LINK_STATUS, &programLinkingOK);
  if (!programLinkingOK) {
    GLint infoLogLength;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLogLength);

    GLchar *infoLog = malloc(infoLogLength);
    glGetProgramInfoLog(program, infoLogLength, NULL, infoLog);
    NSLog(@"-[SDOpenGLProgram loadProgram:%u withName:%@]: %s",
          flags, name, infoLog);

    free(infoLog);
  }

  for (NSUInteger i = 0; i < SHADERS_TYPE_COUNT; i++) {
    if (shaders[SHADERS_TYPE_COUNT - i - 1] != 0) {
      glDetachShader(program, shaders[SHADERS_TYPE_COUNT - i - 1]);
      glDeleteShader(shaders[SHADERS_TYPE_COUNT - i - 1]);
    }
  }

  if (!programLinkingOK) {
    glDeleteProgram(program);
    program = 0;
  }

  return program;
}

@end

@implementation SDOpenGLProgram

@synthesize program = program_;

- (id)init:(GLenum)flags
  withName:(NSString*)name {
  if ((self = [super init])) {
    program_ = [SDOpenGLProgram loadProgram:flags withName:name];
    if (program_ == 0) {
      return nil;
    }
  }
  return self;
}

- (void)dealloc {
  if (program_ != 0) {
    glDeleteShader(program_);
  }
}

@end
