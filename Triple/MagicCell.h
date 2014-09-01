//
//  MagicCell.h
//  Triple
//
//  Created by deepfocus-004 on 8/27/14.
//  Copyright 2014 deepfocus-004. All rights reserved.
//

typedef enum {
    DirectionUp,
    DirectionDown,
    DirectionLeft,
    DirectionRight
} Direction;

@protocol MagicCellDelegate;

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Configuration.h"

static const float fixedWidth = 64.0f;

@interface MagicCell : CCButton

@property (strong, nonatomic) CCSprite *spriteCell;
@property (strong, nonatomic) id<MagicCellDelegate> delegate;

@property (nonatomic) NSInteger x, y, cellID;

+ (MagicCell *)cellWithImageNamed:(NSString *)name;
- (instancetype)initWithCellImageNamed:(NSString *)name;

@end

@protocol MagicCellDelegate <NSObject>

- (BOOL)magicCell:(MagicCell *)aCell moveAtDirection:(Direction)dir;

@end