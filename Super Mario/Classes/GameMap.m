//
//  GameMap.m
//
//  Created by : Mr.Right
//  Project    : Super Mario
//  Date       : 2018/1/6
//
//  Copyright (c) 2018年 master.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "GameMap.h"
#import "AnimationManager.h"
#import "GameScene.h"
#import "Hero.h"
//#import "Bullet.h"
#import "Global.h"
#import "OALSimpleAudio.h"
#import "CCTextureCache.h"
// -----------------------------------------------------------------

@implementation GameMap
static GameMap *gameMap = nil;
// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}
+ (GameMap*)create:(NSString*)tmxFile{
    GameMap *pGameMap = [self getGameMap];
    if (pGameMap && [pGameMap initWithFile:tmxFile])
    {
        [pGameMap extraInit];
        return pGameMap;
    }
    CC_SAFE_DELETE(pGameMap);
    return nil;
}
+ (GameMap*)getGameMap{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        gameMap = [[self alloc]init];
    });
    return gameMap;
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    CCTexture *pTexture = [[CCTextureCache sharedTextureCache] addImage:@"superMarioMap.png"];
    self.brokenCoin = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(1, 18, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
    //    [[self brokenCoin] retain];
    
    self.pItemCoordArray = [CCPointArray arrayWithCapacity:100];
    //    self.pItemCoordArray->retain();
    
    self.pSpriteArray = [NSMutableArray arrayWithCapacity:4];
    //    self.pSpriteArray->retain();
    
    self.pMushroomPointArray = [CCPointArray arrayWithCapacity:100];
    //    self.pMushroomPointArray->retain();
    
    self.pEnemyArray = [NSMutableArray array];
    //    self.pEnemyArray->retain();
    
    self.pBulletArray = [NSMutableArray array];
    //    self.pBulletArray->retain();
    
    self.pGadgetArray = [NSMutableArray array];
    //    self.pGadgetArray->retain();
    
    self.pMushSprite = nil;
    self.pAddLifeMushroom = nil;
    self.pItem = nil;
    self.heroInGadget = nil;
    
    self.isBossMap = NO;
    
    //    self.gameMap = self;
    
    self.enemyTilePos = CGPointZero;
    self.pRandomEnemy = nil;
    
    // ◊®Œ™BossµÿÕº◊º±∏µƒ
    self.bridgeTileStartPos = CGPointZero;
    self.bridgeTileNums = 0;
    self.pBossEnemy = nil;
    self.pPrincess = nil;
    
    return self;
}
- (void)dealloc{
    [self unscheduleAllSelectors];
}

- (void)extraInit{
    self.tileSize = [self tileSize];
    self.mapSize = [self mapSize];
    
    self.cloudLayer = this->layerNamed("cloud");
    self.blockLayer = this->layerNamed("block");
    self.pipeLayer = this->layerNamed("pipe");
    self.landLayer = this->layerNamed("land");
    self.trapLayer = this->layerNamed("trap");
    self.objectLayer = this->objectGroupNamed("objects");
    self.coinLayer = this->layerNamed("coin");
    self.flagpoleLayer = this->layerNamed("flagpole");
    
    this->initObjects();
    
    
    if (self.isBossMap)
    {
        self.pFlag = CCSprite::create("axe.png");
        self.pFlag->retain();
        self.pPrincess = CCSprite::create("princess.png");
        self.pPrincess->setAnchorPoint(ccp(0.5f, 0.0f));
        self.pPrincess->setPosition(ccp(finalPoint.x + 16, finalPoint.y));
        this->addChild(pPrincess, this->getChildrenCount());
    }
    else
    {
        self.pFlag = CCSprite::create("flag.png");
        self.pFlag->retain();
    }
    
    self.pFlag->setAnchorPoint(ccp(0.5f, 0));
    self.pFlag->setPosition(flagPoint);
    this->addChild(pFlag, this->getChildrenCount());
    
    this->launchEnemyInMap();
    
    this->launchGadgetInMap();
    
    this->scheduleUpdate();
}

- (void)showFlagMove{
    
}
- (BOOL)isHeroInGadgetWithHeroPos:(CGPoint)heroPos andGadgetLevel:(float)gadgetLevel{
    
}
- (enum TileType)tileTypeforPos:(CGPoint)tileCoord{
    
}
- (void)breakBlockWithTileCoord:(CGPoint) tileCoord andBodyType:(enum BodyType)bodyType{
    
}
- (void)showBlockBroken:(CGPoint)tileCoord{
    
}
- (void)showJumpUpBlinkCoin:(CGPoint)tileCoord{
    
}
- (void)showBlockJump:(CGPoint)tileCoord{
    
}
- (void)showCoinJump:(CGPoint)tileCoord{
    
}
- (void)resetCoinBlockTexture{
    
}
- (void)showNewMushroomWithTileCoord:(CGPoint)tileCoord andBodyType:(enum BodyType)bodyType{
    
}
- (void)showAddLifeMushroom:(CGPoint)tileCoord{
    
}
- (BOOL)isMarioEatMushroom:(CGPoint)tileCoord{
    
}
- (BOOL)isMarioEatAddLifeMushroom:(CGPoint)tileCoord{
    
}
- (void)launchEnemyInMap{
    
}
- (void)launchGadgetInMap{
    
}
- (void)update:(float)dt{
    
}
- (void)stopUpdateForHeroDie{
    
}
- (void)pauseGameMap{
    
}
- (void)resumeGameMap{
    
}
- (void)enemyVSHero{
    
}
- (CGPoint)positionToTileCoord:(CGPoint)pos{
    
}
- (CGPoint)tilecoordToPosition:(CGPoint)tileCoord{
    
}
- (void)createNewBullet{
    
}
- (void)bulletVSEnemy{
    
}
- (void)createNewBulletForBossWithPos:(CGPoint)pos andType:(enum EnemyType)enemyType{
    
}

- (void)deleteOneMushPointFromArray:(CGPoint)tileCoord{
    
}

- (void)clearItem{
    
}
- (void)clearSpriteArray{
    
}

- (void)initObjects{
    
}
- (BOOL)itemCoordArrayContains:(CGPoint)tileCoord{
    
}
- (BOOL)mushroomPointContains:(CGPoint)tileCoord{
    
}
- (void)initBridgeArray{
    
}
- (void)randomShowEnemy{
    
}
- (void)randomLaunchEnemy{}

// -----------------------------------------------------------------

@end





