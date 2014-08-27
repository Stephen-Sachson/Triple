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

BOOL hasRoute () {
    return YES;
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
                    [prevCell removeChildByName:@"ak"];
                    
                    if (prevCell && weakCell.cellID == prevCell.cellID && hasRoute())
                    {
                        [self removeChild:weakCell];
                        [self removeChild:prevCell];
                        shouldRemoveBoth = YES;
                    }
                }
                
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
