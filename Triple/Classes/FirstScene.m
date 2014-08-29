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

static const int numOfPics = 5;
int shit=0;
typedef struct pos {
    int x;
    int y;
} DotPosition;

DotPosition dPos (int x, int y) {
    DotPosition p;
    p.x=x;
    p.y=y;
    return p;
}

BOOL sameDot (DotPosition pf, DotPosition pt) {
    if (pf.x == pt.x && pf.y == pt.y) {
        return YES;
    }
    return NO;
}

BOOL withinDots(int src, int x, int y) {
    if (x > y) {
        int a = x;
        x = y;
        y = a;
    }
    if (src > x && src <y) {
        return YES;
    }
    return NO;
}

BOOL safeRet (bool check) {
    shit = 0;
    return check;
}

BOOL hasRoute (DotPosition from, DotPosition to, DotPosition *occupiedPos, int width, int height)
{
    /**********                NO TURN                 **********/
    
    bool meetOnX = YES;
    bool meetOnY = YES;
    
    for (int kk=0; kk < shit; kk++) {
//        printf("%i",occupiedPos[kk].x);
        if (from.y == to.y && to.y == occupiedPos[kk].y) {
            if (withinDots(occupiedPos[kk].x, from.x, to.x)) {
                meetOnX = NO;
                continue;
            }
        }
    }
//    printf("\n");
    for (int kk=0; kk < shit; kk++) {
        if (from.x == to.x && to.x == occupiedPos[kk].x) {
            if (withinDots(occupiedPos[kk].y, from.y, to.y)) {
                meetOnY = NO;
                continue;
            }
        }
    }
    
    if (from.x == to.x && meetOnY) {
        return safeRet(YES);
    }
    if (from.y == to.y && meetOnX) {
        shit = 0;
        return safeRet(YES);
    }
    
    /**********                UNI-TURN                 **********/
    
    /*F****** top ******ct
     *                   *
     *                   *
     *                   *
     left              right
     *                   *
     *                   *
     *                   *
     cb****  bottom  ***T*/
    
    bool uniTop = YES;
    bool uniLeft = YES;
    bool uniRight = YES;
    bool uniBottom = YES;
    bool uniCornerB = YES;
    bool uniCornerT = YES;
    
    if (from.x != to.x && from.y != to.y)
    {
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].y == from.y) {
                if(withinDots(occupiedPos[kk].x, from.x, to.x)) {
                    uniTop = NO;
                    continue;
                }
            }
        }
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].y == to.y) {
                if(withinDots(occupiedPos[kk].x, from.x, to.x)) {
                    uniBottom = NO;
                    continue;
                }
            }
        }
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].x == from.x) {
                if(withinDots(occupiedPos[kk].y, from.y, to.y)) {
                    uniLeft = NO;
                    continue;
                }
            }
        }
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].x == to.x) {
                if(withinDots(occupiedPos[kk].y, from.y, to.y)) {
                    uniRight = NO;
                    continue;
                }
            }
        }
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].x == to.x && occupiedPos[kk].y == from.y) {
                uniCornerT = NO;
                continue;
            }
        }
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].x == from.x && occupiedPos[kk].y == to.y) {
                uniCornerB = NO;
                continue;
            }
        }
    
        if (uniTop && uniRight && uniCornerT) {
            return safeRet(YES);
        }
        if (uniLeft && uniBottom && uniCornerB) {
            return safeRet(YES);
        }
    }
    
    /**********                DUAL-TURN                 **********/
    
    // Horizontal
    DotPosition posF[height+1], posT[height+1];
    bool legal = YES;
    int counter = 0;
    
    for (int i=from.y; i<height; i++) {
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].x == from.x) {
                if (sameDot(occupiedPos[kk], dPos(from.x, i+1))) {
                    legal = NO;
                    continue;
                }
            }
        }
        if (legal) {
            posF[i-from.y]=dPos(from.x, i+1);
            counter++;
            continue;
        }
    }
    legal = YES;
    for (int i=from.y; i>-1; i--) {
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].x == from.x) {
                if (sameDot(occupiedPos[kk], dPos(from.x, i-1))) {
                    legal = NO;
                    continue;
                }
            }
        }
        if (legal) {
            posF[counter]=dPos(from.x, i-1);
            counter++;
            continue;
        }
    } // init pos f
    
    legal = YES;
    int counter_ = 0;
    
    for (int i=to.y; i<height; i++) {
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].x == to.x) {
                if (sameDot(occupiedPos[kk], dPos(to.x, i+1))) {
                    legal = NO;
                    continue;
                }
            }
        }
        if (legal) {
            posT[i-to.y]=dPos(to.x, i+1);
            counter_++;
        }
        else {
            continue;
        }
    }
    legal = YES;
    for (int i=to.y; i>-1; i--) {
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].x == to.x) {
                if (sameDot(occupiedPos[kk], dPos(to.x, i-1))) {
                    legal = NO;
                    continue;
                }
            }
        }
        if (legal) {
            posT[counter_]=dPos(to.x, i-1);
            counter_++;
        }
        else {
            continue;
        }
    } // init pos t
    
    legal = YES;
    for (int hi=0; hi<counter; hi++) {
        for (int ih=0; ih<counter_; ih++) {
           
            if(posF[hi].y == posT[ih].y) {
                for (int kk = 0; kk < shit; kk++) {
                    if (occupiedPos[kk].y == posF[hi].y) {
                        if (withinDots(occupiedPos[kk].x, posF[hi].x, posT[ih].x)) {
                            legal = NO;
                        }
                    }
                }
                if (legal) {
                    return safeRet(YES);
                }
            }
        }
    }
    // Vertical
    DotPosition _posF[width+1], _posT[width+1];
    legal = YES;
    int _counter = 0;
    
    for (int i=from.x; i<width; i++) {
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].y == from.y) {
                if (sameDot(occupiedPos[kk], dPos(i+1,from.y))) {
                    legal = NO;
                    continue;
                }
            }
        }
        if (legal) {
            _posF[i-from.x]=dPos(i+1, from.y);
            _counter++;
            continue;
        }
    }
    legal = YES;
    for (int i=from.x; i>-1; i--) {
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].y == from.y) {
                if (sameDot(occupiedPos[kk], dPos(i-1, from.y))) {
                    legal = NO;
                    continue;
                }
            }
        }
        if (legal) {
            _posF[_counter]=dPos(i-1, from.y);
            _counter++;
            continue;
        }
    } // init pos f
    
    legal = YES;
    int _counter_ = 0;
    
    for (int i=to.x; i<width; i++) {
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].y == to.y) {
                if (sameDot(occupiedPos[kk], dPos(i+1, to.y))) {
                    legal = NO;
                    continue;
                }
            }
        }
        if (legal) {
            _posT[i-to.x]=dPos(i+1, to.y);
            _counter_++;
            continue;
        }
    }
    legal = YES;
    for (int i=to.x; i>-1; i--) {
        for (int kk = 0; kk < shit; kk++)
        {
            if (occupiedPos[kk].y == to.y) {
                if (sameDot(occupiedPos[kk], dPos(i-1, to.y))) {
                    legal = NO;
                    continue;
                }
            }
        }
        if (legal) {
            _posT[_counter_]=dPos(i-1, to.y);
            _counter_++;
            continue;
        }
    } // init pos t
    
//     CCLOG(@"F:%i  T:%i",_counter,_counter_);
    legal = YES;
    for (int hi=0; hi<_counter; hi++) {
        for (int ih=0; ih<_counter_; ih++) {
//             CCLOG(@"F(%i, %i)  T(%i, %i)",_posF[hi].x, _posF[hi].y, _posT[ih].x, _posT[ih].y);
            if(_posF[hi].x == _posT[ih].x) {
                for (int kk = 0; kk < shit; kk++) {
                    if (occupiedPos[kk].x == _posF[hi].x) {
                        if (withinDots(occupiedPos[kk].y, _posF[hi].y, _posT[ih].y)) {
                            legal = NO;
                        }
                    }
                }
                if (legal) {
                    return safeRet(YES);
                }
            }
        }
    }
    
    return safeRet(NO);
}

@interface FirstScene () {
    NSInteger numOfColumns;
    NSInteger numOfRows;
    MagicCell *prevCell;
    
    BOOL shouldRemoveBoth;
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
    
    self.userInteractionEnabled=NO;
    shouldRemoveBoth=NO;
    
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
            int r=rand()%numOfPics;
            MagicCell *cell = [MagicCell cellWithImageNamed:[NSString stringWithFormat:@"cell%i.jpg",r]];
            [self addChild:cell z:2];
            cell.x=j;
            cell.y=i;
            cell.cellID=r;
            cell.name=[NSString stringWithFormat:@"%i%i",j,i];
            cell.enabled=YES;
            __weak MagicCell *weakCell=cell;
            cell.block=^(id sender) {
                
//          CCLOG(@"(%li, %li) id:%li", (long)weakCell.x, (long)weakCell.y,(long)weakCell.cellID);
                
                if(prevCell) {
                    if ([prevCell isEqual:weakCell]) return;
                    
                    [prevCell removeChildByName:@"ak"];
                    
                    if (prevCell && weakCell.cellID == prevCell.cellID)
                    {
                        DotPosition fr;
                        fr.x=(int)weakCell.x;
                        fr.y=(int)weakCell.y;
                        
                        DotPosition to;
                        to.x=(int)prevCell.x;
                        to.y=(int)prevCell.y;
                        
                        DotPosition dots[100];
                        for (MagicCell *aCell in self.children) {
                            if ([aCell isKindOfClass:[MagicCell class]]) {
                                dots[shit]=dPos((int)aCell.x, (int)aCell.y);
                                shit++;
                            }
                        }
                        if (hasRoute(fr,to,dots,(int)numOfRows,(int)numOfColumns)) {
                            [self removeChild:weakCell];
                            [self removeChild:prevCell];
                            shouldRemoveBoth = YES;
                        }
                    }
                }
                /***************** end of block *******************/
                const CGPoint points[]= {ccp(1, 1), ccp(1, fixedWidth-1), ccp(fixedWidth-1, fixedWidth-1), ccp(fixedWidth-1, 1)};
                CCDrawNode *drawNode=[CCDrawNode node];
                drawNode.name=@"ak";
                [weakCell addChild:drawNode];
                
                [drawNode drawPolyWithVerts:points count:4 fillColor:nil borderWidth:2 borderColor:[CCColor colorWithUIColor:[UIColor greenColor]]];
                prevCell=shouldRemoveBoth?nil:weakCell;
                shouldRemoveBoth = NO;
            };
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
            cell.anchorPoint=ccp(0, 0);
            cell.position = ccp((cell.x)*fixedWidth+biasX/2, (cell.y)*fixedWidth+biasY/2);
        }
    }
}

@end
