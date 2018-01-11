//
//  GameLayer.m
//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"
#include "GameMap.h"
#include "Hero.h"
#include "AnimationManager.h"
#include "Item.h"
#include "MainMenu.h"
#include "Global.h"
#include "OALSimpleAudio.h"
#include "SelectMenu.h"

@implementation GameScene

static float mapMaxH;   //场景左侧滑过地图的水平距离

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mainMap = nil;
        self.hero = nil;
        mapMaxH = 0.0f;
        self.mapBeginPos = ccp(0.0f, 96.0f);
        self.birthPoint = ccp(180.0f, 32.0f);
        
        self.isKeyDownA = NO;
        self.isKeyDownD = NO;
        self.isSky = NO;
        self.heroFireable = YES;
        
        self.moveOffset = 0.0f;
        self.moveDelta = 0.0f;
        self.jumpOffset = 0.0f;
        
        self.ccMoveDelta = 0.05f;
        self.ccMoveOffset = 2.0f;
        self.ccJumpOffset = 0.3f;
        self.currentPos = ccp(0.0f, 0.0f);
        
        CGSize winsize = [[CCDirector sharedDirector] viewSize];
        self.heroAnchor = ccp(winsize.width/2 - 80, winsize.height/2);
        
        self.backKeyPos = ccp(84, 48);
        self.leftKeyPos = ccp(40, 48);
        self.rightKeyPos = ccp(128, 48);
        self.jumpKeyPos = ccp(508, 35);
        self.fireKeyPos = ccp(415, 35);
        self.mSetKeyPos = ccp(320, 33);
        
        self.fireBallPos = ccp(winsize.width - 70, winsize.height - 20);
        self.arrowPos = ccp(winsize.width - 30, winsize.height - 20);
        
        self.mainScene = [[CCScene alloc]init];
        self.isPass = NO;
        
        self.isLeftKeyDown = NO;
        self.isRightKeyDown = NO;
        self.isJumpKeyDown = NO;
        self.isFireKeyDown = NO;
        //[[OALSimpleAudio sharedInstance] playBg:@"OnLand.ogg" loop:YES];
        self.pMenu = [[CCScene alloc] init];
        [self initHeroAndMap];
        [self initControlUI];
        [self initBulletUI];
        [self initRect];
        [self initSetMenu];
        self.userInteractionEnabled = YES;
        [self setMultipleTouchEnabled:YES];
    }
    return self;
}

-(void) initHeroAndMap{
    NSString* temp = [NSString stringWithFormat:@"MarioMap%d.tmx",[[Global getGlobalInstance] currentLevel]];
    self.mainMap = [GameMap create:temp];
    
    self.mapSize = CGSizeMake([self.mainMap mapSize].width * [self.mainMap tileSize].width, [self.mainMap mapSize].height * [self.mainMap tileSize].height);
    [self.mainMap setPosition:ccp(0, 0)];
    [self.mainScene addChild:self.mainMap];
    self.hero = [[Hero alloc]init];
    [self.hero setBodyType:[Global getGlobalInstance].currentHeroType];
    [self.hero setAnchorPoint:ccp(0.5f, 0.0f)];
    [self.hero setPosition:[self.mainMap marioBirthPos]];
    self.heroSize = [self.hero currentSize];
    [self.mainScene addChild:self.hero];
    [self.mainScene setPosition:self.mapBeginPos];
    [self addChild:self.mainScene];
}

-(void) initControlUI{
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    self.controlUI = [CCSprite spriteWithImageNamed:@"controlUI.png"];
    [self.controlUI setAnchorPoint:ccp(0, 0)];
    [self.controlUI setScaleX:winSize.width/self.controlUI.textureRect.size.width];
    [self addChild:self.controlUI];
    
    self.pGameOverBack = [CCSprite spriteWithImageNamed:@"gameover.png"];
    [self.pGameOverBack setPosition:ccp(winSize.width/2, winSize.height/2 + 50)];
    [self addChild:self.pGameOverBack];
    [self.pGameOverBack setVisible:NO];
    
    self.pPassFailure = [CCSprite spriteWithImageNamed:@"PassFailure.png"];
    [self.pPassFailure setPosition:ccp(winSize.width/2, winSize.height/2 + 50)];
    [self addChild:self.pPassFailure];
    [self.pPassFailure setVisible:NO];
    
    self.pPassSuccess = [CCSprite spriteWithImageNamed:@"PassSuccess.png"];
    [self.pPassSuccess setPosition:ccp(winSize.width/2, winSize.height/2 + 50)];
    [self addChild:self.pPassSuccess];
    [self.pPassSuccess setVisible:NO];
    
    self.pBackKeyImage = [CCSprite spriteWithImageNamed:@"backKeyImage.png"];
    [self.pBackKeyImage setPosition:self.backKeyPos];
    [self addChild:self.pBackKeyImage];
    
    self.pBackKeyNormal = [CCSpriteFrame frameWithTextureFilename:@"backKeyImage.png" rectInPixels:CGRectMake(0, 0, 72, 72) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(72, 72)];
	self.pBackKeyLeft = [CCSpriteFrame frameWithTextureFilename:@"backKeyLeft.png" rectInPixels:CGRectMake(0, 0, 72, 72) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(72, 72)];
	self.pBackKeyRight = [CCSpriteFrame frameWithTextureFilename:@"backKeyRight.png" rectInPixels:CGRectMake(0, 0, 72, 72) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(72, 72)];
    self.pAB_Normal = [CCSpriteFrame frameWithTextureFilename:@"AB_normal.png" rectInPixels:CGRectMake(0, 0, 72, 50) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(72, 50)];
    self.pAB_Selected = [CCSpriteFrame frameWithTextureFilename:@"AB_select.png" rectInPixels:CGRectMake(0, 0, 72, 50) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(72, 50)];
    
    self.pJumpImage = [CCSprite spriteWithSpriteFrame:self.pAB_Normal];
    [self.pJumpImage setPosition:self.jumpKeyPos];
    [self addChild:self.pJumpImage z:3];
    self.pFireImage = [CCSprite spriteWithSpriteFrame:self.pAB_Normal];
    [self.pFireImage setPosition:self.fireKeyPos];
    [self addChild:self.pFireImage z:3];
    
    CCSpriteFrame *pLeftRightKeyNormal = [CCSpriteFrame frameWithImageNamed:@"leftright.png"];
    self.pLeftKey = [CCButton buttonWithTitle:@"" spriteFrame:pLeftRightKeyNormal];
    [self.pLeftKey setTarget:self selector:@selector(menuCallBackLeftKey)];
    self.pRightKey = [CCButton buttonWithTitle:@"" spriteFrame:pLeftRightKeyNormal];
    [self.pRightKey setTarget:self selector:@selector(menuCallBackRightKey)];
    
    CCSpriteFrame *pABKeyNormal = [CCSpriteFrame frameWithImageNamed:@"AB_normal.png"];
    CCSpriteFrame *pABKeySelect = [CCSpriteFrame frameWithImageNamed:@"AB_select.png"];
    self.pJump = [CCButton buttonWithTitle:@"" spriteFrame:pABKeyNormal highlightedSpriteFrame:pABKeyNormal disabledSpriteFrame:pABKeySelect];
    [self.pJump setTarget:self selector:@selector(menuCallBackJumpKey)];
    self.pFire = [CCButton buttonWithTitle:@"" spriteFrame:pABKeyNormal highlightedSpriteFrame:pABKeyNormal disabledSpriteFrame:pABKeySelect];
    [self.pFire setTarget:self selector:@selector(menuCallBackFireKey)];
    CCSpriteFrame *pMSetKeyNormal = [CCSpriteFrame frameWithImageNamed:@"M_n.png"];
    CCSpriteFrame *pMSetKeySelect = [CCSpriteFrame frameWithImageNamed:@"M_s.png"];
    self.pMSet = [CCButton buttonWithTitle:@"" spriteFrame:pMSetKeyNormal highlightedSpriteFrame:pMSetKeyNormal disabledSpriteFrame:pMSetKeySelect];
    [self.pMSet setTarget:self selector:@selector(menuMSet)];
    
    CCSpriteFrame *pBackKeyNormal = [CCSpriteFrame frameWithImageNamed:@"backToMenu.png"];
    self.pBackToMenu = [CCButton buttonWithTitle:@"" spriteFrame:pBackKeyNormal];
    [self.pBackToMenu setTarget:self selector:@selector(menuCallBackBackToMenu)];
    [self.pBackToMenu setVisible:NO];
    [self.pBackToMenu setEnabled:NO];
    CCSpriteFrame *pNextKeyNormal = [CCSpriteFrame frameWithImageNamed:@"nextlevel_normal.png"];
    CCSpriteFrame *pNextKeySelect = [CCSpriteFrame frameWithImageNamed:@"nextlevel_select.png"];
    self.pNext = [CCButton buttonWithTitle:@"" spriteFrame:pNextKeyNormal highlightedSpriteFrame:pNextKeyNormal disabledSpriteFrame:pNextKeySelect];
    [self.pNext setTarget:self selector:@selector(menuNext)];
    [self.pNext setVisible:NO];
    [self.pNext setEnabled:NO];
    CCSpriteFrame *pRetryKeyNormal = [CCSpriteFrame frameWithImageNamed:@"retry_normal.png"];
    CCSpriteFrame *pRetryKeySelect = [CCSpriteFrame frameWithImageNamed:@"retry_select.png"];
    self.pRetry = [CCButton buttonWithTitle:@"" spriteFrame:pRetryKeyNormal highlightedSpriteFrame:pRetryKeyNormal disabledSpriteFrame:pRetryKeySelect];
    [self.pRetry setTarget:self selector:@selector(menuRetry)];
    [self.pRetry setVisible:NO];
    [self.pRetry setEnabled:NO];
    
    [self.pLeftKey setPosition:self.leftKeyPos];
    [self.pRightKey setPosition:self.rightKeyPos];
    [self.pJump setPosition:self.jumpKeyPos];
    [self.pFire setPosition:self.fireKeyPos];
    [self.pMSet setPosition:self.mSetKeyPos];
    [self.pBackToMenu setPosition:ccp(winSize.width/2, winSize.height/2 + 20)];
    [self.pNext setPosition:ccp(winSize.width/2, winSize.height/2 + 40)];
    [self.pRetry setPosition:ccp(winSize.width/2, winSize.height/2)];
    
    [self.pMenu addChild:self.pNext];
    [self.pMenu addChild:self.pRetry];
    [self.pMenu addChild:self.pMSet];
    [self.pMenu setAnchorPoint:CGPointZero];
    [self.pMenu setPosition:ccp(0, 0)];
    
    [self addChild:self.pMenu];

}


-(void) initBulletUI{
    self.pBulletBorderArrow = [CCSprite spriteWithImageNamed:@"bulletBorder.png"];
    [self.pBulletBorderArrow setPosition:self.arrowPos];
    self.pBulletBorderFireBall = [CCSprite spriteWithImageNamed:@"bulletBorder.png"];
    [self.pBulletBorderFireBall setPosition:self.fireBallPos];
    
    CCSpriteFrame *pArrowNormal = [CCSpriteFrame frameWithImageNamed:@"arrowBullet.png"];
    self.pMenuArrow = [CCButton buttonWithTitle:@"" spriteFrame:pArrowNormal];
    self.pMenuArrow.position = self.arrowPos;
    [self.pMenuArrow setTarget:self selector:@selector(menuCallBackArrow)];
    [self.pMenu addChild:self.pMenuArrow z:1];
    CCSpriteFrame *pFireBallNormal = [CCSpriteFrame frameWithImageNamed:@"fireBall.png"];
    self.pMenuFireBall = [CCButton buttonWithTitle:@"" spriteFrame:pFireBallNormal];
    self.pMenuFireBall.position = self.fireBallPos;
    [self.pMenuFireBall setTarget:self selector:@selector(menuCallBackFireBall)];
    [self.pMenu addChild:self.pMenuFireBall z:1];
}

-(void) initSetMenu{
    self.pColor =[CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(0, 0, 0, 100)]];
    [self addChild:self.pColor z:[self children].count];
    [self.pColor setVisible:NO];
    
    self.pSetMenu =[CCSprite spriteWithImageNamed:@"Set_Menu.png"];
    [self.pSetMenu setAnchorPoint:ccp(129.0/248, 71.0/132)];
    CGPoint origin = [[CCDirector sharedDirector] accessibilityActivationPoint];
    CGSize visibleSize = [[CCDirector sharedDirector] viewSize];
    [self.pSetMenu setPosition:ccp(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2)];
    [self.pSetMenu setScaleX:visibleSize.width/self.pSetMenu.textureRect.size.width];
    [self.pMenu addChild:self.pSetMenu z:[self.pMenu children].count+1];
    [self.pSetMenu setVisible:NO];
    
    CCSpriteFrame *pResumeNormal = [CCSpriteFrame frameWithImageNamed:@"resume_n.png"];
    CCSpriteFrame *pResumeSelect = [CCSpriteFrame frameWithImageNamed:@"resume_s.png"];
    self.pResume = [CCButton buttonWithTitle:@"" spriteFrame:pResumeNormal highlightedSpriteFrame:pResumeNormal disabledSpriteFrame:pResumeSelect];
    self.pResume.position = ccp(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2+40);
    [self.pResume setTarget:self selector:@selector(menuResume)];
    [self.pResume setVisible:NO];
    [self.pResume setEnabled:NO];
    
    CCSpriteFrame *pRestartNormal = [CCSpriteFrame frameWithImageNamed:@"restart_n.png"];
    CCSpriteFrame *pRestartSelect = [CCSpriteFrame frameWithImageNamed:@"restart_s.png"];
    self.pReStart = [CCButton buttonWithTitle:@"" spriteFrame:pRestartNormal highlightedSpriteFrame:pRestartNormal disabledSpriteFrame:pRestartSelect];
    self.pReStart.position = ccp(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2);
    [self.pReStart setTarget:self selector:@selector(menuReStart)];
    [self.pReStart setVisible:NO];
    [self.pReStart setEnabled:NO];
    
    CCSpriteFrame *pSelectNormal = [CCSpriteFrame frameWithImageNamed:@"select_n.png"];
    CCSpriteFrame *pSelectSelect = [CCSpriteFrame frameWithImageNamed:@"select_s.png"];
    self.pSelectMenu = [CCButton buttonWithTitle:@"" spriteFrame:pSelectNormal highlightedSpriteFrame:pSelectNormal disabledSpriteFrame:pSelectSelect];
    self.pSelectMenu.position = ccp(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2-40);
    [self.pSelectMenu setTarget:self selector:@selector(menuSelectMenu)];
    [self.pSelectMenu setVisible:NO];
    [self.pSelectMenu setEnabled:NO];
    
    [self.pMenu addChild:self.pResume z:[self.pMenu children].count];
    [self.pMenu addChild:self.pReStart z:[self.pMenu children].count];
    [self.pMenu addChild:self.pSelectMenu z:[self.pMenu children].count];
}

-(void) initRect{
    self.leftKeyRect = CGRectMake(self.leftKeyPos.x - [self.pLeftKey contentSize].width/2,
                             self.leftKeyPos.y - [self.pLeftKey contentSize].height/2,
                             [self.pLeftKey contentSize].width,
                             [self.pLeftKey contentSize].height);
    
    self.rightKeyRect = CGRectMake(self.rightKeyPos.x - [self.pRightKey contentSize].width/2,
                              self.rightKeyPos.y - [self.pRightKey contentSize].height/2,
                              [self.pRightKey contentSize].width,
                              [self.pRightKey contentSize].height);
    
    self.jumpKeyRect = CGRectMake(self.jumpKeyPos.x - [self.pJump contentSize].width/2,
                             self.jumpKeyPos.y - [self.pJump contentSize].height/2,
                             [self.pJump contentSize].width,
                             [self.pJump contentSize].height);
    
    self.fireKeyRect = CGRectMake(self.fireKeyPos.x - [self.pFire contentSize].width/2,
                             self.fireKeyPos.y - [self.pFire contentSize].height/2,
                             [self.pFire contentSize].width,
                             [self.pFire contentSize].height);
}

-(void) menuMSet{
    [self pauseGameLayer];
}

-(void) menuResume{
    [self resumeGameLayer];
}
-(void) pauseGameLayer{
    [self.mainMap pauseGameMap];
    //[self unschedule:@selector(update)];
//    [self.pLeftKey setEnabled:NO];
//    [self.pRightKey setEnabled:NO];
//    [self.pJump setEnabled:NO];
//    [self.pFire setEnabled:NO];
    [self.pMenuArrow setEnabled:NO];
    [self.pMenuFireBall setEnabled:NO];
    
    [self.pColor setVisible:YES];
    [self.pSetMenu setVisible:YES];
    [self.pResume setVisible:YES];
    [self.pResume setEnabled:YES];
    [self.pReStart setVisible:YES];
    [self.pReStart setEnabled:YES];
    [self.pSelectMenu setVisible:YES];
    [self.pSelectMenu setEnabled:YES];
}

-(void) resumeGameLayer{
    [self.mainMap resumeGameMap];
    //    [self.pLeftKey setEnabled:YES];
    //    [self.pRightKey setEnabled:YES];
    //    [self.pJump setEnabled:YES];
    //    [self.pFire setEnabled:YES];
    [self.pMenuArrow setEnabled:YES];
    [self.pMenuFireBall setEnabled:YES];
    
    [self.pColor setVisible:NO];
    [self.pSetMenu setVisible:NO];
    [self.pResume setVisible:NO];
    [self.pResume setEnabled:NO];
    [self.pReStart setVisible:NO];
    [self.pReStart setEnabled:NO];
    [self.pSelectMenu setVisible:NO];
    [self.pSelectMenu setEnabled:NO];
}
-(void) menuCallBackLeftKey{
    self.isKeyDownA = NO;
    self.moveOffset = 0.0f;
    self.moveDelta = 0.0f;
    [self.hero setHeroState:eNormalLeft];
    [self.pBackKeyImage setSpriteFrame:self.pBackKeyNormal];
}
-(void) menuCallBackRightKey{
    self.isKeyDownD = NO;
    self.moveOffset = 0.0f;
    self.moveDelta = 0.0f;
    [self.hero setHeroState:eNormalRight];
    [self.pBackKeyImage setSpriteFrame:self.pBackKeyNormal];
}
-(void) menuCallBackJumpKey{}
-(void) menuCallBackFireKey{}
-(void) menuCallBackBackToMenu{
    [self toMainMenu];
}

-(void) menuReStart{
    CCScene *pScene = [[GameScene alloc] init];
    [[CCDirector sharedDirector] replaceScene:pScene];
}
-(void) menuSelectMenu{
    CCScene *pScene = [[SelectMenu alloc] init];
    [[CCDirector sharedDirector] replaceScene:pScene];
}

-(void) menuCallBackFireBall{
    if ([self.hero bulletable])
    {
        [[Global getGlobalInstance] setCurrentBulletType:eBullet_common];
        [self.hero setCurrentBulletType:eBullet_common];
    }
}
-(void) menuCallBackArrow{
    if ([self.hero bulletable])
    {
        [[Global getGlobalInstance] setCurrentBulletType:eBullet_arrow];
        [self.hero setCurrentBulletType:eBullet_arrow];
    }
}

-(void) stopForPassFailure{
    if ([[Global getGlobalInstance] lifeNum] == 0)
    {
        [[OALSimpleAudio sharedInstance] stopBg];
        [[OALSimpleAudio sharedInstance] playEffect:@"GameOver.ogg"];
        [self.pGameOverBack setVisible:YES];
    }
    else
    {
        [self.pPassFailure setVisible:YES];
    }
    [self.mainMap stopUpdateForHeroDie];
    [self unschedule:@selector(update:)];
    [self.pMenuFireBall setEnabled:NO];
    [self.pMenuArrow setEnabled:NO];
    CCActionDelay *pDelay = [[CCActionDelay alloc]initWithDuration:3];
    [self runAction:[CCActionSequence actions:pDelay,[CCActionCallFunc actionWithTarget:self selector:@selector(reShowPassFailure)], nil]];
}
-(void) reShowPassFailure{
    if ([[Global getGlobalInstance] lifeNum] == 0)
    {
        [self toMainMenu];
    }
    else
    {
        [self.pRetry setVisible:YES];
        [self.pRetry setEnabled:YES];
    }
}
-(void) stopForPassSuccess{
    int level = [[Global getGlobalInstance] currentLevel];
    NSString *str = [NSString stringWithFormat:@"Level%d", level + 1];
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:str];
    [self.mainMap stopUpdateForHeroDie];
    [self unschedule:@selector(update:)];
    CCActionDelay *pDelay = [[CCActionDelay alloc]initWithDuration:3];
    [self runAction:[CCActionSequence actions:pDelay,[CCActionCallFunc actionWithTarget:self selector:@selector(reShowPassSuccess)], nil]];
}
-(void) reShowPassSuccess{
    [self.pPassSuccess setVisible:YES];
    
    if ([[Global getGlobalInstance] currentLevel] == [[Global getGlobalInstance] totalLevels])
    {
        [self showPassAll];
    }else
    {
        [self.pNext setVisible:YES];
        [self.pNext setEnabled:YES];
    }
}
-(void) showPassAll{
    CCLabelTTF *pPassAll =[CCLabelTTF labelWithString:@"You Pass All" fontName:@"ArialMT" fontSize:40];
    CGPoint origin = [[CCDirector sharedDirector] accessibilityActivationPoint];
    CGSize visibleSize = [[CCDirector sharedDirector] viewSize];
    
    [pPassAll setPosition:ccp(origin.x + visibleSize.width/2, origin.y + visibleSize.height)];
    [self addChild:pPassAll z:[self children].count];
    CCActionMoveTo *pTo = [CCActionMoveTo actionWithDuration:0.3f position:ccp(origin.x + visibleSize.width/2, origin.y + visibleSize.height/2)];
    CCActionDelay *pDelay = [[CCActionDelay alloc]initWithDuration:2.0f];
    [self runAction:[CCActionSequence actions:pTo,pDelay,[CCActionCallFunc actionWithTarget:self selector:@selector(toMainMenu)], nil]];
}
-(void) menuRetry{
    CCScene *pScene = [[GameScene alloc] init];
    [[CCDirector sharedDirector] replaceScene:pScene];
}
-(void) menuNext{
    [[Global getGlobalInstance] currentLevelPlusOne];
    CCScene *pScene = [[GameScene alloc] init];
    [[CCDirector sharedDirector] replaceScene:pScene];
}
-(void) menuCloseCallBack{
    [self toMainMenu];
}
-(void)toMainMenu{
    CCScene *pScene = [[MainMenu alloc] init];
    [[CCDirector sharedDirector] replaceScene:pScene];
}
-(void) showHeroJump{
    [self.hero reSetForSuccess];
    CCActionJumpTo *pJump = [CCActionJumpTo actionWithDuration:1.0f position:self.mainMap.finalPoint height:32 jumps:3];
    [self.hero runAction:pJump];
}
-(void) reSetKeyNo{}

-(void) reSetHeroFireable{
    self.heroFireable = YES;
}

-(void) update:(CCTime)delta{
    if ([self.hero isDied])
    {
        [self stopForPassFailure];
        return ;
    }
    if (self.isPass)
    {
        [self stopForPassSuccess];
        return ;
    }
    [self updateControl];
    
    self.currentPos = [self.hero position];
    self.heroSize = [self.hero contentSize];
    
    if ([self.hero gadgetable])
    {
        self.currentPos = ccp(self.moveOffset + [[self.mainMap heroInGadget] moveOffset],self.jumpOffset + [[self.mainMap heroInGadget] jumpOffset]);
    }
    else
    {
        self.currentPos = ccp(self.currentPos.x+self.moveOffset,self.currentPos.y+self.jumpOffset);
    }
    if (self.isSky)
    {
        switch ([self.hero face])
        {
            case eLeft:
                [self.hero setHeroState:eJumpLeft];
                break;
            case eRight:
                [self.hero setHeroState:eJumpRight];
                break;
            default:
                break;
        }
    }
    [self.hero setPosition:self.currentPos];
    [self setSceneScrollPosition];
    [self collistionV];
    [self collistionH];
}

-(void) updateControl{
    if (![self.hero isDied])
    {
        if (self.isLeftKeyDown)
        {
            self.isKeyDownA = YES;
            self.moveOffset = -self.ccMoveOffset;
            self.moveDelta = -self.ccMoveDelta;
            [self.hero setHeroState:eLeft];
            [self.pBackKeyImage setSpriteFrame:self.pBackKeyLeft];
        }
        else if (self.isRightKeyDown)
        {
            self.isKeyDownD = YES;
            self.moveOffset = self.ccMoveOffset;
            self.moveDelta = self.ccMoveDelta;
            [self.hero setHeroState:eRight];
            [self.pBackKeyImage setSpriteFrame:self.pBackKeyRight];
        }
        if (self.isJumpKeyDown)
        {
            self.hero.gadgetable = NO;
            if (!self.isSky)
            {
                [[OALSimpleAudio sharedInstance] playEffect:@"Jump.ogg"];
                self.jumpOffset = 6.0f;
                self.isSky = YES;
                self.hero.isFlying = YES;
            }
            [self.pJumpImage setSpriteFrame:self.pAB_Selected];
        }
        if (self.isFireKeyDown)
        {
            if ([self.hero bulletable])
            {
                if (self.heroFireable)
                {
                    [[OALSimpleAudio sharedInstance] playEffect:@"RengHuoQiu.ogg"];
                    [self.mainMap createNewBullet];
                    [self.hero fireAction];
                    self.heroFireable = NO;
                    CCActionDelay *pDelay = [[CCActionDelay alloc]initWithDuration:0.5f];
                    [self runAction:[CCActionSequence actions:pDelay,[CCActionCallFunc actionWithTarget:self selector:@selector(reSetHeroFireable)], nil]];
                }
            }
            [self.pFireImage setSpriteFrame:self.pAB_Selected];
        }
    }
}

-(void) collistionV{
    CGPoint currentPos = [self.hero position];
    //NSLog(@"currentPos  x:%f y:%f",currentPos.x,currentPos.y);
    if (currentPos.y <= 0)
    {
        [self.hero setHeroDie:YES];
        [self.hero setPosition:ccp(currentPos.x, 1)];
        [self.hero dieForTrap];
        [[OALSimpleAudio sharedInstance] playEffect:@"DiaoRuXianJingSi.ogg"];
        return ;
    }
    
    if (currentPos.y > self.mapSize.height - self.heroSize.height - 2)
    {
        self.jumpOffset = 0.0f;
        [self.hero setPosition:ccp(currentPos.x, self.mapSize.height - self.heroSize.height - 2)];
        self.isSky = NO;
        return ;
    }
    
    for (int heroIdx = 6; heroIdx <= self.heroSize.width - 6; ++heroIdx)
    {
        CGPoint upCollision = ccp(currentPos.x - self.heroSize.width/2 + heroIdx, currentPos.y + self.heroSize.height);
        CGPoint upTileCoord = [self.mainMap positionToTileCoord:upCollision];
        if ([self.mainMap isMarioEatMushroom:upTileCoord])
        {
            [self.hero changeForGotMushroom];
        }
        if ([self.mainMap isMarioEatAddLifeMushroom:upTileCoord])
        {
            [self.hero changeForGotAddLifeMushroom];
        }
        CGPoint upPos = [self.mainMap tilecoordToPosition:upTileCoord];
        upPos = ccp(currentPos.x, upPos.y - self.heroSize.height);
        enum TileType tileType = [self.mainMap tileTypeforPos:upTileCoord];
        bool flagUp = NO;
        switch (tileType)
        {
            case eTile_Block:
            case eTile_Land:
                if (self.jumpOffset > 0)
                {
                    [self.mainMap breakBlockWithTileCoord:upTileCoord andBodyType:[self.hero bodyType]];
                    self.jumpOffset = 0.0f;
                    [self.hero setPosition:upPos];
                    flagUp = YES;
                }
                break;
            case eTile_Coin:
                [[OALSimpleAudio sharedInstance] playEffect:@"EatCoin.ogg"];
                [[self.mainMap coinLayer] removeTileAt:upTileCoord];
                break;
            default:
                break;
        }
        if (flagUp)
        {
            self.jumpOffset -= self.ccJumpOffset;
            return ;
        }
    }
    float heroLeftSide = currentPos.x - self.heroSize.width/2;
    for (int heroIdx = 4; heroIdx <= self.heroSize.width - 4; ++heroIdx)
    {
        CGPoint downCollision = ccp(heroLeftSide + heroIdx, currentPos.y);
        CGPoint downTileCoord = [self.mainMap positionToTileCoord:downCollision];
        //NSLog(@"second  x:%f y:%f",downTileCoord.x,downTileCoord.y);
        if ([self.mainMap isMarioEatMushroom:downTileCoord])
        {
            [self.hero changeForGotMushroom];
        }
        if ([self.mainMap isMarioEatAddLifeMushroom:downTileCoord])
        {
            [self.hero changeForGotAddLifeMushroom];
        }
        downTileCoord.y += 1;
        CGPoint downPos = [self.mainMap tilecoordToPosition:downTileCoord];
        downPos = ccp(currentPos.x , downPos.y + self.mainMap.tileSize.height);
        enum TileType tileType = [self.mainMap tileTypeforPos:downTileCoord];
        bool flagDown = NO;
        switch (tileType)
        {
            case eTile_Flagpole:
            {
                self.isPass = YES;
                [self.mainMap showFlagMove];
                [self showHeroJump];
                return;
                break;
            }
            case eTile_Coin:
                [[OALSimpleAudio sharedInstance] playEffect:@"EatCoin.ogg"];
                [[self.mainMap coinLayer] removeTileAt:downTileCoord];
                break;
                //case eTile_Trap:
                //    [self.hero setPosition:ccp(currentPos.x, 16.0f)];
                //    [self.hero setHeroDie:YES];
                //    return;
                //    break;
            case eTile_Land:
            case eTile_Pipe:
            case eTile_Block:
            {
                if (self.jumpOffset < 0)
                {
                    [self.hero setGadgetable:NO];
                    self.jumpOffset = 0.0f;
                    [self.hero setPosition:downPos];
                    self.isSky = NO;
                    self.hero.isFlying = NO;
                    switch ([self.hero face])
                    {
                        case eLeft:
                            if (self.isKeyDownA)
                            {
                                [self.hero setHeroState:eLeft];
                            }
                            else
                            {
                                [self.hero setHeroState:eNormalLeft];
                            }
                            break;
                        case eRight:
                            if (self.isKeyDownD)
                            {
                                [self.hero setHeroState:eRight];
                            }
                            else
                            {
                                [self.hero setHeroState:eNormalRight];
                            }
                            break;
                        default:
                            break;
                    }
                }
                flagDown = YES;
            }
                break;
            default:
                break;
        }
        if (flagDown)
        {
            return;
        }
        
        float gadgetLevel = 0.0f;
        if([self.mainMap isHeroInGadgetWithHeroPos:downCollision andGadgetLevel:&gadgetLevel])
        {
            self.jumpOffset = 0.0f;
            downPos = ccp(currentPos.x, gadgetLevel);
            [self.hero setPosition:downPos];
            [self.hero setGadgetable:YES];
            self.isSky = NO;
            self.hero.isFlying = NO;
            switch ([self.hero face])
            {
                case eLeft:
                    if (self.isKeyDownA)
                    {
                        [self.hero setHeroState:eLeft];
                    }
                    else
                    {
                        [self.hero setHeroState:eNormalLeft];
                    }
                    break;
                case eRight:
                    if (self.isKeyDownD)
                    {
                        [self.hero setHeroState:eRight];
                    }
                    else
                    {
                        [self.hero setHeroState:eNormalRight ];
                    }
                    break;
                default:
                    break;
            }
            return ;
        }
        else
        {
            [self.hero setGadgetable:NO];
        }
    }
    
    self.jumpOffset -= self.ccJumpOffset;
}
-(void) collistionH{
    CGPoint currentPos = [self.hero position];
    //不允许英雄向左走
    if ( (currentPos.x - self.heroSize.width/2 - mapMaxH) <= 0 )
    {
        CGPoint pp = ccp(mapMaxH + self.heroSize.width/2, currentPos.y);
        [self.hero setPosition:pp];
        return ;
    }
    
    bool flag = NO;
    CGPoint rightCollision = ccp(currentPos.x + self.heroSize.width/2, currentPos.y);
    CGPoint rightTileCoord = [self.mainMap positionToTileCoord:rightCollision];
    if ([self.mainMap isMarioEatMushroom:rightTileCoord])
    {
        [self.hero changeForGotMushroom];
    }
    if ([self.mainMap isMarioEatAddLifeMushroom:rightTileCoord])
    {
        [self.hero changeForGotAddLifeMushroom];
    }
    CGPoint rightPos = [self.mainMap tilecoordToPosition:rightTileCoord];
    rightPos = ccp(rightPos.x - self.heroSize.width/2, currentPos.y);
    
    enum TileType tileType = [self.mainMap tileTypeforPos:rightTileCoord];
    switch (tileType)
    {
        case eTile_Block:
        case eTile_Pipe:
        case eTile_Land:
            [self.hero setPosition:rightPos];
            flag = YES;
            break;
        case eTile_Flagpole:
        {
            self.isPass = YES;
            [self.mainMap showFlagMove];
            [self showHeroJump];
            return ;
            break;
        }
        case eTile_Coin:
            [[OALSimpleAudio sharedInstance] playEffect:@"EatCoin.ogg"];
            [[self.mainMap coinLayer] removeTileAt:rightTileCoord];
            break;
        default:
            break;
    }
    
    CGPoint leftCollision = ccp(currentPos.x - self.heroSize.width/2, currentPos.y );
    CGPoint leftTileCoord = [self.mainMap positionToTileCoord:leftCollision];
    if ([self.mainMap isMarioEatMushroom:leftTileCoord])
    {
        [self.hero changeForGotMushroom];
    }
    if ([self.mainMap isMarioEatAddLifeMushroom:leftTileCoord])
    {
        [self.hero changeForGotAddLifeMushroom];
    }
    CGPoint leftPos = [self.mainMap tilecoordToPosition:leftTileCoord];
    leftPos = ccp(leftPos.x + self.heroSize.width/2+self.mainMap.tileSize.width, currentPos.y);
    tileType = [self.mainMap tileTypeforPos:leftTileCoord];
    switch (tileType)
    {
        case eTile_Block:
        case eTile_Pipe:
        case eTile_Land:
            [self.hero setPosition:leftPos];
            flag = YES;
            break;
        case eTile_Coin:
            [[OALSimpleAudio sharedInstance] playEffect:@"EatCoin.ogg"];
            [[self.mainMap coinLayer] removeTileAt:leftTileCoord];
            break;
        case eTile_Flagpole:
        {
            self.isPass = YES;
            [self.mainMap showFlagMove];
            [self showHeroJump];
            return ;
            break;
        }
        default:
            break;
    }
}

-(void) setSceneScrollPosition{
    CGPoint pos = [self.hero position];
    CGSize winsize = [[CCDirector sharedDirector] viewSize];
    float x = MAX(pos.x, self.heroAnchor.x);
    float y = MAX(pos.y, self.heroAnchor.y);
    x = MIN(x, self.mapSize.width - winsize.width/2 - 80);
    y = MIN(y, self.mapSize.height - winsize.height/2);
    CGPoint actualPosition = ccp(x, y);
    CGPoint viewPoint = ccpSub(self.heroAnchor, actualPosition);
    if (fabs(viewPoint.x) > mapMaxH)
    {
        [self.mainScene setPosition:viewPoint];
        mapMaxH = fabs(self.mainScene.position.x);
    }
}

+(float) getMapMaxH{
    return mapMaxH;
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    CGPoint touchPos = [touch locationInWorld];
    if (CGRectContainsPoint(self.leftKeyRect, touchPos))
    {
        self.isLeftKeyDown = YES;
    }
    if (CGRectContainsPoint(self.rightKeyRect, touchPos))
    {
        self.isRightKeyDown = YES;
    }
    if (CGRectContainsPoint(self.jumpKeyRect, touchPos))
    {
        self.isJumpKeyDown = YES;
    }
    if (CGRectContainsPoint(self.fireKeyRect, touchPos))
    {
        self.isFireKeyDown = YES;
    }
}
-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    CGPoint touchPos = [touch locationInWorld];
    if (self.isLeftKeyDown)
    {
        bool flag = NO;
        if (CGRectContainsPoint(self.leftKeyRect, touchPos))
        {
            flag = YES;
        }
        if (flag == NO)
        {
            self.isLeftKeyDown = NO;
            self.isKeyDownA = NO;
            self.moveOffset = 0.0f;
            self.moveDelta = 0.0f;
            [self.hero setHeroState:eNormalLeft];
            [self.pBackKeyImage setSpriteFrame:self.pBackKeyNormal];
        }
    }
    
    if (self.isRightKeyDown)
    {
        bool flag = NO;
        if (CGRectContainsPoint(self.rightKeyRect, touchPos))
        {
            flag = YES;
        }
        if (flag == NO)
        {
            self.isRightKeyDown = NO;
            self.isKeyDownD = NO;
            self.moveOffset = 0.0f;
            self.moveDelta = 0.0f;
            [self.hero setHeroState:eNormalRight];
            [self.pBackKeyImage setSpriteFrame:self.pBackKeyNormal];
        }
    }
    
    if (self.isJumpKeyDown)
    {
        bool flag = NO;
        if (CGRectContainsPoint(self.jumpKeyRect, touchPos))
        {
            flag = YES;
        }
        if (flag == NO)
        {
            self.isJumpKeyDown = NO;
            [self.pJumpImage setSpriteFrame:self.pAB_Normal];
        }
    }
    
    if (self.isFireKeyDown)
    {
        bool flag = NO;
        if (CGRectContainsPoint(self.fireKeyRect, touchPos))
        {
            flag = YES;
        }
        if (flag == NO)
        {
            self.isFireKeyDown = NO;
            [self.pFireImage setSpriteFrame:self.pAB_Normal];
        }
    }
}
-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    
    CGPoint touchPos = [touch locationInWorld];
    if (CGRectContainsPoint(self.leftKeyRect, touchPos))
    {
        self.isLeftKeyDown = NO;
        self.isKeyDownA = NO;
        self.moveOffset = 0.0f;
        self.moveDelta = 0.0f;
        [self.hero setHeroState:eNormalLeft];
        [self.pBackKeyImage setSpriteFrame:self.pBackKeyNormal];
    }
    if (CGRectContainsPoint(self.rightKeyRect, touchPos))
    {
        self.isRightKeyDown = NO;
        self.isKeyDownD = NO;
        self.moveOffset = 0.0f;
        self.moveDelta = 0.0f;
        [self.hero setHeroState:eNormalRight];
        [self.pBackKeyImage setSpriteFrame:self.pBackKeyNormal];
    }
    if (CGRectContainsPoint(self.jumpKeyRect, touchPos))
    {
        self.isJumpKeyDown = NO;
        [self.pJumpImage setSpriteFrame:self.pAB_Normal];
    }
    if (CGRectContainsPoint(self.fireKeyRect, touchPos))
    {
        self.isFireKeyDown = NO;
        [self.pFireImage setSpriteFrame:self.pAB_Normal];
    }
}

@end
