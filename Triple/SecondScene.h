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

@protocol MagicCellDelegate;

@interface SecondScene : CCScene <MagicCellDelegate> {
    
}

+ (SecondScene *)scene;
- (id)init;

@end
