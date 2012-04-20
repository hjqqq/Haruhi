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

@interface SDMainController ()

@property (strong, nonatomic) id<SDRenderer> renderer;

@end

@implementation SDMainController

@synthesize openGLView = openGLView_;
@synthesize renderer = renderer_;

- (void)awakeFromNib {
  renderer_ = [[SDSceneRenderer alloc] init];
  [openGLView_ setRenderer:renderer_];
  [openGLView_ setAnimating:YES];
}

@end
