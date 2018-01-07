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
#import "GameEnum.h"

// -----------------------------------------------------------------

@interface GameMap : CCTiledMap

// -----------------------------------------------------------------
// properties
// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;
- (CGPoint)positionToTileCoord:(CGPoint)pos;
- (CGPoint)tilecoordToPosition:(CGPoint)tileCoord;
- (enum TileType)tileTypeforPos:(CGPoint)tileCoord;
+ (GameMap*)getGameMap;
- (void)createNewBulletForBossWithPos:(CGPoint)pos andType:(enum EnemyType)enemyType;

// -----------------------------------------------------------------

@end




