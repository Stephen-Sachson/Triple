//
//  MagicCell.h
//  Triple
//
//  Created by deepfocus-004 on 8/27/14.
//  Copyright 2014 deepfocus-004. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

static const float fixedWidth = 64.0f;

@interface MagicCell : CCNode

@property (strong, nonatomic) CCSprite *spriteCell;
@property (nonatomic) NSInteger x, y, cellID;

+ (MagicCell *)cellWithImageNamed:(NSString *)name;
- (instancetype)initWithCellImageNamed:(NSString *)name;

@end
