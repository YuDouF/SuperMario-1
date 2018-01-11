//
//  GameLayer.h
//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "OALSimpleAudio.h"
#import "GameMap.h"
#import "Hero.h"

@interface GameScene : CCScene

@property CCScene* mainScene;   //地图场景
@property GameMap* mainMap; //地图
@property Hero* hero;   //英雄
@property CGPoint birthPoint;   //英雄出生点
@property CGSize heroSize;  //英雄大小
@property CGSize mapSize;   //地图大小
@property CGPoint heroAnchor;   //英雄锚点
@property CGPoint mapBeginPos;  //地图初始位置
@property CGPoint currentPos;   //英雄当前位置

@property float ccMoveOffset;
@property float ccMoveDelta;
@property float ccJumpOffset;
@property float moveDelta;
@property float moveOffset;
@property float jumpOffset;

@property bool isKeyDownA;
@property bool isKeyDownD;
@property bool isKeyDownJump;
@property bool isSky;

@property CCButton* pLeftKey;
@property CCButton* pRightKey;
@property CCButton* pJump;
@property CCButton* pFire;
@property CCButton* pMSet;

@property CCSprite* pGameOverBack;
@property CCSprite* pPassSuccess;
@property CCSprite* pPassFailure;

@property CCButton* pRetry;
@property CCButton* pNext;
@property CCButton* pBackToMenu;
//控制组件精灵
@property CCSprite* controlUI;
@property CCSprite* pBackKeyImage;
@property CCSpriteFrame* pBackKeyNormal;
@property CCSpriteFrame* pBackKeyLeft;
@property CCSpriteFrame* pBackKeyRight;
@property CCSprite* pJumpImage;
@property CCSprite* pFireImage;
@property CCSpriteFrame* pAB_Normal;
@property CCSpriteFrame* pAB_Selected;
//控制组件位置
@property CGPoint backKeyPos;
@property CGPoint leftKeyPos;
@property CGPoint rightKeyPos;
@property CGPoint jumpKeyPos;
@property CGPoint fireKeyPos;
@property CGPoint mSetKeyPos;

//设置菜单
@property CCNodeColor* pColor;
@property CCScene* pMenu;
@property CCSprite* pSetMenu;
@property CCButton* pResume;
@property CCButton* pReStart;
@property CCButton* pSelectMenu;
//子弹
@property CCSprite* pBulletBorderFireBall;
@property CCSprite* pBulletBorderArrow;
@property CCButton* pMenuFireBall;
@property CCButton* pMenuArrow;
@property CGPoint fireBallPos;
@property CGPoint arrowPos;

@property bool isPass;
@property bool heroFireable;

@property bool isLeftKeyDown;
@property bool isRightKeyDown;
@property bool isJumpKeyDown;
@property bool isFireKeyDown;

@property CGRect leftKeyRect;
@property CGRect rightKeyRect;
@property CGRect jumpKeyRect;
@property CGRect fireKeyRect;

-(instancetype) init;
-(void) initHeroAndMap;
-(void) initControlUI;
-(void) initBulletUI;
-(void) initRect;
-(void) initSetMenu;

-(void) pauseGameLayer;
-(void) resumeGameLayer;
-(void) menuMSet;
-(void) menuCallBackLeftKey;
-(void) menuCallBackRightKey;
-(void) menuCallBackJumpKey;
-(void) menuCallBackFireKey;
-(void) menuCallBackBackToMenu;
-(void) menuRetry;
-(void) menuNext;
-(void) showPassAll;

-(void) menuResume;
-(void) menuReStart;
-(void) menuSelectMenu;
-(void) menuCallBackFireBall;
-(void) menuCallBackArrow;
-(void) toMainMenu;

-(void) stopForPassFailure;
-(void) reShowPassFailure;
-(void) stopForPassSuccess;
-(void) reShowPassSuccess;
-(void) showHeroJump;
-(void) reSetKeyNo;
-(void) reSetHeroFireable;

-(void) updateControl;
-(void) collistionV;
-(void) collistionH;
-(void) setSceneScrollPosition;

+(float) getMapMaxH;
-(void) menuCloseCallBack;

@end


