//
//  SelectMenu.m
//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectMenu.h"
#import "MainMenu.h"
#import "Global.h"
#import "GameScene.h"

@implementation SelectMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.m_nCurPage = 1;
        CGPoint origin = [[CCDirector sharedDirector] accessibilityActivationPoint];
        CGSize visibleSize = [[CCDirector sharedDirector] viewSize];
        
        self.pScene = [[CCScene alloc]init];
        NSString *selectName = NULL;
        for (int i = 1; i <= [[Global getGlobalInstance] totalLevels]; ++i)
        {
            selectName = [NSString stringWithFormat:@"select%d.jpg", i];
            CCSprite *pSprite = [CCSprite spriteWithImageNamed:selectName];
            pSprite.position=ccp(visibleSize.width * (i-0.5f), visibleSize.height/2 + 10);
            [self.pScene addChild:pSprite z:0 name:[NSString stringWithFormat:@"%d",i]];
        }
        [self.pScene setContentSize:CGSizeMake(480*8, 320)];
        [self addChild:self.pScene z:1];
        
        CCSprite *pBg = [CCSprite spriteWithImageNamed:@"bg.png"];
        [pBg setScaleX:visibleSize.width/pBg.textureRect.size.width];
        pBg.position=ccp(origin.x + visibleSize.width/2, origin.y + visibleSize.height/2);
        [self addChild:pBg z:0];
        
        CCSpriteFrame *pNewGameNormal = [CCSpriteFrame frameWithImageNamed:@"newgameA.png"];
        CCSpriteFrame *pNewGameSelect = [CCSpriteFrame frameWithImageNamed:@"newgameB.png"];
        self.pNewGame = [CCButton buttonWithTitle:@"" spriteFrame:pNewGameNormal highlightedSpriteFrame:pNewGameNormal disabledSpriteFrame:pNewGameSelect];
        self.pNewGame.position = ccp(origin.x + visibleSize.width/2, 30);
        [self.pNewGame setTarget:self selector:@selector(menuBegin)];
        [self addChild:self.pNewGame z:2];
        
        CCSpriteFrame *pBackNormal = [CCSpriteFrame frameWithImageNamed:@"backA.png"];
        CCSpriteFrame *pBackSelect = [CCSpriteFrame frameWithImageNamed:@"backB.png"];
        CCButton *pBack = [CCButton buttonWithTitle:@"" spriteFrame:pBackNormal highlightedSpriteFrame:pBackNormal disabledSpriteFrame:pBackSelect];
        pBack.position = ccp(origin.x + 20, origin.y + visibleSize.height - 20);
        [pBack setTarget:self selector:@selector(menuBack)];
        [self addChild:pBack z:2];
        
        self.m_pLevel = [CCLabelTTF labelWithString:@"Level: 1" fontName:@"ArialMT" fontSize:20];
        self.m_pLevel.position=ccp(origin.x + visibleSize.width/2, origin.y + visibleSize.height - 20);
        [self addChild:self.m_pLevel z:3];
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"Level1"];
    }
    return self;
}

-(void)menuBegin{
    [[Global getGlobalInstance] setCurrentLevel:self.m_nCurPage];
    CCScene *pScene = [[GameScene alloc]init];
    [[CCDirector sharedDirector] replaceScene:pScene];
    
}

-(void)menuBack{
    CCScene *pScene = [[MainMenu alloc]init];
    [[CCDirector sharedDirector] replaceScene:pScene];
}

-(void)adjustView:(float)offset{
    CGPoint origin = [[CCDirector sharedDirector] accessibilityActivationPoint];
    CGSize visibleSize = [[CCDirector sharedDirector] viewSize];
    
    if (offset<0)
    {
        ++self.m_nCurPage;
    }else
    {
        --self.m_nCurPage;
    }
    
    if (self.m_nCurPage <1)
    {
        self.m_nCurPage = 1;
    }
    if (self.m_nCurPage > 8)
    {
        self.m_nCurPage = 8;
    }
    CGPoint adjustPos = ccp(origin.x - visibleSize.width * (self.m_nCurPage-1), 0);
    [self.pScene runAction:[CCActionMoveTo actionWithDuration:0.2f position:adjustPos]];
    
    NSString *str = [NSString stringWithFormat:@"Level: %d", self.m_nCurPage];
    [self.m_pLevel setString:str];
    str = [NSString stringWithFormat:@"Level%d", self.m_nCurPage];
    NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:str];
    if (![str1 isEqualToString:@"yes"])
    {
        [self.pNewGame setEnabled:NO];
    }else
    {
        [self.pNewGame setEnabled:YES];
    }
    
}

-(void)onEnter{
    [super onEnter];
    for (int i = 2; i <= 8; ++i)
    {
        NSString *ccStr = [NSString stringWithFormat:@"Level%d", i];
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:ccStr];
        if (![str isEqualToString:@"yes"])
        {
            CCNodeColor *pColor = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b: ccc4(0,0,0,200)]];
            CCSprite *pSp = (CCSprite*)[self.pScene getChildByName:[NSString stringWithFormat:@"%d",i] recursively:YES];
            [pColor setAnchorPoint:ccp(0.5, 0.5)];
            [pColor setPosition:pSp.position];
            [pColor setContentSize:pSp.contentSize];
            [self.pScene addChild:pColor z:[pSp zOrder]+1];
        }
    }
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    self.m_touchPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInWorld]];
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    CGPoint endPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInWorld]];
    float distance = endPoint.x - self.m_touchPoint.x;
    if(fabs(distance) > 5)
    {
        [self adjustView:distance];
    }
}

-(void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    CGPoint endPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInWorld]];
    float distance = endPoint.x - self.m_touchPoint.x;
    if(fabs(distance) > 5)
    {
        [self adjustView:distance];
    }
}
@end





