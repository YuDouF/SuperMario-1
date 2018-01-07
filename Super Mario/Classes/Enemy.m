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
    
    self.enemyState = eEnemyState_nonactive;
    
    return self;
}

- (CGRect)getEnemyRect
{
    CGPoint pos = [self position];
    return CGRectMake(pos.x - self.bodySize.width/2 + 2, pos.y + 2, self.bodySize.width - 4, self.bodySize.height - 4);
}
// -----------------------------------------------------------------
- (void)setEnemyState:(enum EnemyState)state
{
    self.enemyState = state;
    switch (self.enemyState)
    {
        case eEnemyState_over:
        {
            [[self enemyBody] stopAllActions];
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
        self.enemyState = eEnemyState_active;
    }
    else
    {
        if (pos.x + self.bodySize.width/2 - tempMaxH < 0)
        {
            self.enemyState = eEnemyState_over;
        }
        else
        {
             self.enemyState = eEnemyState_nonactive;
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
    leftPos = ccp(leftPos.x + self.bodySize.width/2 + [[GameMap getGameMap] tileSize].width, currentPos.y);
    
    enum TileType tileType;
    // ◊Û≤‡ºÏ≤‚
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
    rightPos = ccp(rightPos.x - self.bodySize.width/2, currentPos.y);
    
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
    bool downFlag = false;
    switch (tileType)
    {
        case eTile_Land:
        case eTile_Pipe:
        case eTile_Block:
        {
            downFlag = true;
            self.jumpOffset = 0.0f;
            [self setPosition:downPos];
            break;
        }
        case eTile_Trap:
        {
            [self setEnemyState:eEnemyState_over];
            break;
        }
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
    self.enemyState = eEnemyState_over;
    [[self enemyBody] stopAllActions];
    [self stopAllActions];
    [self unscheduleAllSelectors];

    [[self enemyBody] setSpriteFrame:self.enemyLifeOver];
    CCActionInterval *pDelay = [CCActionDelay actionWithDuration:1.0f];
//    this->runAction(CCSequence::create(pDelay,
//                                       CCCallFunc::create(this, callfunc_selector(CCEnemy::setNonVisibleForKilledByHero)), NULL));
    [self runAction:[CCActionSequence actions:pDelay, [CCActionCallFunc actionWithTarget:self selector:@selector(setNonVisibleForKilledByHero:)], nil]];
}

- (void)setNonVisibleForKilledByHero
{
    [self setVisible:NO];
};

- (void)forKilledByBullet
{
    self.enemyState = eEnemyState_over;
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
//        this->runAction(CCSequence::create(pDelay,
//                                           CCCallFunc::create(this, callfunc_selector(CCEnemy::setNonVisibleForKilledByBullet)), NULL));
        [self runAction:[CCActionSequence actions:pDelay, [CCActionCallFunc actionWithTarget:self selector:@selector(setNonVisibleForKilledByBullet:)], nil]];
        return ;
    }
    
    if (pJumpBy)
    {
//        this->runAction(CCSequence::create(pJumpBy,
//                                           CCCallFunc::create(this, callfunc_selector(CCEnemy::setNonVisibleForKilledByBullet)), NULL));
        [self runAction:[CCActionSequence actions:pJumpBy, [CCActionCallFunc actionWithTarget:self selector:@selector(setNonVisibleForKilledByBullet:)], nil]];
    }
    else
    {
//        this->runAction(CCSequence::create(pMoveBy,
//                                           CCCallFunc::create(this, callfunc_selector(CCEnemy::setNonVisibleForKilledByBullet)), NULL));
        [self runAction:[CCActionSequence actions:pMoveBy, [CCActionCallFunc actionWithTarget:self selector:@selector(setNonVisibleForKilledByBullet:)], nil]];
    }
}

- (void)setNonVisibleForKilledByBullet
{
    self.enemyState = eEnemyState_over;
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
    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"Mushroom0.png" rectInPixels:CGRectMake(32, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:self.bodySize];
    [self.enemyLifeOver retain];
    
    self.overByArrow = [CCSpriteFrame frameWithTextureFilename:@"Mushroom0.png" rectInPixels:CGRectMake(48, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:self.bodySize];
    [self.overByArrow retain];
    
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
    
    if (self.enemyState == eEnemyState_active)
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
    
    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"flower0.png" rectInPixels:CGRectMake(0, 0, 16, 24) rotated:NO offset:ccp(0, 0) originalSize:self.bodySize];
    [self.enemyLifeOver retain];
    
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
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[CCActionSequence actions:pMoveBy, pDelay, pMoveBy, pDelay2, nil]]];
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
    CGRect enemyRect = CGRectMake(enemyPos.x - self.bodySize.width/2 + 2, enemyPos.y + self.bodySize.height - (enemyPos.y - self.startPos.y),
                                  self.bodySize.width - 4, enemyPos.y - self.startPos.y);
    
    if (CGRectIntersectsRect(heroRect, enemyRect))
    {
        ret = eVS_heroKilled;
    }
    
    return ret;
}

- (CGRect)getEnemyRect
{
    CGPoint enemyPos = [self position];
    CGRect enemyRect = CGRectMake(enemyPos.x - self.bodySize.width/2 + 2, enemyPos.y + self.bodySize.height - (enemyPos.y - self.startPos.y),
                                  self.bodySize.width - 4, enemyPos.y - self.startPos.y);
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
- (instancetype)initWithStartface:(int)_startface{
    switch (_startface)
    {
        case 0:
            self.startFace = eLeft;
            self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"tortoise0.png"] rect:CGRectMake(18 * 2, 0, 18, 24)];
            self.leftFace = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 2, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:self.bodySize];
            [self.leftFace retain];
            self.moveOffset = -self.ccMoveOffset;
            break;
        case 1:
            self.startFace = eRight;
            self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"tortoise0.png"] rect:CGRectMake(18 * 5, 0, 18, 24)];
            self.rightFace = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 5, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:self.bodySize];
            [self.rightFace retain];
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
    
    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 9, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:self.bodySize];
    [self.enemyLifeOver retain];
    
    self.overByArrow = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 8, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:self.bodySize];
    [self.overByArrow retain];
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
    
    if (self.enemyState == eEnemyState_active)
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
    self.enemyType = eEnemy_tortoiseRound;
    self.bodySize = CGSizeMake(18.0f, 24.0f);
    self.enemyBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"tortoise0.png"] rect:CGRectMake(18 * 2, 0, 18, 24)];
    [[self enemyBody] setAnchorPoint:ccp(0, 0)];
    [self setContentSize:self.bodySize];
    [self addChild:self.enemyBody];
    [self setAnchorPoint:ccp(0.5f, 0.0f)];

    self.enemyLifeOver = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 9, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:self.bodySize];
    [self.enemyLifeOver retain];
    
    self.overByArrow = [CCSpriteFrame frameWithTextureFilename:@"tortoise0.png" rectInPixels:CGRectMake(18 * 8, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:self.bodySize];
    [self.overByArrow retain];
    
    self.roundDis = dis;
}

- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)launchEnemy
{
    self.enemyState = eEnemyState_active;
    [self.enemyBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimateWithType:eAniTortoiseLeft]]];
    CCActionInterval *pMoveLeft = [CCActionMoveBy actionWithDuration:2.0f position:ccp(-roundDis, 0.0f)];
    CCActionInterval *pMoveRight = [CCActionMoveBy actionWithDuration:2.0f position:ccp(roundDis, 0.0f)];
    
    CCDelayTime *pDelay = [CCActionDelay actionWithDuration:0.2f];
    
    [self runAction:[CCActionRepeatForever actionWithAction:[CCActionSequence actions:pMoveLeft, [CCActionCallFunc actionWithTarget:self selector:@selector(reRight)], pMoveRight, [CCActionCallFunc actionWithTarget:self selector:@selector(reLeft)], nil]]]
    
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

- (void)launchFireString{
    
}
// -----------------------------------------------------------------

@end

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

- (void) flyInSky{
    
}
- (void)reSetNotInSky{
    
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
    
    
    
    
    return self;
}

- (void)moveLeft{
    
}
- (void)moveRight{
    
}

// -----------------------------------------------------------------

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

- (void)addMushroom{
    
}
- (void)reSetNonAddable{
    
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

- (void)addBatteryBullet{
    
}
- (void)reSetNonFireable{
    
}

- (void)stopAndClear{
    
}

// -----------------------------------------------------------------

@end

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

- (void)addLighting{
    
}
- (void)reSetDropable{
    
}
- (void)reSetNormal{
    
}

// -----------------------------------------------------------------

@end




