//
//  Enemy.m
//
//  Created by : Mr.Right
//  Project    : Super Mario
//  Date       : 2018/1/6
//
//  Copyright (c) 2018年 master.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Enemy.h"
#import "Hero.h"
#import "AnimationManager.h"
#import "GameMap.h"
#import "GameScene.h"
#import "Global.h"
// -----------------------------------------------------------------

@implementation Enemy

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    self.startFace = eLeft;
    self.moveOffset = 0.0f;
    self.ccMoveOffset = 0.6f;
    
    self.jumpOffset = 0.0f;
    self.ccJumpOffset = 0.3f;
    
    [self setEnemyState:eEnemyState_nonactive];
    
    return self;
}
- (void)launchEnemy{
    
}
- (CGRect)getEnemyRect
{
    CGPoint pos = [self position];
    return CGRectMake(pos.x - self.bodySize.width/2 + 2, pos.y + 2, self.bodySize.width - 4, self.bodySize.height - 4);
}
 //-----------------------------------------------------------------
- (void)setEnemyState:(enum EnemyState)state
{
   _enemyState = state;
    switch (self.enemyState)
    {
        case eEnemyState_over:
        {
            [[self enemyBody] stopAllActions];
            //---------
            [self unscheduleAllSelectors];
            [self setVisible:NO];
            break;
        }
        default:
            break;
    }
}

- (void)checkState
{
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    float tempMaxH = [GameScene getMapMaxH];
    CGPoint pos = [self position];
    
    if ( (pos.x + self.bodySize.width/2 - tempMaxH >= 0) &&
        (pos.x - self.bodySize.width/2 - tempMaxH) <= winSize.width )
    {
        [self setEnemyState:eEnemyState_nonactive];
    }
    else
    {
        if (pos.x + self.bodySize.width/2 - tempMaxH < 0)
        {
            [self setEnemyState:eEnemyState_over];
        }
        else
        {
            [self setEnemyState:eEnemyState_nonactive];
        }
    }
}

- (void)stopEnemyUpdate
{
    [[self enemyBody] stopAllActions];
}

- (void)enemyCollistionH
{
    CGPoint currentPos = [self position];
    CGSize enemySize = [self contentSize];
    CGPoint leftCollistion = ccp(currentPos.x - enemySize.width/2, currentPos.y);
    CGPoint leftTilecoord = [[GameMap getGameMap] positionToTileCoord:leftCollistion];
    CGPoint leftPos = [[GameMap getGameMap] tilecoordToPosition:leftTilecoord];
    leftPos = ccp(leftPos.x + self.bodySize.width / 2 + [[GameMap getGameMap] tileSize].width, currentPos.y);
    
    enum TileType tileType;
    tileType = [[GameMap getGameMap] tileTypeforPos:leftTilecoord];
    switch (tileType)
    {
        case eTile_Pipe:
        case eTile_Block:
            [self setPosition:leftPos];
            self.moveOffset *= -1;
            break;
        default:
            break;
    }
    
    CGPoint rightCollistion = ccp(currentPos.x + self.bodySize.width/2, currentPos.y);
    CGPoint rightTilecoord = [[GameMap getGameMap] positionToTileCoord:rightCollistion];
    CGPoint rightPos = [[GameMap getGameMap] tilecoordToPosition:rightTilecoord];
    rightPos = ccp(rightPos.x - self.bodySize.width / 2, currentPos.y);
    
    tileType = [[GameMap getGameMap] tileTypeforPos:rightTilecoord];
    switch (tileType)
    {
        case eTile_Pipe:
        case eTile_Block:
            [self setPosition:rightPos];
            self.moveOffset *= -1;
            break;
        default:
            break;
    }
}

- (void)enemyCollistionV
{
    
    CGPoint currentPos = [self position];
    CGPoint downCollision = currentPos;
    CGPoint downTilecoord = [[GameMap getGameMap] positionToTileCoord:downCollision];
    downTilecoord.y += 1;
    
    CGPoint downPos = [[GameMap getGameMap] tilecoordToPosition:downTilecoord];
    downPos = ccp(currentPos.x, downPos.y + [[GameMap getGameMap] tileSize].height);
    
    enum TileType tileType = [[GameMap getGameMap] tileTypeforPos:downTilecoord];
    BOOL downFlag = NO;
    switch (tileType)
    {
        case eTile_Land:
        case eTile_Pipe:
        case eTile_Block:
        {
            downFlag = YES;
            self.jumpOffset = 0.0f;
            [self setPosition:downPos];
            break;
        }
        case eTile_Trap:
        {
            [self setEnemyState:eEnemyState_over];
            break;
        }
        default:
            break;
    }
    
    if (downFlag)
    {
        return ;
    }
    
    self.jumpOffset -= self.ccJumpOffset;
}

- (enum EnemyVSHero)checkCollisionWithHero
{
    enum EnemyVSHero ret = eVS_nonKilled;
    
    CGPoint heroPos = [[Hero getHeroInstance] position];
    CGSize heroSize = [[Hero getHeroInstance] contentSize];
    CGRect heroRect = CGRectMake(heroPos.x - heroSize.width/2 + 2, heroPos.y + 3,
                                 heroSize.width - 4, heroSize.height - 4);
    
    CGRect heroRectVS = CGRectMake(heroPos.x - heroSize.width/2 - 3, heroPos.y,
                                   heroSize.width - 6, 2);
    
    CGPoint enemyPos = [self position];
    CGRect enemyRect = CGRectMake(enemyPos.x - self.bodySize.width/2 + 1, enemyPos.y,
                                  self.bodySize.width - 2, self.bodySize.height - 4);
    
    CGRect enemyRectVS = CGRectMake(enemyPos.x - self.bodySize.width/2 - 2, enemyPos.y + self.bodySize.height - 4,
                                    self.bodySize.width - 4, 4);
    
    
    if (CGRectIntersectsRect(heroRectVS, enemyRectVS))
    {
        ret = eVS_enemyKilled;
        return ret;
    }
    
    if (CGRectIntersectsRect(heroRect, enemyRect))
    {
        ret = eVS_heroKilled;
        return ret;
    }
    
    return ret;
}

- (void)forKilledByHero
{
    [self setEnemyState:eEnemyState_over];
    [[self enemyBody] stopAllActions];
    [self stopAllActions];
    [self unscheduleAllSelectors];

    [[self enemyBody] setSpriteFrame:self.enemyLifeOver];
    CCActionInterval *pDelay = [CCActionDelay actionWithDuration:1.0f];
    [self runAction:[CCActionSequence actions:pDelay, [CCActionCallFunc actionWithTarget:self selector:@selector(setNonVisibleForKilledByHero)], nil]];
}

- (void)setNonVisibleForKilledByHero
{
    [self setVisible:NO];
};

- (void)forKilledByBullet
{
    [self setEnemyState:eEnemyState_over];
    [[self enemyBody] stopAllActions];
    [self unscheduleAllSelectors];
    CCActionMoveBy *pMoveBy = nil;
    CCActionJumpBy *pJumpBy = nil;
    
    switch ([[Global getGlobalInstance] currentBulletType])
    {
        case eBullet_common:
        {
            if (self.enemyType == eEnemy_mushroom || self.enemyType == eEnemy_AddMushroom)
            {
                [self.enemyBody setSpriteFrame:self.overByArrow];
            }
            else
            {
                [self.enemyBody setSpriteFrame:self.enemyLifeOver];
            }
            
            switch ([[Hero getHeroInstance] face])
            {
                case eRight:
                    pJumpBy = [CCActionJumpBy actionWithDuration:0.3f position:ccp(self.bodySize.width * 2, 0) height:self.bodySize.height jumps:1];
                    break;
                case eLeft:
                    pJumpBy = [CCActionJumpBy actionWithDuration:0.3f position:ccp(-self.bodySize.width * 2, 0) height:self.bodySize.height jumps:1];
                    break;
                default:
                    break;
            }
            
            break;
        }
        case eBullet_arrow:
        {
            [self.enemyBody setSpriteFrame:self.overByArrow];
            CCSprite *arrow = [CCSprite spriteWithImageNamed:@"arrow.png"];
            [arrow setPosition:ccp(self.bodySize.width / 2, self.bodySize.height / 2)];
            [self addChild:arrow];
            
            switch ([[Hero getHeroInstance] face])
            {
                case eRight:
                    pMoveBy = [CCActionMoveBy actionWithDuration:0.1f position:ccp(2 * self.bodySize.width, 0)];
                    break;
                case eLeft:
                    pMoveBy = [CCActionMoveBy actionWithDuration:0.1f position:ccp(-2 * self.bodySize.width, 0)];
                    [arrow runAction:[CCActionFlipX actionWithFlipX:YES]];
                    break;
                default:
                    break;
            }
            
            break;
            break;
        }
        default:
            break;
    }
    
    if (self.enemyType == eEnemy_flower)
    {
        CCActionDelay *pDelay = [CCActionDelay actionWithDuration:0.2f];
        [self runAction:[CCActionSequence actions:pDelay, [CCActionCallFunc actionWithTarget:self selector:@selector(setNonVisibleForKilledByBullet)], nil]];
        return ;
    }
    
    if (pJumpBy)
    {
        [self runAction:[CCActionSequence actions:pJumpBy, [CCActionCallFunc actionWithTarget:self selector:@selector(setNonVisibleForKilledByBullet)], nil]];
    }
    else
    {
        [self runAction:[CCActionSequence actions:pMoveBy, [CCActionCallFunc actionWithTarget:self selector:@selector(setNonVisibleForKilledByBullet)], nil]];
    }
}

- (void)setNonVisibleForKilledByBullet
{
    [self setEnemyState:eEnemyState_over];
    [self setVisible:NO];
}
@end

// ******************** EnemyMushroom ***************** //
@implementation EnemyMushroom
// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    self.enemyType = eEnemy_mushroom;
    self.bodySize = CGSizeMake(16.0f, 16.0f);
    self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Mushroom0.png"] rect:CGRectMake(0, 0, 16, 16)];
    [self.enemyBody setAnchorPoint:ccp(0, 0)];
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0)];
    
    //*************************
    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"Mushroom0.png" rectInPixels:CGRectMake(32, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(16, 16)];
//    [self.enemyLifeOver retain];
    
    self.overByArrow = [CCSpriteFrame frameWithTextureFilename:@"Mushroom0.png" rectInPixels:CGRectMake(48, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(16, 16)];
//    [self.overByArrow retain];
    
    self.moveOffset = -self.ccMoveOffset;
    
    return self;
}
- (void)dealloc{
    [self unscheduleAllSelectors];
}
//CCEnemyMushroom::~CCEnemyMushroom()
//{
//    this->unscheduleAllSelectors();
//}

- (void)launchEnemy
{
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniMushroom]]];
    //*****************
//    [self update:(float)];
//    this->scheduleUpdate();
}
- (void)update:(float)dt{
    [self checkState];
    
    if ([self enemyState] == eEnemyState_active)
    {
        CGPoint currentPos = [self position];
        currentPos.x += self.moveOffset;
        currentPos.y += self.jumpOffset;
        [self setPosition:currentPos];
        
        [self enemyCollistionH];
        [self enemyCollistionV];
    }
}
@end

// ********************** EnemyFlower ****************** //
@implementation EnemyFlower
// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    self.enemyType = eEnemy_flower;
    self.bodySize = CGSizeMake(16, 24);
    self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"flower0.png"] rect:CGRectMake(0, 0, 16, 24)];
    [self.enemyBody setAnchorPoint:ccp(0, 0)];
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0)];
    
    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"flower0.png" rectInPixels:CGRectMake(0, 0, 16, 24) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(16, 24)];
//    [self.enemyLifeOver retain];
    
    self.overByArrow = self.enemyLifeOver;
    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniflower]]];
    CGPoint pos = [self position];
    pos.y -= self.bodySize.height;
    self.startPos = pos;
    [self runAction:[CCActionPlace actionWithPosition:pos]];
    
    CCActionInterval *pMoveBy = [CCActionMoveBy actionWithDuration:1.0f position:ccp(0.0f, self.bodySize.height)];
    CCActionInterval *pDelay = [CCActionDelay actionWithDuration:1.0f];
    CCActionInterval *pMoveByBack = [pMoveBy reverse];
    CCActionInterval *pDelay2 = [CCActionDelay actionWithDuration:2.0f];
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:(CCActionInterval*)[CCActionSequence actions:pMoveBy, pDelay, pMoveByBack, pDelay2, nil]]];
    //*************
//    [self update:<#(float)#>];
}

- (void)update:(float)dt
{
    [self checkState];
}

- (enum EnemyVSHero)checkCollisionWithHero
{
    enum EnemyVSHero ret = eVS_nonKilled;
    
    CGPoint heroPos = [[Hero getHeroInstance] position];
    CGSize heroSize = [[Hero getHeroInstance] currentSize];
    CGRect heroRect = CGRectMake(heroPos.x - heroSize.width/2 + 2, heroPos.y + 2,
                                 heroSize.width - 4, heroSize.height - 4);
    
    CGPoint enemyPos = [self position];
    CGRect enemyRect = CGRectMake(enemyPos.x - self.bodySize.width/2 + 2, enemyPos.y + self.bodySize.height - (enemyPos.y - self.startPos.y), self.bodySize.width - 4, enemyPos.y - self.startPos.y);
    
    if (CGRectIntersectsRect(heroRect, enemyRect))
    {
        ret = eVS_heroKilled;
    }
    
    return ret;
}

- (CGRect)getEnemyRect
{
    CGPoint enemyPos = [self position];
    CGRect enemyRect = CGRectMake(enemyPos.x - self.bodySize.width/2 + 2, enemyPos.y + self.bodySize.height - (enemyPos.y - self.startPos.y), self.bodySize.width - 4, enemyPos.y - self.startPos.y);
    return enemyRect;
}

@end

// ********************** EnemyTortoise ****************** //
@implementation EnemyTortoise

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    return self;
}
- (instancetype)initWithStartface:(int)startface{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    
    switch (startface)
    {
        case 0:
            self.startFace = eLeft;
            self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"tortoise0.png"] rect:CGRectMake(18 * 2, 0, 18, 24)];
            self.leftFace = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 2, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(18, 24)];
//            [self.leftFace retain];
            self.moveOffset = -self.ccMoveOffset;
            break;
        case 1:
            self.startFace = eRight;
            self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"tortoise0.png"] rect:CGRectMake(18 * 5, 0, 18, 24)];
            self.rightFace = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 5, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(18, 24)];
//            [self.rightFace retain];
            self.moveOffset = self.ccMoveOffset;
            break;
        default:
            break;
    }
    
    self.enemyType = eEnemy_tortoise;
    self.bodySize = CGSizeMake(18.0f, 24.0f);
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.0f)];
    
    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 9, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(18, 24)];
//    [self.enemyLifeOver retain];
    
    self.overByArrow = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 8, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(18, 24)];
//    [self.overByArrow retain];
    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    switch (self.startFace)
    {
        case eLeft:
            [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniTortoiseLeft]]];
            break;
        case eRight:
            [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniTortoiseRight]]];
            break;
        default:
            break;
    }
    //*****************
//    this->scheduleUpdate();
}

- (void)enemyCollistionH
{
    CGPoint currentPos = [self position];
    CGSize enemySize = [self contentSize];
    CGPoint leftCollistion = ccp(currentPos.x - enemySize.width/2, currentPos.y);
    CGPoint leftTilecoord = [[GameMap getGameMap] positionToTileCoord:leftCollistion];
    CGPoint leftPos = [[GameMap getGameMap] tilecoordToPosition:leftTilecoord];
    leftPos = ccp(leftPos.x + self.bodySize.width/2 + [[GameMap getGameMap] tileSize].width, currentPos.y);
    enum TileType tileType;
    
    tileType = [[GameMap getGameMap] tileTypeforPos:leftTilecoord];
    switch (tileType)
    {
        case eTile_Pipe:
        case eTile_Block:
            [self setPosition:leftPos];
            self.moveOffset *= -1;
            
            [[self enemyBody] stopAllActions];
            [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniTortoiseRight]]];
            break;
        default:
            break;
    }
    
    CGPoint rightCollistion = ccp(currentPos.x + self.bodySize.width/2, currentPos.y);
    CGPoint rightTilecoord = [[GameMap getGameMap] positionToTileCoord:rightCollistion];
    CGPoint rightPos = [[GameMap getGameMap] tilecoordToPosition:rightTilecoord];
    rightPos = ccp(rightPos.x - self.bodySize.width/2, currentPos.y);
    
    tileType = [[GameMap getGameMap] tileTypeforPos:rightTilecoord];
    switch (tileType)
    {
        case eTile_Pipe:
        case eTile_Block:
            [self setPosition:rightPos];
            self.moveOffset *= -1;
            
            [[self enemyBody] stopAllActions];
            [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniTortoiseLeft]]];
            break;
        default:
            break;
    }
}
- (void)update:(float)dt
{
    [self checkState];
    
    if ([self enemyState] == eEnemyState_active)
    {
        CGPoint currentPos = [self position];
        currentPos.x += self.moveOffset;
        currentPos.y += self.jumpOffset;
        [self setPosition:currentPos];
        
        [self enemyCollistionH];
        [self enemyCollistionV];
    }
}
@end

// ********************** EnemyTortoiseRound ****************** //
@implementation EnemyTortoiseRound

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    return self;
}
- (instancetype)initWithRoundDis:(float)dis{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    
    self.enemyType = eEnemy_tortoiseRound;
    self.bodySize = CGSizeMake(18.0f, 24.0f);
    self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"tortoise0.png"] rect:CGRectMake(18 * 2, 0, 18, 24)];
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.0f)];

    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 9, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(18, 24)];
//    [self.enemyLifeOver retain];
    
    self.overByArrow = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 8, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(18, 24)];
//    [self.overByArrow retain];
    
    self.roundDis = dis;
    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    [self setEnemyState:eEnemyState_active];
    [[self enemyBody] runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniTortoiseLeft]]];
    CCActionInterval *pMoveLeft = [CCActionMoveBy actionWithDuration:2.0f position:ccp(-self.roundDis, 0.0f)];
    CCActionInterval *pMoveRight = [CCActionMoveBy actionWithDuration:2.0f position:ccp(self.roundDis, 0.0f)];
    
//    CCActionDelay *pDelay = [CCActionDelay actionWithDuration:0.2f];
    
    [self runAction:[CCActionRepeatForever actionWithAction:[CCActionSequence actions:pMoveLeft, [CCActionCallFunc actionWithTarget:self selector:@selector(reRight)], pMoveRight, [CCActionCallFunc actionWithTarget:self selector:@selector(reLeft)], nil]]];
    
}
- (void)update:(float)dt{
    [self checkState];
    
}

- (void)reRigh{
    [self.enemyBody stopAllActions];
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniTortoiseRight]]];
}

- (void)reLeft{
    [self.enemyBody stopAllActions];
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniTortoiseLeft]]];
}
// -----------------------------------------------------------------

@end

// ********************** EnemyTortoiseFly ****************** //
@implementation EnemyTortoiseFly

// -----------------------------------------------------------------
+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    return self;
}
- (instancetype)initWithFlyDis:(float)dis{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    
    self.enemyType = eEnemy_tortoiseFly;
    self.bodySize = CGSizeMake(18.0f, 24.0f);
    self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"tortoise0.png"] rect:CGRectMake(0, 0, 18, 24)];
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.0f)];
    
    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 9, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(18, 24)];
//    [self.enemyLifeOver retain];
    
    self.overByArrow = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 8, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(18, 24)];
//    [self.overByArrow retain];
    
    self.flyDis = dis;
    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    [self setEnemyState:eEnemyState_active];
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniTortoiseFly]]];
    CCActionInterval *pMoveDown = [CCActionMoveBy actionWithDuration:2.0f position:ccp(0, -self.flyDis)];
    CCActionInterval *pMoveUp = [CCActionMoveBy actionWithDuration:2.0f position:ccp(0, self.flyDis)];
    
    [self runAction:[CCActionRepeatForever actionWithAction:[CCActionSequence actions:pMoveDown, pMoveUp, nil]]];
    
}
- (void)update:(float)dt{
    [self checkState];
    
}
@end

@implementation EnemyFireString

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    return self;
}
- (instancetype)initWithBegAngle:(float)begAngle AndTime:(float)time
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    
    self.enemyType = eEnemy_fireString;
    
    self.pArrayFire = [NSMutableArray arrayWithCapacity:3];
//    [self.pArrayFire retain];
    
    self.enemyBody = [CCSprite spriteWithImageNamed:@"fireBall.png"];
    [self.pArrayFire addObject:self.enemyBody];
    self.enemyBody2 = [CCSprite spriteWithImageNamed:@"fireBall.png"];
    [self.pArrayFire addObject:self.enemyBody2];
    self.enemyBody3 = [CCSprite spriteWithImageNamed:@"fireBall.png"];
    [self.pArrayFire addObject:self.enemyBody3];
    self.fireSize = CGSizeMake(8.0f, 8.0f);
    
    [self.enemyBody setPosition:ccp(8, 8)];
    [self addChild:self.enemyBody];
    [self.enemyBody2 setPosition:ccp(24, 8)];
    [self addChild:self.enemyBody2];
    [self.enemyBody3 setPosition:ccp(40, 8)];
    [self addChild:self.enemyBody3];
    
    self.bodySize = CGSizeMake(48, 16);
    [self setContentSize:self.bodySize];
    [self setAnchorPoint:ccp(0.0f, 0.5f)];
    
    self.begAngle = begAngle;
    self.time = time;
    
    self.angle = begAngle;
    self.PI = 3.1415926;
    
    self.enemyLifeOver = nil;
    self.overByArrow = nil;
    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    
    [self setEnemyState:eEnemyState_active];
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniRotatedFireBall]]];
    [self.enemyBody2 runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniRotatedFireBall]]];
    [self.enemyBody3 runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniRotatedFireBall]]];
    
    [self runAction:[CCActionRepeatForever actionWithAction:[CCActionSequence actions:[CCActionRotateBy actionWithDuration:1.0f angle:-self.begAngle], [CCActionCallFunc actionWithTarget:self selector:@selector(launchFireString)], nil]]];
}

- (void)stopEnemyUpdate
{
    [self.enemyBody stopAllActions];
    [self.enemyBody2 stopAllActions];
    [self.enemyBody3 stopAllActions];
}

- (enum EnemyVSHero)checkCollisionWithHero
{
    enum EnemyVSHero ret = eVS_nonKilled;
    
    CGPoint heroPos = [[Hero getHeroInstance] position];
    CGSize heroSize = [[Hero getHeroInstance] contentSize];
    CGRect heroRect = CGRectMake(heroPos.x - heroSize.width/2 + 2, heroPos.y + 2,
                                 heroSize.width - 4, heroSize.height - 4);
    
    CGPoint thisPos = [self position];
    
    double angleTemp = 2 * self.PI * self.angle / 360.0f;
    for (int i = 0; i < 3; ++i)
    {
        CGPoint firePos = ccp(thisPos.x + (2*i*8+8)*cos(angleTemp), thisPos.y + (2*i*8+8)*sin(angleTemp));
        CGRect fireRect = CGRectMake(firePos.x - self.fireSize.width/2, firePos.y - self.fireSize.height/2,
                                     self.fireSize.width, self.fireSize.height);
        
        if (CGRectIntersectsRect(heroRect, fireRect))
        {
            ret = eVS_heroKilled;
            break;
        }
    }
    
    return ret;
}

- (void)launchFireString{
    [self runAction:[CCActionRepeatForever actionWithAction:[CCActionRotateBy actionWithDuration:self.time angle:-360.0f]]];
    //    [self update:(float)];
}
- (void)update:(float)dt{
    self.angle += (6.0/self.time);
    if (self.angle >= 360)
    {
        self.angle -= 360.0f;
    }
}
// -----------------------------------------------------------------

@end

// ********************** EnemyFlyFish ****************** //
@implementation EnemyFlyFish

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    return self;
}

- (instancetype)initWithoffsetH:(float)offsetH andOffsetV:(float)offsetV andDuration:(float)duration
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    
    self.enemyType = eEnemy_flyFish;
    [self setEnemyState:eEnemyState_active];
    self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"flyFishRight.png"] rect:CGRectMake(16 * 4, 0, 16, 16)];
    self.bodySize = CGSizeMake(16, 16);
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.0f)];
    
    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"flyFishRight.png" rectInPixels:CGRectMake(16 * 4, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(16, 16)];
//    [self.enemyLifeOver retain];
    self.overByArrow = self.enemyLifeOver;
    
    self.offsetH = offsetH;
    self.offsetV = offsetV;
    self.offsetDuration = duration;
    self.isFlying = NO;
    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    [self setVisible:NO];
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniFlyFishR]]];
    //-------
//    this->scheduleUpdate();
}

- (void)update:(float)dt{
    if (!self.isFlying)
    {
        CGPoint heroPos = [[Hero getHeroInstance] position];
        if (fabs(heroPos.x - self.enemyPos.x) < self.bodySize.width)
        {
            [self flyInSky];
        }
    }
    
}
- (enum EnemyVSHero)checkCollisionWithHero;
{

    enum EnemyVSHero ret = eVS_nonKilled;
    
    CGPoint heroPos = [[Hero getHeroInstance] position];
    CGSize heroSize = [[Hero getHeroInstance] contentSize];
    CGRect heroRect = CGRectMake(heroPos.x - heroSize.width/2 + 2, heroPos.y + 2,
                                 heroSize.width - 4, heroSize.height - 4);
    
    CGPoint enemyPos = [self position];
    CGRect enemyRect = CGRectMake(enemyPos.x - self.bodySize.width/2 + 2, enemyPos.y + 2,
                                  self.bodySize.width - 4, self.bodySize.height - 4);
    
    if (CGRectIntersectsRect(heroRect, enemyRect))
    {
        ret = eVS_heroKilled;
    }
    
    return ret;
}

- (void)checkState
{
    //CCPoint heroPos = CCHero::getHeroInstance()->getPosition();
    //if (fabs(heroPos.x - enemyPos.x) < bodySize.width)
    //{
    //    enemyState = eEnemyState_active;
    //}
}

- (void)forKilledByHero
{
    
}

- (void) flyInSky{
    self.isFlying = YES;
    [self setVisible:YES];
    CCActionInterval *pMoveBy = [CCActionMoveBy actionWithDuration:self.offsetDuration position:ccp(self.offsetH, self.offsetV)];

    [self runAction:[CCActionSequence actions:pMoveBy, [CCActionCallFunc actionWithTarget:self selector:@selector(reSetNotInSky)], nil]];
}
- (void)reSetNotInSky{
    [self setVisible:NO];
    [self runAction:[CCActionPlace actionWithPosition:self.enemyPos]];
    self.isFlying = NO;
}

// -----------------------------------------------------------------

@end

@implementation EnemyBoss

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    self.enemyType = eEnemy_Boss;
    [self setEnemyState:eEnemyState_nonactive];
    
    self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"boss.png"] rect:CGRectMake(0, 0, 32, 32)];
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    self.bodySize = CGSizeMake(32, 32);
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.0f)];
    
    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"boss.png" rectInPixels:CGRectMake(0, 0, 32, 32) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(32, 32)];
//    [self.enemyLifeOver retain];
    self.overByArrow = self.enemyLifeOver;
//    [self.overByArrow retain];
    
    self.ccMoveOffset = 0.5f;
    self.moveOffset = -self.ccMoveOffset;
    
    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    self.leftSide = self.enemyPos.x - 32;
    self.rightSide = self.enemyPos.x + 32;
    //-------
}
- (void)update:(float)dt{
    [self checkState];
    
    if ([self enemyState] == eEnemyState_active)
    {
        CGPoint currentPos = [self position];
        currentPos.x += self.moveOffset;
        [self setPosition:currentPos];
        
        [self enemyCollistionH];
    }
}
- (enum EnemyVSHero)checkCollisionWithHero
{
    enum EnemyVSHero ret = eVS_nonKilled;
    
    CGPoint heroPos = [[Hero getHeroInstance] position];
    CGSize heroSize = [[Hero getHeroInstance] contentSize];
    CGRect heroRect = CGRectMake(heroPos.x - heroSize.width/2 + 2, heroPos.y + 2,
                                 heroSize.width - 4, heroSize.height - 4);
    
    CGPoint enemyPos = [self position];
    CGRect enemyRect = CGRectMake(enemyPos.x - self.bodySize.width/2 + 2, enemyPos.y + 2,
                                  self.bodySize.width - 4, self.bodySize.height - 4);
    
    if (CGRectIntersectsRect(heroRect, enemyRect))
    {
        ret = eVS_heroKilled;
    }
    
    return ret;
}

- (void)forKilledByBullet
{
    if ([[Global getGlobalInstance] currentBulletType] == eBullet_arrow)
    {
        [self runAction:[CCActionSequence actions:[CCActionMoveBy actionWithDuration:0.1f position:ccp(8, 0)], [CCActionMoveBy actionWithDuration:0.1f position:ccp(-8, 0)], nil]];
        
        static int num = 0;
        ++num;
        if (num == 5)
        {
            [self setEnemyState:eEnemyState_over];
            [[self enemyBody] stopAllActions];
            [self stopAllActions];
            [self unscheduleAllSelectors];
            [self setVisible:NO];
        }
    }
}

- (void)forKilledByHero
{
    
}
- (void)moveLeft{
    [[self enemyBody] stopAllActions];
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniBossMoveLeft]]];
}
- (void)moveRight{
    [[self enemyBody] stopAllActions];
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniBossMoveRight]]];
}

- (void)enemyCollistionH
{
    CGPoint pos = [self position];
    
    float leftCheck = pos.x - self.bodySize.width/2;
    
    if (leftCheck - self.leftSide <= 0.5f)
    {
        if ([self enemyState] == eEnemyState_active)
        {
            [[OALSimpleAudio sharedInstance] playEffect:@"BossHuoQiu.ogg"];
            CGPoint tempPos = ccp(pos.x - self.bodySize.width/4, pos.y + 3*(self.bodySize.height)/4);
            [[GameMap getGameMap] createNewBulletForBossWithPos:tempPos andType:eEnemy_BossFire];
        }
    }
    
    if (leftCheck <= self.leftSide)
    {
        self.moveOffset *= -1;
        [self moveRight];
        return ;
    }
    
    float rightCheck = pos.x + self.bodySize.width/2;
    if (rightCheck >= self.rightSide)
    {
        self.moveOffset *= -1;
        [self moveLeft];
    }
}

// -----------------------------------------------------------------

@end

// ********************** EnemyBossFire ****************** //
@implementation EnemyBossFire

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    self.enemyType = eEnemy_BossFire;
    [self setEnemyState:eEnemyState_active];
    
    self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"bossBullet.png"] rect:CGRectMake(0, 0, 24, 8)];
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    self.bodySize = CGSizeMake(24, 8);
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.0f)];
    
    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"bossBullet.png" rectInPixels:CGRectMake(0, 0, 24, 8) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(24, 8)];
//    [self.enemyLifeOver retain];
    self.overByArrow = self.enemyLifeOver;
//    [self.overByArrow retain];
    
    self.moveOffset = -3.0f;
    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniBossFireLeft]]];
}

- (void)update:(float)dt{
    [self checkState];
    
    if ([self enemyState] == eEnemyState_active)
    {
        CGPoint currentPos = [self position];
        currentPos.x += self.moveOffset;
        [self setPosition:currentPos];
    }
    
}

- (enum EnemyVSHero)checkCollisionWithHero
{
    enum EnemyVSHero ret = eVS_nonKilled;
    
    CGPoint heroPos = [[Hero getHeroInstance] position];
    CGSize heroSize = [[Hero getHeroInstance] contentSize];
    CGRect heroRect = CGRectMake(heroPos.x - heroSize.width/2 + 2, heroPos.y + 2,
                                 heroSize.width - 4, heroSize.height - 4);
    
    CGPoint enemyPos = [self position];
    CGRect enemyRect = CGRectMake(enemyPos.x - self.bodySize.width/2, enemyPos.y,
                                  self.bodySize.width, self.bodySize.height);
    
    if (CGRectIntersectsRect(heroRect, enemyRect))
    {
        ret = eVS_heroKilled;
    }
    
    return ret;
}

- (void)forKilledByBullet
{
    
}

- (void)forKilledByHero
{
    
}

@end

@implementation EnemyAddMushroom

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    return self;
}

- (instancetype)initWithNum:(int)addnum{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    
    self.enemyType = eEnemy_AddMushroom;
    [self setEnemyState:eEnemyState_nonactive];
    
    self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Mushroom0.png"] rect:CGRectMake(0, 0, 16, 16)];
    self.bodySize = CGSizeMake(16, 16);
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.0f)];
    
    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"Mushroom0.png" rectInPixels:CGRectMake(0, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(16, 16)];
//    [self.enemyLifeOver retain];
    self.overByArrow = [CCSpriteFrame frameWithTextureFilename:@"Mushroom0.png" rectInPixels:CGRectMake(16 * 3, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(16, 16)];
//    [self.overByArrow retain];
    
    self.addNums = addnum;
    self.isAddable = YES;
    
    return self;
}


- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    //-------
}

- (void)update:(float)dt{
    [self checkState];
    
    if ([self enemyState] == eEnemyState_active)
    {
        if (self.addNums)
        {
            if (self.isAddable)
            {
                self.isAddable = NO;
                [self runAction:[CCActionSequence actions:[CCActionMoveBy actionWithDuration:0.5f position:ccp(0, 16)], [CCActionCallFunc actionWithTarget:self selector:@selector(addMushroom)], nil]];

                [self runAction:[CCActionSequence actions:[CCActionDelay actionWithDuration:2.0f], [CCActionCallFunc actionWithTarget:self selector:@selector(reSetNonAddable)], nil]];
            }
        }
        else
        {
            [self setEnemyState:eEnemyState_over];
            [[self enemyBody] stopAllActions];
            [self stopAllActions];
            [self unscheduleAllSelectors];
            [self setVisible:NO];
        }
    }
    
}

- (enum EnemyVSHero)checkCollisionWithHero
{
    enum EnemyVSHero ret = eVS_nonKilled;

    CGPoint heroPos = [[Hero getHeroInstance] position];
    CGSize heroSize = [[Hero getHeroInstance] contentSize];
    CGRect heroRect = CGRectMake(heroPos.x - heroSize.width/2 + 2, heroPos.y + 2,
                                 heroSize.width - 4, heroSize.height - 4);
    
    CGPoint enemyPos = [self position];
    CGRect enemyRect = CGRectMake(enemyPos.x - self.bodySize.width/2 + 2, enemyPos.y + 2,
                                  self.bodySize.width - 4, self.bodySize.height - 4);
    
    if (CGRectIntersectsRect(heroRect, enemyRect))
    {
        ret = eVS_heroKilled;
    }
    
    return ret;
}

- (void)forKilledByHero
{
    
}

- (void)addMushroom
{
    --self.addNums;
    [[GameMap getGameMap] createNewBulletForBossWithPos:[self position] andType:eEnemy_mushroom];
    [self runAction:[CCActionMoveBy actionWithDuration:0.5f position:ccp(0, -16)]];
}

- (void)reSetNonAddable
{
    self.isAddable = YES;
}

// -----------------------------------------------------------------

@end

@implementation EnemyBattery

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    return self;
}

- (instancetype)initWithDelay:(float)delay
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    self.enemyType = eEnemy_Battery;
    [self setEnemyState:eEnemyState_nonactive];
    
    self.enemyBody = [CCSprite spriteWithImageNamed:@"battery.png"];
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    self.bodySize = CGSizeMake(32, 32);
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.0f)];
    
    self.enemyLifeOver = nil;
    self.overByArrow = nil;
    
    self.isFireable = YES;
    
    self.fireDelay = delay;
    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    self.firePos = ccp(self.enemyPos.x - self.bodySize.width/2, self.enemyPos.y + self.bodySize.height/2);
    
//    this->scheduleUpdate();
}
- (void)update:(float)dt{
    [self checkState];
    
    if ([self enemyState] == eEnemyState_active)
    {
        if (self.isFireable)
        {
            self.isFireable = NO;
            
            [self addBatteryBullet];
            
            [self runAction:[CCActionSequence actions:[CCActionDelay actionWithDuration:self.fireDelay], [CCActionCallFunc actionWithTarget:self selector:@selector(reSetNonFireable)], nil]];
        }
    }
}

- (enum EnemyVSHero)checkCollisionWithHero
{
    enum EnemyVSHero ret = eVS_nonKilled;
    
    CGPoint heroPos = [[Hero getHeroInstance] position];
    CGSize heroSize = [[Hero getHeroInstance] contentSize];
    CGRect heroRect = CGRectMake(heroPos.x - heroSize.width/2 + 2, heroPos.y + 2,
                                 heroSize.width - 4, heroSize.height - 4);
    
    CGPoint enemyPos = [self position];
    CGRect enemyRect = CGRectMake(enemyPos.x - self.bodySize.width/2 + 2, enemyPos.y + 2,
                                  self.bodySize.width - 4, self.bodySize.height - 4);
    
    if (CGRectIntersectsRect(heroRect, enemyRect))
    {
        ret = eVS_heroKilled;
    }
    
    return ret;
}

- (void)forKilledByBullet
{
    switch ([[Global getGlobalInstance] currentBulletType])
    {
        case eBullet_common:
        {
            [[self enemyBody] runAction:[CCActionSequence actions:[sAnimationMgr createAnimateWithType:eAniBossMoveLeft], [CCActionCallFunc actionWithTarget:self selector:@selector(stopAndClear)], nil]];
            
            break;
        }
        default:
            break;
    }
}

- (void)forKilledByHero
{

}

- (void)addBatteryBullet{
    [[GameMap getGameMap] createNewBulletForBossWithPos:self.firePos andType:eEnemy_BatteryBullet];
}
- (void)reSetNonFireable{
    self.isFireable = YES;
}

- (void)stopAndClear{
    [self setEnemyState:eEnemyState_over];
    
    [[self enemyBody] stopAllActions];
    [self stopAllActions];
    [self unscheduleAllSelectors];
    [self setVisible:NO];
}

// -----------------------------------------------------------------

@end

// ********************** EnemyBatteryBullet ****************** //
@implementation EnemyBatteryBullet

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    self.enemyType = eEnemy_BatteryBullet;
    [self setEnemyState:eEnemyState_active];
    
    self.enemyBody = [CCSprite spriteWithImageNamed:@"batteryBullet.png"];
    self.bodySize = CGSizeMake(4, 4);
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.5f)];
    
    self.ccMoveOffset = -1.5f;
    self.moveOffset = self.ccMoveOffset;

    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    //    this->scheduleUpdate();
}
- (void)update:(float)dt{
    [self checkState];
    
    if ([self enemyState] == eEnemyState_active)
    {
        CGPoint currentPos = [self position];
        currentPos.x += self.moveOffset;
        [self setPosition:currentPos];
    }
}

- (enum EnemyVSHero)checkCollisionWithHero
{
    enum EnemyVSHero ret = eVS_nonKilled;
    
    CGPoint heroPos = [[Hero getHeroInstance] position];
    CGSize heroSize = [[Hero getHeroInstance] contentSize];
    CGRect heroRect = CGRectMake(heroPos.x - heroSize.width/2 + 2, heroPos.y + 2,
                                 heroSize.width - 4, heroSize.height - 4);
    
    CGPoint enemyPos = [self position];
    
    if (CGRectContainsPoint(heroRect, enemyPos))
    {
        ret = eVS_heroKilled;
    }
    
    return ret;
}

- (void)forKilledByBullet
{

}

- (void)forKilledByHero
{
    
}
@end

// ********************** EnemyDarkCloud ****************** //
@implementation EnemyDarkCloud

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here

    return self;
}

- (instancetype)initWithDelay:(float)delay andType:(int)type
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    self.enemyType = eEnemy_DarkCloud;
    [self setEnemyState:eEnemyState_nonactive];
    
    self.type = type;
    switch (self.type)
    {
        case 0:
            self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"cloud.png"] rect:CGRectMake(114, 0, 32, 24)];
            self.normal = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"cloud.png"] rect:CGRectMake(114, 0, 32, 24)];
            self.bodySize = CGSizeMake(32, 32);
            self.dark = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"darkCloud.png"] rect:CGRectMake(114, 0, 32, 24)];
            break;
        case 1:
            self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"cloud.png"] rect:CGRectMake(0, 0, 48, 24)];
            self.normal = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"cloud.png"] rect:CGRectMake(0, 0, 48, 24)];
            self.bodySize = CGSizeMake(64, 32);
            self.dark = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"darkCloud.png"] rect:CGRectMake(0, 0, 48, 24)];
            break;
        case 2:
            self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"cloud.png"] rect:CGRectMake(49, 0, 64, 24)];
            self.normal = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"cloud.png"] rect:CGRectMake(49, 0, 64, 24)];
            self.bodySize = CGSizeMake(32, 32);
            self.dark = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"darkCloud.png"] rect:CGRectMake(49, 0, 64, 24)];
            break;
        default:
            break;
    }
    
//    [[self dark] retain];
//    [[self normal] retain];
    
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.0f)];
    
    self.enemyLifeOver = nil;
    self.overByArrow = nil;
    
    self.delay = delay;
    self.dropRegion = 64.0f;
    
    self.isDropable = YES;
    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    self.leftSide = self.enemyPos.x - self.dropRegion;
    self.rightSide = self.enemyPos.x + self.dropRegion;

    //    this->scheduleUpdate();
}
- (void)update:(float)dt{
    [self checkState];
    
    CGPoint heroPos = [[Hero getHeroInstance] position];
    
    if ([self enemyState] == eEnemyState_active)
    {
        if (self.leftSide <= heroPos.x && heroPos.x <= self.rightSide)
        {
            if (self.isDropable)
            {
                self.isDropable = NO;
                
                [self addLighting];
                
                [self runAction:[CCActionSequence actions:[CCActionDelay actionWithDuration:self.delay], [CCActionCallFunc actionWithTarget:self selector:@selector(reSetDropable)], nil]];
            }
        }
    }
}

- (void)addLighting{
    [[self enemyBody] setSpriteFrame:self.dark];
    [[GameMap getGameMap] createNewBulletForBossWithPos:self.enemyPos andType:eEnemy_Lighting];
    [self runAction:[CCActionSequence actions:[CCActionDelay actionWithDuration:0.3f], [CCActionCallFunc actionWithTarget:self selector:@selector(reSetNormal)], nil]];
}
- (void)reSetDropable{
    self.isDropable = YES;
}
- (void)reSetNormal{
    [[self enemyBody] setSpriteFrame:self.normal];
}

- (void)forKilledByHero
{
    
}

- (void)forKilledByBullet
{
    
}
// -----------------------------------------------------------------

@end

// ********************** EnemyLighting ****************** //
@implementation EnemyLighting

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    self.enemyType = eEnemy_Lighting;
    [self setEnemyState:eEnemyState_active];
    
    self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"lighting.png"] rect:CGRectMake(0, 0, 16, 32)];
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    self.bodySize = CGSizeMake(16, 32);
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.0f)];
    
    self.enemyLifeOver = nil;
    self.overByArrow = nil;
    
    self.ccJumpOffset = 2.0f;
    self.jumpOffset = -self.ccJumpOffset;
    
    return self;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniLighting]]];
    //-----
}

- (void)update:(float)dt{
    [self checkState];
    
    if ([self enemyState] == eEnemyState_active)
    {
        CGPoint currentPos = [self position];
        currentPos.y += self.jumpOffset;
        [self setPosition:currentPos];
    }
    
}

- (void)checkState
{
    CGPoint pos = [self position];
    
    
    if (pos.y <= 2)
    {
        [self setEnemyState:eEnemyState_over];
        [[self enemyBody] stopAllActions];
        [self stopAllActions];
        [self unscheduleAllSelectors];
        [self setVisible:NO];
    }
}

- (enum EnemyVSHero)checkCollisionWithHero;
{
    enum EnemyVSHero ret = eVS_nonKilled;
    
    CGPoint heroPos = [[Hero getHeroInstance] position];
    CGSize heroSize = [[Hero getHeroInstance] contentSize];
    CGRect heroRect = CGRectMake(heroPos.x - heroSize.width/2 + 2, heroPos.y + 2,
                                 heroSize.width - 4, heroSize.height - 4);
    
    CGPoint enemyPos = [self position];
    CGRect enemyRect = CGRectMake(enemyPos.x - self.bodySize.width/2 + 2, enemyPos.y + 2,
                                  self.bodySize.width - 4, self.bodySize.height - 4);
    
    if (CGRectIntersectsRect(heroRect, enemyRect))
    {
        ret = eVS_heroKilled;
    }
    
    return ret;
}
@end




