//
//  SDAppDelegate.m
//  Haruhi
//
//  Created by Sylvain Defresne on 15/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#import "SDAppDelegate.h"

@implementation SDAppDelegate

@synthesize window = window_;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}

@end
