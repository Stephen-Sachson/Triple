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

@interface FirstScene () {
    NSInteger numOfColumns;
    NSInteger numOfRows;
}

@end

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

    [self createCells];
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)createCells
{
    CGSize winSize=[CCDirector sharedDirector].viewSize;
    
    numOfColumns=(NSInteger)floorf(winSize.width/fixedWidth);
    numOfRows=(NSInteger)floorf(winSize.height/fixedWidth);
    
    for (int i=0; i<numOfRows; i++) {
        for (int j=0; j<numOfColumns; j++) {
            int r=rand()%3;
            MagicCell *cell = [MagicCell cellWithImageNamed:[NSString stringWithFormat:@"cell%i.jpg",r]];
            [self addChild:cell];
            cell.x=j;
            cell.y=i;
            cell.cellID=r;
        }
    }
    
    [self placeCells];
}

- (void)placeCells
{
    CGSize winSize=[CCDirector sharedDirector].viewSize;
    int biasX = winSize.width - (fixedWidth * numOfColumns);
    int biasY = winSize.height - (fixedWidth * numOfRows);
    
    for (MagicCell *cell in self.children) {
        if ([cell isKindOfClass:[MagicCell class]]) {
            cell.position = ccp((cell.x)*fixedWidth+biasX/2, (cell.y)*fixedWidth+biasY/2);
        }
    }
}

@end
