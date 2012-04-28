//
//  SDMainController.m
//  Haruhi
//
//  Created by Sylvain Defresne on 15/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import "SDMainController.h"

#import "SDOpenGLView.h"
#import "SDRenderer.h"
#import "SDSceneRenderer.h"

@implementation SDMainController {
  SDSceneRenderer *renderer_;
}

@synthesize openGLView = openGLView_;

- (void)awakeFromNib {
  renderer_ = [[SDSceneRenderer alloc] init];
  [openGLView_ setRenderer:renderer_];
  [openGLView_ setController:self];
  [openGLView_ setAnimating:YES];
}

- (void)advanceTimeBy:(float)deltaTime {
}

@end
