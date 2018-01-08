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
    
    self.pItemCoordArray = [CGPointArray arrayWithCapacity:100];
    //    self.pItemCoordArray->retain();
    
    self.pSpriteArray = [NSMutableArray arrayWithCapacity:4];
    //    self.pSpriteArray->retain();
    
    self.pMushroomPointArray = [CGPointArray arrayWithCapacity:100];
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
//    self.tileSize = [self tileSize];
//    self.mapSize = [self mapSize];
    
    self.cloudLayer = [self layerNamed:@"cloud"];
    self.blockLayer = [self layerNamed:@"block"];
    self.pipeLayer = [self layerNamed:@"pipe"];
    self.landLayer = [self layerNamed:@"land"];
    self.trapLayer = [self layerNamed:@"trap"];
    self.objectLayer = [self objectGroupNamed:@"objects"];
    self.coinLayer = [self layerNamed:@"coin"];
    self.flagpoleLayer = [self layerNamed:@"flagpole"];
    
    [self initObjects];
    
    
    if (self.isBossMap)
    {
        self.pFlag = [CCSprite spriteWithImageNamed:@"axe.png"];
//        self.pFlag->retain();
        self.pPrincess = [CCSprite spriteWithImageNamed:@"princess.png"];
        [[self pPrincess] setAnchorPoint:ccp(0.5f, 0.0f)];
        [[self pPrincess] setPosition:ccp(self.finalPoint.x + 16, self.finalPoint.y)];
        [self addChild:[self pPrincess] z:[[self children] count]];
    }
    else
    {
        self.pFlag = [CCSprite spriteWithImageNamed:@"flag.png"];
//        self.pFlag->retain();
    }

    [[self pFlag] setAnchorPoint:ccp(0.5f, 0)];
    [[self pFlag] setPosition:[self flagPoint]];
    [self addChild:[self pFlag] z:[[self children] count]];
    
    
    [self launchEnemyInMap];
    
    [self launchGadgetInMap];
    
//    this->scheduleUpdate();
}

- (void)showFlagMove{
    if (self.isBossMap)
    {
        [self initBridgeArray];
    }
    else
    {
        [[OALSimpleAudio sharedInstance] playEffect:@"QiZiLuoXia.ogg"];
        CCActionMoveBy *pMoveBy = [CCActionMoveBy actionWithDuration:2.0f position:ccp(0, -8 * 16)];
        [[self pFlag] runAction:pMoveBy];
    }
}

- (void)initObjects{
    NSMutableArray *tempArray = [[self objectLayer] objects];
    NSDictionary *pDic = nil;
    for (unsigned int idx = 0; idx < [tempArray count]; ++idx)
    {
        pDic = (NSDictionary *)[tempArray objectAtIndex:idx];
        int posX = [(NSString*)[pDic objectForKey:@"x"] intValue];
        int posY = [(NSString*)[pDic objectForKey:@"y"] intValue];
        posY -= [self tileSize].height;
        CGPoint tileXY = [self positionToTileCoord:ccp(posX, posY)];
        
        NSString *name = (NSString*)[pDic objectForKey:@"name"];
        NSString *type = (NSString*)[pDic objectForKey:@"type"];
        
        if ([name isEqualToString:@"enemy"])
        {
            Enemy *pEnemy = nil;
            if ([type isEqualToString:@"mushroom"])
            {
                pEnemy = [EnemyMushroom new];
            }
            else if ([type isEqualToString:@"flower"])
            {
                pEnemy = [EnemyFlower new];
            }
            else if ([type isEqualToString:@"tortoise"])
            {
                
                pEnemy = [[EnemyTortoise alloc] initWithStartface:0];
            }
            else if ([type isEqualToString:@"tortoise_round"])
            {
                NSString *dis = (NSString*)[pDic objectForKey:@"roundDis"];
                int roundDis = [dis floatValue];
                pEnemy = [[EnemyTortoiseRound alloc] initWithRoundDis:roundDis];
            }
            else if ([type isEqualToString:@"tortoise_fly"])
            {
                NSString *dis = (NSString*)[pDic objectForKey:@"flyDis"];
                int flyDis = [dis floatValue];
                pEnemy = [[EnemyTortoiseFly alloc] initWithFlyDis:flyDis];
            }
            else if ([type isEqualToString:@"fire_string"])
            {
                NSString *str = (NSString*)[pDic objectForKey:@"begAngle"];
                float begAngle = [str floatValue];
                str = (NSString*)[pDic objectForKey:@"time"];
                float time = [str floatValue];
                pEnemy = [[EnemyFireString alloc] initWithBegAngle:begAngle AndTime:time];
            }
            else if ([type isEqualToString:@"flyfish"])
            {
                NSString *str = (NSString*)[pDic objectForKey:@"offsetH"];
                float offsetH = [str floatValue];
                str = (NSString*)[pDic objectForKey:@"offsetV"];
                float offsetV = [str floatValue];
                str = (NSString*)[pDic objectForKey:@"duration"];
                float duration = [str floatValue];
                
                pEnemy = [[EnemyFlyFish alloc] initWithoffsetH:offsetH andOffsetV:offsetV andDuration:duration];
            }
            else if ([type isEqualToString:@"boss"])
            {
                self.isBossMap = true;
                pEnemy = [EnemyBoss new];
                self.pBossEnemy = pEnemy;
            }
            else if ([type isEqualToString:@"addmushroom"])
            {
                NSString *str = (NSString*)[pDic objectForKey:@"nums"];
                int nums = [str intValue];
                pEnemy = [[EnemyAddMushroom alloc] initWithNum:nums];
            }
            else if ([type isEqualToString:@"battery"])
            {
                NSString *str = (NSString*)[pDic objectForKey:@"delay"];
                float delay = [str floatValue];
                pEnemy = [[EnemyBattery alloc] initWithDelay:delay];
            }
            else if ([type isEqualToString:@"darkcloud"])
            {
                NSString *str = (NSString*)[pDic objectForKey:@"delay"];
                float delay = [str floatValue];
                str = (NSString*)[pDic objectForKey:@"style"];
                int style = [str intValue];
                pEnemy = [[EnemyDarkCloud alloc] initWithDelay:delay andType:style];
            }
            
            if (pEnemy != nil)
            {
                [pEnemy setTileCoord:tileXY];
                [pEnemy setEnemyPos:ccp(posX, posY)];
                [[self pEnemyArray] addObject:pEnemy];
            }
        }
        else if ([name isEqualToString:@"gadget"])
        {
            NSString *str = (NSString*)[pDic objectForKey:@"ladderDis"];
            float dis = [str floatValue];
            int val;
            Gadget *pGadget = nil;
            if ([type isEqualToString:@"ladderLR"])
            {
    
                pGadget = new CCGadgetLadderLR(dis);
                str = (NSString*)[pDic objectForKey:@"LorR"];
                val = [str intValue];
                pGadget->setStartFace(val);
            }
            else if ([type isEqualToString:@"ladderUD"])
            {
                // …œœ¬“∆∂ØµƒÃ›◊”
                pGadget = new CCGadgetLadderUD(dis);
                str = (NSString*)[pDic objectForKey:@"UorD"];
                val = [str intValue];
                pGadget->setStartFace(val);
            }
            
            if (pGadget != NULL)
            {
                pGadget->setStartPos(ccp(posX, posY));
                pGadgetArray->addObject(pGadget);
            }
        }
        else if ([name isEqualToString:@"mushroom"])
        {
            if ([type isEqualToString:@"MushroomReward"])
            {
                
                [[self pMushroomPointArray] addControlPoint:tileXY];
            }
            else if ([type isEqualToString:@"MushroomAddLife"])
            {
                
                self.addLifePoint = tileXY;
            }
        }
        else if ([name isEqualToString:@"others"])
        {
            if ([type isEqualToString:@"BirthPoint"])
            {
                
                self.marioBirthPos = [self tilecoordToPosition:tileXY];
                self.marioBirthPos.x += [self tileSize].width / 2;
            }
            else if ([type isEqualToString:@"flagpoint"])
            {
                self.flagPoint = ccp(posX, posY);
            }
            else if ([type isEqualToString:@"finalpoint"])
            {
                self.finalPoint = ccp(posX, posY);
            }
            else if ([type isEqualToString:@"bridgestartpos"])
            {
                self.bridgeTileStartPos = tileXY;
            }
        }
    }
}

- (void)launchEnemyInMap{
    Gadget *tempGadget = nil;
    unsigned int gadgetCount = [[self pGadgetArray] count];
    for (unsigned int idx = 0; idx < gadgetCount; ++idx)
    {
        tempGadget = (Gadget *)[[self pGadgetArray] objectAtIndex:idx];
        [tempGadget setPosition:[tempGadget getStartPos]];
        [self addChild:tempGadget z:3];
        [tempGadget launchGadget];
    }
}
- (void)enemyVSHero{
    Enemy *tempEnemy = nil;
    enum EnemyVSHero vsRet;
    unsigned int enemyCount = [[self pEnemyArray] count];
    for (unsigned int idx = 0; idx < enemyCount; ++idx)
    {
        tempEnemy = (CCEnemy *)[[self pEnemyArray] objectAtIndex:idx];
        if ([tempEnemy getEnemyState] == eEnemyState_active)
        {
            vsRet = [tempEnemy checkCollisionWithHero];
            switch (vsRet)
            {
                case eVS_heroKilled:
                {
                    if (![[Hero getHeroInstance] isSafeTime])
                    {
                        [[Hero getHeroInstance] changeForGotEnemy];
                    }
                    break;
                }
                case eVS_enemyKilled:
                {
                    tempEnemy->forKilledByHero();
                    CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("CaiSiGuaiWu.ogg");
                    break;
                }
                default:
                    break;
            }
        }
    }
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
- (BOOL)itemCoordArrayContains:(CGPoint)tileCoord{
    
}
- (BOOL)mushroomPointContains:(CGPoint)tileCoord{
    
}
- (void)initBridgeArray{
    
}
- (void)randomShowEnemy{
    
}
- (void)randomLaunchEnemy{}

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


// -----------------------------------------------------------------

@end





