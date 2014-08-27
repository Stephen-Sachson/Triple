//
//  IntroScene.h
//  Triple
//
//  Created by deepfocus-004 on 8/27/14.
//  Copyright deepfocus-004 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using cocos2d-v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "MagicCell.h"
// -----------------------------------------------------------------------

/**
 *  The intro scene
 *  Note, that scenes should now be based on CCScene, and not CCLayer, as previous versions
 *  Main usage for CCLayer now, is to make colored backgrounds (rectangles)
 *
 */
extern const float fixedWidth;

@interface FirstScene : CCScene

// -----------------------------------------------------------------------

+ (FirstScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end