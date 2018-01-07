//
//  Enemy.h
//
//  Created by : Mr.Right
//  Project    : Super Mario
//  Date       : 2018/1/6
//
//  Copyright (c) 2018年 master.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameEnum.h"

// -----------------------------------------------------------------

@interface Enemy : CCNode

// -----------------------------------------------------------------
// properties
@property enum EnemyType enemyType;
@property CCSprite *enemyBody;
@property CGSize bodySize;
@property CCSpriteFrame *enemyLifeOver;
@property CCSpriteFrame *overByArrow;

@property CGPoint tileCoord;
@property CGPoint enemyPos;

@property enum marioDirection startFace;


@property float moveOffset;
@property float ccMoveOffset;

@property float jumpOffset;
@property float ccJumpOffset;

// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;
- (CGRect)getEnemyRect;
- (void)enemyCollistionH;
- (void)enemyCollistionV;
- (void)checkState;
- (void)stopEnemyUpdate;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
- (void)setNonVisibleForKilledByHero;

- (void)forKilledByBullet;
- (void)setNonVisibleForKilledByBullet;

- (void)setEnemyState:(enum EnemyState)state;
- (enum EnemyState)getEnemyState;
// -----------------------------------------------------------------

@end

@interface EnemyMushroom : Enemy
// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
- (void)launchEnemy;

//void enemyCollistionH();
//void enemyCollistionV();

- (void)update:(float)dt;
@end

@interface EnemyFlower : Enemy
// -----------------------------------------------------------------
// properties
@property CGPoint startPos;
// -----------------------------------------------------------------
// methods
- (void)launchEnemy;

- (void)update:(float)dt;
- (enum EnemyVSHero)checkCollisionWithHero;
- (CGRect)getEnemyRect;
@end

@interface EnemyTortoise : Enemy
// -----------------------------------------------------------------
// properties
@property CCSpriteFrame *leftFace;
@property CCSpriteFrame *rightFace;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithStartface:(int)_startface;
- (void)launchEnemy;
- (void)enemyCollistionH;
- (void)update:(float)dt;
@end

@interface EnemyTortoiseRound : Enemy
// -----------------------------------------------------------------
// properties
@property float roundDis;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithRoundDis:(float)dis;
- (void)launchEnemy;
- (void)update:(float)dt;
@end

@interface EnemyTortoiseFly : Enemy
// -----------------------------------------------------------------
// properties
@property float flyDis;

// -----------------------------------------------------------------
// methods
- (instancetype)initWithFlyDis:(float)dis;
- (void)launchEnemy;
- (void)update:(float)dt;
@end

@interface EnemyFireString : Enemy
// -----------------------------------------------------------------
// properties
@property CCSprite *enemyBody2;
@property CCSprite *enemyBody3;

@property CGSize fireSize;
@property NSMutableArray *pArrayFire;

@property float begAngle;
@property float time;

@property double angle;
@property double PI;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithBegAngle:(float)begAngle AndTime:(float)time;
- (void)launchEnemy;
- (void)stopEnemyUpdate;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByBullet;
- (void)forKilledByHero;
- (void)update:(float)dt;
@end

@interface EnemyFlyFish : Enemy
// -----------------------------------------------------------------
// properties
@property float offsetH;
@property float offsetV;
@property float offsetDuration;
@property bool isFlying;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithoffsetH:(float)offsetH andOffsetV:(float)offsetV andDuration:(float)duration;
- (void)launchEnemy;
- (void)update:(float)dt;
- (void)stopEnemyUpdate;
- (void)checkState;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
@end

@interface EnemyBoss : Enemy
// -----------------------------------------------------------------
// properties
@property float leftSide;
@property float rightSide;
// -----------------------------------------------------------------
// methods
- (void)launchEnemy;
- (void)update:(float)dt;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
- (void)forKilledByBullet;
- (void)enemyCollistionH;
@end

@interface EnemyBossFire : Enemy
// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
- (void)launchEnemy;
- (void)update:(float)dt;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
- (void)forKilledByBullet;
@end

@interface EnemyAddMushroom : Enemy
// -----------------------------------------------------------------
// properties
@property int addNums;
@property bool isAddable;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithNum:(int)addnum;
- (void)launchEnemy;
- (void)update:(float)dt;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
@end

@interface EnemyBattery : Enemy
// -----------------------------------------------------------------
// properties
@property BOOL isFireable;
@property float fireDelay;
@property CGPoint firePos;
// -----------------------------------------------------------------
// methods
- (void)launchEnemy;
- (void)update:(float)dt;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
- (void)forKilledByBullet;
@end

@interface EnemyBatteryBullet : Enemy
// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
- (void)launchEnemy;
- (void)update:(float)dt;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
- (void)forKilledByBullet;
@end

@interface EnemyDarkCloud : Enemy
// -----------------------------------------------------------------
// properties
@property float dropRegion;
@property float leftSide;
@property float rightSide;
@property BOOL isDropable;
@property float delay;
@property int type;
@property CCSpriteFrame *dark;
@property CCSpriteFrame *normal;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithDelay:(float)delay andType:(int)type;
- (void)launchEnemy;
- (void)update:(float)dt;
- (void)forKilledByHero;
- (void)forKilledByBullet;
@end

@interface EnemyLighting : Enemy
// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
- (void)launchEnemy;
- (void)update:(float)dt;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)checkState;
- (void)forKilledByHero;
- (void)forKilledByBullet;
@end




