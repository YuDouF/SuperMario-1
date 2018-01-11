//
//  MainMenu.m
//  Super Mario
//
//  Created by 周新哲 on 2018/1/3.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainMenu.h"
#import "GameScene.h"
#import "Global.h"
#import "SelectMenu.h"
#import "AboutMenu.h"
//#import "SetMusic.h"

@implementation MainMenu

- (id)init
{
    self = [super init];
    if(self){
        CGSize winSize = [[CCDirector sharedDirector] viewSize];
        
        CCSprite *pBackground = [CCSprite spriteWithImageNamed:@"background.png"];
        [pBackground setScaleX:winSize.width/pBackground.textureRect.size.width];
        [pBackground setPosition:ccp(winSize.width/2, winSize.height/2)];
        [self addChild:pBackground z:0];
        
        //menu
        CCSpriteFrame *pStartGameNormal = [CCSpriteFrame frameWithImageNamed:@"startgame_normal.png"];
        CCSpriteFrame *pStartGameSelect = [CCSpriteFrame frameWithImageNamed:@"startgame_select.png"];
        self.pStartGame = [CCButton buttonWithTitle:@"" spriteFrame:pStartGameNormal highlightedSpriteFrame:pStartGameNormal disabledSpriteFrame:pStartGameSelect];
        self.pStartGame.position = ccp(winSize.width/2, winSize.height/2);
        [self.pStartGame setTarget:self selector:@selector(menuCallBackForStartGame)];
        [self addChild:self.pStartGame z:1];
        CCSpriteFrame *pQuitGameNormal = [CCSpriteFrame frameWithImageNamed:@"quitgame_normal.png"];
        CCSpriteFrame *pQuitGameSelect = [CCSpriteFrame frameWithImageNamed:@"quitgame_select.png"];
        self.pQuit = [CCButton buttonWithTitle:@"" spriteFrame:pQuitGameNormal highlightedSpriteFrame:pQuitGameNormal disabledSpriteFrame:pQuitGameSelect];
        self.pQuit.position = ccp(winSize.width/2, winSize.height/2-40);
        [self.pQuit setTarget:self selector:@selector(menuQuit)];
        [self addChild:self.pQuit z:1];
        
        CCSpriteFrame *pAboutGameNormal = [CCSpriteFrame frameWithImageNamed:@"about_normal.png"];
        CCSpriteFrame *pAboutGameSelect = [CCSpriteFrame frameWithImageNamed:@"about_select.png"];
        self.pAbout = [CCButton buttonWithTitle:@"" spriteFrame:pAboutGameNormal highlightedSpriteFrame:pAboutGameNormal disabledSpriteFrame:pAboutGameSelect];
        self.pAbout.position = ccp(winSize.width-50, 20);
        [self.pAbout setTarget:self selector:@selector(menuCallBackForAbout)];
        [self addChild:self.pAbout z:1];
        
        CCSpriteFrame *pSettingGameNormal = [CCSpriteFrame frameWithImageNamed:@"Setting_n.png"];
        CCSpriteFrame *pSettingGameSelect = [CCSpriteFrame frameWithImageNamed:@"setting_s.png"];
        self.pSetting = [CCButton buttonWithTitle:@"" spriteFrame:pSettingGameNormal highlightedSpriteFrame:pSettingGameNormal disabledSpriteFrame:pSettingGameSelect];
        self.pSetting.position = ccp(winSize.width/2, winSize.height/2 - 80);
        [self.pSetting setTarget:self selector:@selector(menuSetting)];
        [self addChild:self.pSetting z:1];
    }
    return self;
}

-(void)menuCallBackForStartGame
{
    [[Global getGlobalInstance] setLifeNum:3];
    CCScene* selectMenu = [SelectMenu new];
    [[CCDirector sharedDirector] replaceScene:selectMenu];
}

-(void)menuCallBackForAbout
{
    CCScene *pScene = [[AboutMenu alloc] init];
    [[CCDirector sharedDirector] replaceScene:pScene];
}

-(void)menuQuit
{
    [[CCDirector sharedDirector] end];
}

-(void)menuSetting
{
    CCScene *pScene = [[CCScene alloc]init];
    //pScene->addChild(CCSetMusic::create());
    [[CCDirector sharedDirector] replaceScene:pScene];
}

@end








