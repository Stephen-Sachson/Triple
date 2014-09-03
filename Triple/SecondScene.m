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
    columnCounterPairs = [[NSMutableDictionary alloc] initWithCapacity:10];
    canMove = YES;
    
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
    
    [self placeCells:YES];
}

- (void)placeCells:(BOOL)shouldLayout
{
    CCLOG(@"place cells");
    
    canMove = NO;
    
    if (shouldLayout)
    {
        CGSize winSize=[CCDirector sharedDirector].viewSize;
        biasX = winSize.width - (fixedWidth * numOfColumns);
        biasY = winSize.height - (fixedWidth * numOfRows);
        for (MagicCell *cell in self.children) {
            if ([cell isKindOfClass:[MagicCell class]]) {
                cell.anchorPoint=ccp(0, 0);
                cell.position = ccp((cell.x)*fixedWidth+biasX/2, (cell.y)*fixedWidth+biasY/2);
            }
        }
    }
    
    /* Adding the key of column in dictionary with value plus 1.
     * This is for retrieving and calculating the position of cell in next loop.
     */
    for (int ii=0; ii<[removedCells count]; ii++)
    {
        MagicCell *reuseCell = [removedCells objectAtIndex:ii];
        
        NSString *column = [[NSString alloc] initWithFormat:@"%li", (long)reuseCell.x];
        
        BOOL shouldAdd = YES;
        
        for (NSString *key in [[columnCounterPairs keyEnumerator] allObjects])
        {
            //            CCLOG(@"key for loop:%@",key);
            
            if ([key isKindOfClass:[NSString class]] && [key isEqualToString:column]) {
                shouldAdd = NO;
                break;
            }
        }
        
        if (shouldAdd) {
            [columnCounterPairs addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@1 forKey:column]];
        }
        else {
            [columnCounterPairs setObject:@([[columnCounterPairs objectForKey:column] integerValue]+1) forKey:column];
        }
    }
    
    NSArray *keys = [[columnCounterPairs keyEnumerator] allObjects];
    
    for (int ii=0; ii<[keys count]; ii++)
    {
        NSInteger col = [[keys objectAtIndex:ii] integerValue];
        NSInteger maxRmCellY = -1;
        for (MagicCell *rmCell in removedCells) {
            if ([rmCell isKindOfClass:[MagicCell class]]) {
                if (rmCell.x == col) {
                    maxRmCellY = MAX(maxRmCellY, rmCell.y);
                }
            }
        }
        for (MagicCell *cell in self.children) {
            if ([cell isKindOfClass:[MagicCell class]]) {
                if (cell.x == col) {
                    if (cell.y > maxRmCellY) {
                        NSInteger counter=[[columnCounterPairs objectForKey:[keys objectAtIndex:ii]] integerValue];
                        CCActionSequence *seq=[CCActionSequence actionOne:[CCActionMoveBy actionWithDuration:0.25f*counter position:ccp(0, -fixedWidth*counter)] two:[CCActionCallBlock actionWithBlock:^{cell.y -= counter;}]];
                        [cell runAction:seq];
                    }
                }
            }
        }
        
        int ascend = 0;
        for (MagicCell *reuseCell in removedCells) {
            if ([reuseCell isKindOfClass:[MagicCell class]]) {
                if (reuseCell.x == col) {
                    NSInteger counter=[[columnCounterPairs objectForKey:[keys objectAtIndex:ii]] integerValue];
                    int r=rand()%numOfPics+1;
                    reuseCell.spriteCell = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"Orb_Icons_00%i.png",r]];
                    reuseCell.cellID = r;
                    reuseCell.y=numOfRows+ascend;
                    reuseCell.position = ccp((reuseCell.x)*fixedWidth+biasX/2, (reuseCell.y)*fixedWidth+biasY/2);
                    reuseCell.visible = YES;
                    CCActionSequence *seq=[CCActionSequence actionOne:[CCActionMoveBy actionWithDuration:0.25f*counter position:ccp(0, -fixedWidth*counter)] two:[CCActionCallBlock actionWithBlock:^{reuseCell.y -= counter;}]];
                    [reuseCell runAction:seq];
                    ascend++;
                }
            }
        }
    }
    
    [columnCounterPairs removeAllObjects];
    
    [self performSelector:@selector(placeCellsWithCheck) withObject:nil afterDelay:1.5f];
}

- (void)placeCellsWithCheck {
    if([self checkMatch]) [self placeCells:NO];
    else canMove = YES;
}

- (BOOL)checkMatch {
    CCLOG(@"check");
    [removedCells removeAllObjects];
    for (MagicCell *cell in self.children) {
        if ([cell isKindOfClass:[MagicCell class]])
        {
            MagicCell *u1, *u2, *d1, *d2, *l1, *l2, *r1, *r2;
            
            for (MagicCell *aCell in self.children) {
                if ([aCell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x && cell.y == aCell.y+1) {
                        u1 = aCell;
                    }
                }
                if ([aCell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x && cell.y == aCell.y+2) {
                        u2 = aCell;
                    }
                }
                if ([aCell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x && cell.y == aCell.y-1) {
                        d1 = aCell;
                    }
                }
                if ([aCell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x && cell.y == aCell.y-2) {
                        d2 = aCell;
                    }
                }
                if ([aCell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x-1 && cell.y == aCell.y) {
                        l1 = aCell;
                    }
                }
                if ([aCell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x-2 && cell.y == aCell.y) {
                        l2 = aCell;
                    }
                }
                if ([aCell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x+1 && cell.y == aCell.y) {
                        r1 = aCell;
                    }
                }
                if ([aCell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x+2 && cell.y == aCell.y) {
                        r2 = aCell;
                    }
                }
            }
            
            
            if (cell.cellID == u1.cellID) {
                if (cell.cellID == u2.cellID || cell.cellID == d1.cellID) {
                    [removedCells addObject:cell];
                    [cell burst];
                    continue;
                }
            }
            if (cell.cellID == d1.cellID && cell.cellID == d2.cellID) {
                [removedCells addObject:cell];
                [cell burst];
                continue;
            }
            if (cell.cellID == l1.cellID) {
                if (cell.cellID == l2.cellID || cell.cellID == r1.cellID) {
                    [removedCells addObject:cell];
                    [cell burst];
                    continue;
                }
            }
            if (cell.cellID == r1.cellID && cell.cellID == r2.cellID) {
                [removedCells addObject:cell];
                [cell burst];
                continue;
            }
        }
    }
    
    if (removedCells.count >=3) {
        return YES;
    }
    return NO;
}

- (void)swapCell:(MagicCell *)cellOne withCell:(MagicCell *)cellTwo {
    [self swapCell:cellOne withCell:cellTwo doCheck:YES];
}

- (void)swapCell:(MagicCell *)cellOne withCell:(MagicCell *)cellTwo doCheck:(BOOL)shouldCheck{
    if ([cellOne isEqual:cellTwo] || !canMove) {
        return;
    }
    canMove = NO;
    
    ccBezierConfig bezier;
    bezier.endPosition = cellTwo.position;
    if (cellOne.x != cellTwo.x) {
        bezier.controlPoint_1 = ccp((cellTwo.position.x+cellOne.position.x)/2+5, cellOne.position.y+2);
        bezier.controlPoint_2 = ccp((cellOne.position.x+cellTwo.position.x)/2-5, cellOne.position.y+2);
    }
    else if (cellOne.y != cellTwo.y) {
        bezier.controlPoint_1 = ccp(cellOne.position.x+2, (cellTwo.position.y+cellOne.position.y)/2+5);
        bezier.controlPoint_2 = ccp(cellOne.position.x+2, (cellOne.position.y+cellTwo.position.y)/2-5);
    }
    
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
    if (cellOne.x != cellTwo.x) {
        bezier_.controlPoint_1 = ccp((cellTwo.position.x+cellOne.position.x)/2+5, cellOne.position.y-2);
        bezier_.controlPoint_2 = ccp((cellOne.position.x+cellTwo.position.x)/2-5, cellOne.position.y-2);
    }
    else if (cellOne.y != cellTwo.y) {
        bezier_.controlPoint_1 = ccp(cellOne.position.x-2, (cellTwo.position.y+cellOne.position.y)/2+5);
        bezier_.controlPoint_2 = ccp(cellOne.position.x-2, (cellOne.position.y+cellTwo.position.y)/2-5);
    }
    CCActionBezierTo *moveTwo = [CCActionBezierTo actionWithDuration:0.3f bezier:bezier_];
    CCActionScaleTo *large_ = [CCActionScaleTo actionWithDuration:0.15f scale:1.0];
    CCActionScaleTo *small_ = [CCActionScaleTo actionWithDuration:0.15f scale:0.9];
    CCActionSequence *scaleSeq_ = [CCActionSequence actionOne:small_ two:large_];
    CCActionSpawn *spTwo = [CCActionSpawn actionOne:moveTwo two:scaleSeq_];
    [cellTwo runAction:[CCActionSequence actionOne:spTwo two:[CCActionCallBlock actionWithBlock:^{
        canMove = YES;
        if (shouldCheck) {
            if([self checkMatch])
                [self placeCells:NO];
            else
                [self swapCell:cellOne withCell:cellTwo doCheck:NO];
        }
    }]]];
}

- (BOOL)magicCell:(MagicCell *)aCell moveAtDirection:(Direction)dir
{
    switch (dir) {
        case DirectionUp: {
//            CCLOG(@"%li moved up", (long)aCell.cellID);
            for (MagicCell *cell in self.children) {
                if ([cell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x && cell.y == aCell.y+1) {
                        [self swapCell:aCell withCell:cell];
                    }
                }
            }
        }
            break;
            
        case DirectionDown: {
//            CCLOG(@"%li moved down", (long)aCell.cellID);
            for (MagicCell *cell in self.children) {
                if ([cell isKindOfClass:[MagicCell class]]) {
                    if (cell.x == aCell.x && cell.y == aCell.y-1) {
                        [self swapCell:aCell withCell:cell];
                    }
                }
            }
        }
            break;
            
        case DirectionLeft: {
//            CCLOG(@"%li moved left", (long)aCell.cellID);
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
//            CCLOG(@"%li moved right", (long)aCell.cellID);
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
