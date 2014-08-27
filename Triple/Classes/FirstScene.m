//
//  IntroScene.m
//  Triple
//
//  Created by deepfocus-004 on 8/27/14.
//  Copyright deepfocus-004 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "FirstScene.h"

// -----------------------------------------------------------------------
#pragma mark - FirstScene
// -----------------------------------------------------------------------

@implementation FirstScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (FirstScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);

    // done
	return self;
}

// -----------------------------------------------------------------------
@end
