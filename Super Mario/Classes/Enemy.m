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
    // ”“≤‡ºÏ≤‚
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
    
    CGPoint downPos = CCGameMap::getGameMap()->tilecoordToPosition(downTilecoord);
    downPos = ccp(currentPos.x, downPos.y + CCGameMap::getGameMap()->getTileSize().height);
    
    TileType tileType = CCGameMap::getGameMap()->tileTypeforPos(downTilecoord);
    bool downFlag = false;
    switch (tileType)
    {
        case eTile_Land:
        case eTile_Pipe:
        case eTile_Block:
        {
            downFlag = true;
            jumpOffset = 0.0f;
            this->setPosition(downPos);
            break;
        }
        case eTile_Trap:
        {
            this->setEnemyState(eEnemyState_over);
            break;
        }
    }
    
    if (downFlag)
    {
        return ;
    }
    
    jumpOffset -= ccJumpOffset;
}


- (EnemyVSHero)checkCollisionWithHero()
{
    EnemyVSHero ret = eVS_nonKilled;
    
    CGPoint heroPos = CCHero::getHeroInstance()->getPosition();
    CCSize heroSize = CCHero::getHeroInstance()->getContentSize();
    CCRect heroRect = CCRectMake(heroPos.x - heroSize.width/2 + 2, heroPos.y + 3,
                                 heroSize.width - 4, heroSize.height - 4);
    
    CCRect heroRectVS = CCRectMake(heroPos.x - heroSize.width/2 - 3, heroPos.y,
                                   heroSize.width - 6, 2);
    
    CGPoint enemyPos = this->getPosition();
    CCRect enemyRect = CCRectMake(enemyPos.x - bodySize.width/2 + 1, enemyPos.y,
                                  bodySize.width - 2, bodySize.height - 4);
    
    CCRect enemyRectVS = CCRectMake(enemyPos.x - bodySize.width/2 - 2, enemyPos.y + bodySize.height - 4,
                                    bodySize.width - 4, 4);
    
    if (heroRectVS.intersectsRect(enemyRectVS))
    {
        ret = eVS_enemyKilled;
        return ret;
    }
    
    if (heroRect.intersectsRect(enemyRect))
    {
        ret = eVS_heroKilled;
        return ret;
    }
    
    return ret;
}

void CCEnemy::forKilledByHero()
{
    enemyState = eEnemyState_over;
    enemyBody->stopAllActions();
    this->stopAllActions();
    this->unscheduleUpdate();
    enemyBody->setDisplayFrame(enemyLifeOver);
    CCActionInterval *pDelay = CCDelayTime::create(1.0f);
    this->runAction(CCSequence::create(pDelay,
                                       CCCallFunc::create(this, callfunc_selector(CCEnemy::setNonVisibleForKilledByHero)), NULL));
}

void CCEnemy::setNonVisibleForKilledByHero()
{
    this->setVisible(false);
}

void CCEnemy::forKilledByBullet()
{
    enemyState = eEnemyState_over;
    enemyBody->stopAllActions();
    this->unscheduleUpdate();
    
    CCMoveBy *pMoveBy = NULL;
    CCJumpBy *pJumpBy = NULL;
    
    switch (CCGlobal::getGlobalInstance()->getCurrentBulletType())
    {
        case eBullet_common:
        {
            if (enemyType == eEnemy_mushroom || enemyType == eEnemy_AddMushroom)
            {
                enemyBody->setDisplayFrame(overByArrow);
            }
            else
            {
                enemyBody->setDisplayFrame(enemyLifeOver);
            }
            
            switch (CCHero::getHeroInstance()->face)
            {
                case eRight:
                    pJumpBy = CCJumpBy::create(0.3f, ccp(bodySize.width*2, 0), bodySize.height, 1);
                    break;
                case eLeft:
                    pJumpBy = CCJumpBy::create(0.3f, ccp(-bodySize.width*2, 0), bodySize.height, 1);
                    break;
                default:
                    break;
            }
            
            break;
        }
        case eBullet_arrow:
        {
            enemyBody->setDisplayFrame(overByArrow);
            CCSprite *arrow = CCSprite::create("arrow.png");
            arrow->setPosition(ccp(bodySize.width/2, bodySize.height/2));
            this->addChild(arrow);
            
            switch (CCHero::getHeroInstance()->face)
            {
                case eRight:
                    pMoveBy = CCMoveBy::create(0.1f, ccp(2*bodySize.width, 0));
                    break;
                case eLeft:
                    pMoveBy = CCMoveBy::create(0.1f, ccp(-2*bodySize.width, 0));
                    arrow->runAction(CCFlipX::create(true));
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
    
    // œ»≈–∂œ»Áπ˚ « ≥»Àª®µƒª∞£¨æÕ «‘≠µÿÕ£¡Ù“ª∂Œ ±º‰»ª∫Ûœ˚ ßµÙ
    if (enemyType == eEnemy_flower)
    {
        CCDelayTime *pDelay = CCDelayTime::create(0.2f);
        this->runAction(CCSequence::create(pDelay,
                                           CCCallFunc::create(this, callfunc_selector(CCEnemy::setNonVisibleForKilledByBullet)), NULL));
        return ;
    }
    
    if (pJumpBy)
    {
        this->runAction(CCSequence::create(pJumpBy,
                                           CCCallFunc::create(this, callfunc_selector(CCEnemy::setNonVisibleForKilledByBullet)), NULL));
    }
    else
    {
        this->runAction(CCSequence::create(pMoveBy,
                                           CCCallFunc::create(this, callfunc_selector(CCEnemy::setNonVisibleForKilledByBullet)), NULL));
    }
}

void CCEnemy::setNonVisibleForKilledByBullet()
{
    enemyState = eEnemyState_over;
    this->setVisible(false);
}


@end

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

- (void)reRigh{
    
}
- (void)reLeft{
    
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




