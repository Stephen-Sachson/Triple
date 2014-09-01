//
//  MagicCell.m
//  Triple
//
//  Created by deepfocus-004 on 8/27/14.
//  Copyright 2014 deepfocus-004. All rights reserved.
//

#import "MagicCell.h"

static const NSInteger magicDefaultValue = 0;

@interface MagicCell () {
    CGPoint touchBeganPos;
    BOOL shouldSwap;
    BOOL swapSuccessfully;
}

@end

@implementation MagicCell

+ (MagicCell *)cellWithImageNamed:(NSString *)name {
    return [[MagicCell alloc] initWithCellImageNamed:name];
}

- (instancetype)initWithCellImageNamed:(NSString *)name
{
    if (self = [super init]) {
        self.contentSize = CGSizeMake(fixedWidth, fixedWidth);
        
        self.spriteCell = [CCSprite spriteWithImageNamed:name];
        [self addChild:_spriteCell z:-1];
        
        _spriteCell.anchorPoint = CGPointZero;
        _spriteCell.contentSize = self.contentSize;
        
        self.x = magicDefaultValue;
        self.y = magicDefaultValue;
        self.cellID = magicDefaultValue;
    }
    
    return self;
}

- (void)setContentSize:(CGSize)contentSize
{
    if (contentSize.width == fixedWidth && contentSize.height == fixedWidth)
    return;
    
    _contentSize = CGSizeMake(fixedWidth, fixedWidth);
}

#ifdef Triple_Configuration_h
#if Game_Mode
#define kTriggerDistance 32.0f

- (void)onEnter {
    [super onEnter];
    self.userInteractionEnabled = YES;
    shouldSwap = NO;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [super touchBegan:touch withEvent:event];
//    CCLOG(@"touch");
    touchBeganPos = [touch locationInWorld];
    shouldSwap = YES;
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    [super touchMoved:touch withEvent:event];
    
    if (shouldSwap)
    {
        CGPoint currentPos = [touch locationInWorld];
        
        if (currentPos.x > touchBeganPos.x + kTriggerDistance)
        {
//            CCLOG(@"move right");
            swapSuccessfully = [self.delegate moveAtDirection:DirectionRight];
            shouldSwap = NO;
        }
        else if (touchBeganPos.x > currentPos.x + kTriggerDistance) {
//            CCLOG(@"move left");
            swapSuccessfully = [self.delegate moveAtDirection:DirectionLeft];
            shouldSwap = NO;
        }
        else if (currentPos.y > touchBeganPos.y + kTriggerDistance) {
//            CCLOG(@"move up");
            swapSuccessfully = [self.delegate moveAtDirection:DirectionUp];
            shouldSwap = NO;
        }
        else if (touchBeganPos.y > currentPos.y + kTriggerDistance) {
//            CCLOG(@"move down");
            swapSuccessfully = [self.delegate moveAtDirection:DirectionDown];
            shouldSwap = NO;
        }
    }
}


#endif
#endif

@end
