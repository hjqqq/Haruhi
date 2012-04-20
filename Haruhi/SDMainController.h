//
//  SDMainController.h
//  Haruhi
//
//  Created by Sylvain Defresne on 15/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import "SDController.h"

#import <Cocoa/Cocoa.h>

@class SDOpenGLView;

@interface SDMainController : NSResponder<SDController>

@property (assign) IBOutlet SDOpenGLView* openGLView;

@end
