//
//  MagicCell.m
//  Triple
//
//  Created by deepfocus-004 on 8/27/14.
//  Copyright 2014 deepfocus-004. All rights reserved.
//

#import "MagicCell.h"

static const NSInteger magicDefaultValue = 0;

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

@end
