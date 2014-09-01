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
    
    removedCells = [[NSMutableArray alloc] initWithCapacity:10];
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"bg.jpg"];
    background.position = ccp(0, 0);
    background.anchorPoint = ccp(0, 0);
    [self addChild:background];
    
    srand((unsigned int)time(NULL));
    
    [self createCells];
    
    return self;
}

- (void)createCells
{
    CGSize winSize=[CCDirector sharedDirector].viewSize;
    
    numOfColumns=(NSInteger)floorf(winSize.width/fixedWidth);
    numOfRows=(NSInteger)floorf(winSize.height/fixedWidth);
    numOfPics=5;
    
    if (((int)numOfColumns * (int)numOfRows)%2 != 0) {
        if (numOfRows > numOfColumns) {
            numOfRows--;
        }
        else {
            numOfColumns--;
        }
    }
    
    for (int i=0; i<numOfRows; i++) {
        for (int j=0; j<numOfColumns; j++) {
            int r=rand()%numOfPics+1;
            MagicCell *cell = [MagicCell cellWithImageNamed:[NSString stringWithFormat:@"Orb_Icons_00%i.png",r]];
            [self addChild:cell z:2];
            cell.x=j;
            cell.y=i;
            cell.cellID=r;
            cell.name=[NSString stringWithFormat:@"%i%i",j,i];
            cell.enabled=NO;
            cell.delegate=self;
        }
    }
    
    [self placeCells];
}

- (void)placeCells
{
    CGSize winSize=[CCDirector sharedDirector].viewSize;
    biasX = winSize.width - (fixedWidth * numOfColumns);
    biasY = winSize.height - (fixedWidth * numOfRows);
    
    for (MagicCell *cell in self.children) {
        if ([cell isKindOfClass:[MagicCell class]]) {
            
            cell.anchorPoint=ccp(0, 0);
            cell.position = ccp((cell.x)*fixedWidth+biasX/2, (cell.y)*fixedWidth+biasY/2);
            
            for (int ii=0; ii<[removedCells count]; ii++)
            {
                if (cell.x == ((MagicCell *)[removedCells objectAtIndex:ii]).x)
                {
                    if (cell.y > ((MagicCell *)[removedCells objectAtIndex:ii]).y) {
                        CCActionSequence *seq=[CCActionSequence actionOne:[CCActionMoveBy actionWithDuration:0.15f position:ccp(0, -fixedWidth)] two:[CCActionCallBlock actionWithBlock:^{cell.y -= 1;}]];
                        [cell runAction:seq];
                    }
                }
            }
        }
    }
    
    for (int ii=0; ii<[removedCells count]; ii++) {
        MagicCell *reuseCell = [removedCells objectAtIndex:ii];
        
        int r=rand()%numOfPics+1;
        reuseCell.spriteCell = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"Orb_Icons_00%i.png",r]];
        reuseCell.cellID = r;
        reuseCell.y=numOfRows;
        reuseCell.anchorPoint=ccp(0, 0);
        reuseCell.position = ccp((reuseCell.x)*fixedWidth+biasX/2, (reuseCell.y)*fixedWidth+biasY/2);
        reuseCell.visible = YES;
        CCActionSequence *seq=[CCActionSequence actionOne:[CCActionMoveBy actionWithDuration:0.15f position:ccp(0, -fixedWidth)] two:[CCActionCallBlock actionWithBlock:^{reuseCell.y -= 1;}]];
        [reuseCell runAction:seq];
    }
    [removedCells removeAllObjects];
    
    [self checkMatch];
}

- (BOOL)checkMatch {
    return YES;
}

- (void)swapCell:(MagicCell *)cellOne withCell:(MagicCell *)cellTwo {
    ccBezierConfig bezier;
    bezier.endPosition = cellTwo.position;
    bezier.controlPoint_1 = ccp((cellTwo.position.x+cellOne.position.x)/2+5, cellOne.position.y+3);
    bezier.controlPoint_2 = ccp((cellOne.position.x+cellTwo.position.x)/2-5, cellOne.position.y+3);
    CCActionBezierTo *moveOne = [CCActionBezierTo actionWithDuration:0.3f bezier:bezier];
    CCActionScaleTo *large = [CCActionScaleTo actionWithDuration:0.15f scale:1.1];
    CCActionScaleTo *small = [CCActionScaleTo actionWithDuration:0.15f scale:1.0];
    CCActionSequence *scaleSeq = [CCActionSequence actionOne:large two:small];
    CCActionSpawn *spOne = [CCActionSpawn actionOne:moveOne two:scaleSeq];
    
    cellOne.zOrder+=10;
    [cellOne runAction:[CCActionSequence actionOne:spOne two:[CCActionCallBlock actionWithBlock:^{
        NSInteger tempX = cellOne.x;
        NSInteger tempY = cellOne.y;
        cellOne.x = cellTwo.x;
        cellOne.y = cellTwo.y;
        cellTwo.x = tempX;
        cellTwo.y = tempY;
        cellOne.zOrder-=10;
    }]]];
    
    ccBezierConfig bezier_;
    bezier_.endPosition = cellOne.position;
    bezier_.controlPoint_1 = ccp((cellTwo.position.x+cellOne.position.x)/2+5, cellOne.position.y-3);
    bezier_.controlPoint_2 = ccp((cellOne.position.x+cellTwo.position.x)/2-5, cellOne.position.y-3);
    CCActionBezierTo *moveTwo = [CCActionBezierTo actionWithDuration:0.3f bezier:bezier_];
    CCActionScaleTo *large_ = [CCActionScaleTo actionWithDuration:0.15f scale:1.0];
    CCActionScaleTo *small_ = [CCActionScaleTo actionWithDuration:0.15f scale:0.9];
    CCActionSequence *scaleSeq_ = [CCActionSequence actionOne:small_ two:large_];
    CCActionSpawn *spTwo = [CCActionSpawn actionOne:moveTwo two:scaleSeq_];
    [cellTwo runAction:spTwo];
}

- (BOOL)magicCell:(MagicCell *)aCell moveAtDirection:(Direction)dir
{
    switch (dir) {
        case DirectionUp:
            CCLOG(@"%li moved up", (long)aCell.cellID);
            break;
            
        case DirectionDown:
            CCLOG(@"%li moved down", (long)aCell.cellID);
            [removedCells addObject:aCell];
            aCell.visible = NO;
            [self placeCells];
            break;
            
        case DirectionLeft: {
            CCLOG(@"%li moved left", (long)aCell.cellID);
            for (MagicCell *cell in self.children) {
                if ([cell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x-1 && cell.y == aCell.y) {
                        [self swapCell:aCell withCell:cell];
                    }
                }
            }
        }
            break;
            
        case DirectionRight: {
            CCLOG(@"%li moved right", (long)aCell.cellID);
            for (MagicCell *cell in self.children) {
                if ([cell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x+1 && cell.y == aCell.y) {
                        [self swapCell:aCell withCell:cell];
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

@end
