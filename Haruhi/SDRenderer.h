//
//  SDRenderer.h
//  Haruhi
//
//  Created by Sylvain Defresne on 15/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDRenderer <NSObject>

- (void)prepare;
- (void)render;
- (void)cleanup;

- (void)setViewPortRect:(NSRect)frameRect;

@end
