//
//  SecondScene.h
//  Triple
//
//  Created by deepfocus-004 on 9/1/14.
//  Copyright 2014 deepfocus-004. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MagicCell.h"

extern const float fixedWidth;

@protocol MagicCellDelegate;

@interface SecondScene : CCScene <MagicCellDelegate> {
    NSInteger numOfRows;
    NSInteger numOfColumns;
    
    int numOfPics;
    float biasX;
    float biasY;
    
    NSMutableArray *removedCells;
    NSMutableDictionary *columnCounterPairs;
    
    BOOL canMove;
}

+ (SecondScene *)scene;
- (id)init;

@end
