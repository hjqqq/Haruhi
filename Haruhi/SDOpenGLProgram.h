//
//  SDOpenGLProgram.h
//  Haruhi
//
//  Created by Sylvain Defresne on 28/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import <Foundation/Foundation.h>

enum SDOpenGLProgramFlags {
  PROGRAM_WITH_VERTEX   = 1 << 0,
  PROGRAM_WITH_FRAGMENT = 1 << 1,
  PROGRAM_WITH_GEOMETRY = 1 << 2,
};

@interface SDOpenGLProgram : NSObject

@property (readonly, nonatomic) GLuint program;

- (id)init:(GLenum)flags
  withName:(NSString*)name;

@end
