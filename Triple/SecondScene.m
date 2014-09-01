//
//  SecondScene.m
//  Triple
//
//  Created by deepfocus-004 on 9/1/14.
//  Copyright 2014 deepfocus-004. All rights reserved.
//

#import "SecondScene.h"

@implementation SecondScene

+ (SecondScene *)scene {
    return [[SecondScene alloc] init];
}

- (id)init {
    self = [super init];
    if (!self) return(nil);
    
    MagicCell *cell=[[MagicCell alloc] initWithCellImageNamed:@"cell0.jpg"];
    cell.delegate = self;
    [self addChild:cell];
    
    cell.positionType = CCPositionTypeNormalized;
    cell.position = ccp(0.5, 0.5);
    
    return self;
}

- (BOOL)moveAtDirection:(Direction)dir {
    switch (dir) {
        case DirectionUp:
            CCLOG(@"moved up");
            break;
        case DirectionDown:
            CCLOG(@"moved down");
            break;
        case DirectionLeft:
            CCLOG(@"moved left");
            break;
        case DirectionRight:
            CCLOG(@"moved right");
            break;
            
        default:
            break;
    }
    
    return YES;
}

@end
