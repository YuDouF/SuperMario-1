//
//  AboutMenu.m
//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AboutMenu.h"
#import "MainMenu.h"

@implementation AboutMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGPoint origin = [[CCDirector sharedDirector] accessibilityActivationPoint];// getVisibleOrigin
        CGSize visibleSize = [[CCDirector sharedDirector] viewSize];
        
        CCSprite *pBg = [CCSprite spriteWithImageNamed:@"bg.png"];
        pBg.position = ccp(origin.x + visibleSize.width/2, origin.y + visibleSize.height/2);
        [self addChild:pBg];
        
        CCSprite *pZhy = [CCSprite spriteWithImageNamed:@"zhy.jpg"];
        pZhy.position = ccp(origin.x + visibleSize.width/2, origin.y + visibleSize.height/2 + 50);
        [self addChild:pZhy];
        
        CCSprite *pWxb = [CCSprite spriteWithImageNamed:@"wxb.jpg"];
        pWxb.position= ccp(origin.x + visibleSize.width/2, origin.y + visibleSize.height/2 - 50);
        [self addChild:pWxb];
        
        CCSpriteFrame *pBackNormal = [CCSpriteFrame frameWithImageNamed:@"backA.png"];
        CCSpriteFrame *pBackSelect = [CCSpriteFrame frameWithImageNamed:@"backB.png"];
        CCButton *pBack = [CCButton buttonWithTitle:@"" spriteFrame:pBackNormal highlightedSpriteFrame:pBackNormal disabledSpriteFrame:pBackSelect];
        pBack.position = ccp(origin.x + 20, origin.y + visibleSize.height - 20);
        [pBack setTarget:self selector:@selector(menuBack)];
        [pBack setZOrder:1];
        [self addChild:pBack];
    }
    return self;
}

-(void)menuBack
{
    MainMenu *pMainMenu = [[MainMenu alloc]init];
    CCScene *pScene = [[CCScene alloc]init];
    [pScene addChild:pMainMenu];
    [[CCDirector sharedDirector] replaceScene:pScene];
}

@end
