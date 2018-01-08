//
//  GameMap.h
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
#import "CCTextureCache.h"
#import "GameEnum.h"
//#import "Item.h"
#import "Enemy.h"

// -----------------------------------------------------------------
@interface GameMap : CCTiledMap
// -----------------------------------------------------------------
// properties

@property CGPoint flagPoint;
@property CCSprite *pFlag;
@property CGPoint finalPoint;
@property BOOL isBossMap;

@property CCPointArray *pMushroomPointArray;

@property CCSprite *pAddLifeMushroom;
@property CGPoint addLifePoint;

@property NSMutableArray *pEnemyArray;

@property NSMutableArray *pBulletArray;

@property NSMutableArray *pGadgetArray;

@property Gadget *heroInGadget;

@property CCSprite *pMushSprite;
@property CGPoint mushTileCoord;

@property Item *pItem;

@property CCSpriteFrame *brokenCoin;
@property CGPoint resetCoinPoint;
@property CGPoint marioBirthPos;
@property CCPointArray *pItemCoordArray;
@property NSMutableArray *pSpriteArray;

@property CGPoint bridgeTileStartPos;
@property int bridgeTileNums;
@property Enemy *pBossEnemy;
@property CCSprite *pPrincess;
@property CGPoint enemyTilePos;
@property Enemy *pRandomEnemy;
@property CCTiledMapLayer* cloudLayer;
@property CCTiledMapLayer* blockLayer;
@property CCTiledMapLayer* pipeLayer;
@property CCTiledMapLayer* landLayer;
@property CCTiledMapLayer* trapLayer;
@property CCTiledMapObjectGroup* objectLayer;
@property CCTiledMapLayer* coinLayer;
@property CCTiledMapLayer* flagpoleLayer;


// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;
- (void)showFlagMove;
- (BOOL)isHeroInGadgetWithHeroPos:(CGPoint)heroPos andGadgetLevel:(float)gadgetLevel;
- (enum TileType)tileTypeforPos:(CGPoint)tileCoord;
- (void)breakBlockWithTileCoord:(CGPoint) tileCoord andBodyType:(enum BodyType)bodyType;
- (void)showBlockBroken:(CGPoint)tileCoord;
- (void)showJumpUpBlinkCoin:(CGPoint)tileCoord;
- (void)showBlockJump:(CGPoint)tileCoord;
- (void)showCoinJump:(CGPoint)tileCoord;
- (void)resetCoinBlockTexture;
- (void)showNewMushroomWithTileCoord:(CGPoint)tileCoord andBodyType:(enum BodyType)bodyType;
- (void)showAddLifeMushroom:(CGPoint)tileCoord;
- (BOOL)isMarioEatMushroom:(CGPoint)tileCoord;
- (BOOL)isMarioEatAddLifeMushroom:(CGPoint)tileCoord;
- (void)launchEnemyInMap;
- (void)launchGadgetInMap;
- (void)update:(float)dt;
- (void)stopUpdateForHeroDie;
- (void)pauseGameMap;
- (void)resumeGameMap;
- (void)enemyVSHero;
- (CGPoint)positionToTileCoord:(CGPoint)pos;
- (CGPoint)tilecoordToPosition:(CGPoint)tileCoord;
- (void)createNewBullet;
- (void)bulletVSEnemy;
+ (GameMap*)create:(NSString*)tmxFile;
+ (GameMap*)getGameMap;
- (void)createNewBulletForBossWithPos:(CGPoint)pos andType:(enum EnemyType)enemyType;

// -----------------------------------------------------------------

@end




