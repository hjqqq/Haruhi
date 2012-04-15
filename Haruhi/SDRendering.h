//
//  SDRendering.h
//  Haruhi
//
//  Created by Sylvain Defresne on 15/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDRendering <NSObject>

- (void)render;
- (void)setViewPortRect:(NSRect)frameRect;

@end
