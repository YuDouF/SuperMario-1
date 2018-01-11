//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#include "GameEnum.h"

@interface Hero : CCNode

@property CCSprite* mainBody;
@property CCSprite* mainTemp;
@property CGSize norBodySize;
@property CGSize smallSize;
@property CGSize currentSize;
@property(nonatomic) enum BodyType bodyType;   //正常 死亡 可开火

@property CCSpriteFrame *normalRight;
@property CCSpriteFrame *normalLeft;
@property CCSpriteFrame *jumpLeft;
@property CCSpriteFrame *jumpRight;

@property CCSpriteFrame *smallRight;
@property CCSpriteFrame *smallLeft;
@property CCSpriteFrame *smallJumpLeft;
@property CCSpriteFrame *smallJumpRight;

@property CCSpriteFrame *normalRightFire;
@property CCSpriteFrame *normalLeftFire;
@property CCSpriteFrame *jumpRightFire;
@property CCSpriteFrame *jumpLeftFire;

@property CCSpriteFrame *normalRightArrow;
@property CCSpriteFrame *normalLeftArrow;
@property CCSpriteFrame *jumpRightArrow;
@property CCSpriteFrame *jumpLeftArrow;

@property CCSpriteFrame *lifeOverSmall;
@property CCSpriteFrame *lifeOverNormal;
@property CCSpriteFrame *lifeOverFire;

@property bool isDied;  //是否死亡
@property enum marioDirection state;    //当前状态 向左／向右／左跳／右跳／左跑／右跑／开火
@property enum marioDirection statePre; //上一个状态
@property enum marioDirection face; //朝向 左／右
@property bool isFlying;    //是否在空中

@property bool bulletable;
@property(nonatomic) enum BulletType currentBulletType;
@property bool gadgetable;

@property CCLabelTTF* pLabelUp; //标记
@property bool isSafeTime;  //是否是无敌状态

-(instancetype) init;   //初始化
-(bool)heroInit;    //初始化英雄
-(void)reSetForSuccess; //成功重置

-(void)setHeroDie:(bool)die;    //设置英雄死亡
-(void)setHeroState:(enum marioDirection)state; //设置英雄状态
-(void)dieForTrap;  //陷阱死亡
-(void)reSetNonVisible; //重置英雄不可见

-(void)fireAction;  //开火动作
-(void)reSetStateForFired;  //开火后重置状态
-(void)changeForGotAddLifeMushroom; //碰到加生命蘑菇后的变化
-(void)changeForGotMushroom;    //碰到普通蘑菇后的变化
-(void)changeForGotEnemy;   //碰到敌人后的变化
-(void)clearLabelUp;    //清除标记
-(void)setHeroTypeForSmall; //设置英雄为小尺寸
-(void)setHeroTypeForNormal;    //设置英雄为正常尺寸
-(void)reSetSafeTime;   //取消无敌状态

+(Hero*) getHeroInstance;

@end
