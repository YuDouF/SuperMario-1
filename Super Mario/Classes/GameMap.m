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
                [pGadget setStartFace:val];
            }
            else if ([type isEqualToString:@"ladderUD"])
            {
                // …œœ¬“∆∂ØµƒÃ›◊”
                pGadget = new CCGadgetLadderUD(dis);
                str = (NSString*)[pDic objectForKey:@"UorD"];
                val = [str intValue];
                [pGadget setStartFace:val];
            }
            
            if (pGadget != NULL)
            {
                [pGadget setStartPos:ccp(posX, posY)];
                [[self pGadgetArray] addObject:pGadget];
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
    Enemy *tempEnemy = nil;
    unsigned int enemyCount = [[self pEnemyArray] count];
    for (unsigned int idx = 0; idx < enemyCount; ++idx)
    {
        tempEnemy = (Enemy *)[[self pEnemyArray] objectAtIndex:idx];
        [tempEnemy setPosition:[tempEnemy enemyPos]];
        switch ([tempEnemy enemyType])
        {
            case eEnemy_flower:
            case eEnemy_AddMushroom:
                [self addChild:tempEnemy z:3];
                break;
            default:
                [self addChild:tempEnemy z:7];
                break;
        }
        
        [tempEnemy launchEnemy];
    }
}

- (void)launchGadgetInMap{
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
                    [tempEnemy forKilledByHero];
                    [[OALSimpleAudio sharedInstance] playEffect:@"CaiSiGuaiWu.ogg"];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

- (void)update:(float)dt{
    [self enemyVSHero];
    [self bulletVSEnemy];
}

- (void)stopUpdateForHeroDie{
    unsigned int enemyCount = [[self pEnemyArray] count];
    Enemy *pEnemy = nil;
    for (unsigned int idx = 0; idx < enemyCount; ++idx)
    {
        pEnemy = (Enemy *)[[self pEnemyArray] objectAtIndex:idx];
        if ([pEnemy getEnemyState] == eEnemyState_active)
        {
            [pEnemy stopEnemyUpdate];
            switch ([pEnemy enemyType])
            {
                case eEnemy_mushroom:
                case eEnemy_tortoise:
                    break;
                case eEnemy_flower:
                case eEnemy_flyFish:
                case eEnemy_tortoiseRound:
                case eEnemy_tortoiseFly:
                case eEnemy_fireString:
                    //case eEnemy_Boss:
                    
                    [pEnemy stopAllActions];
                    break;
            }
            
            [pEnemy unscheduleAllSelectors];
        }
    }
    
    unsigned int bulletCount = [[self pBulletArray] count];
    Bullet *pBullet = nil;
    for (unsigned int idx = 0; idx < bulletCount; ++idx)
    {
        pBullet = (Bullet *)[[self pBulletArray] objectAtIndex:idx];
        if ([pBullet bulletState] == eBulletState_active)
        {
            [pBullet unscheduleAllSelectors];
        }
    }
    
    
    unsigned int gadgetCount = [[self pGadgetArray] count];
    Gadget *pGadget = nil;
    for (unsigned int idx = 0; idx < gadgetCount; ++idx)
    {
        pGadget = (Gadget *)[[self pGadgetArray] objectAtIndex:idx];
        [pGadget stopAllActions];
        [pGadget unscheduleAllSelectors];
    }
    
    [self unscheduleAllSelectors];
}

- (enum TileType)tileTypeforPos:(CGPoint)tileCoord{
    int GID = [[self pipeLayer] tileGIDAt:tileCoord];
    if (GID > 0)
    {
        return eTile_Pipe;
    }
    GID = [[self blockLayer] tileGIDAt:tileCoord];
    if (GID > 0)
    {
        return eTile_Block;
    }
    GID = [[self landLayer] tileGIDAt:tileCoord];
    if (GID > 0)
    {
        return eTile_Land;
    }
    GID = [[self trapLayer] tileGIDAt:tileCoord];
    if (GID > 0)
    {
        return eTile_Trap;
    }
    GID = [[self coinLayer] tileGIDAt:tileCoord];
    if (GID > 0)
    {
        return eTile_Coin;
    }
    GID = [[self flagpoleLayer] tileGIDAt:tileCoord];
    if (GID > 0)
    {
        return eTile_Flagpole;
    }
    return eTile_NoneH;
}

- (void)breakBlockWithTileCoord:(CGPoint) tileCoord andBodyType:(enum BodyType)bodyType{
    int gID = [[self blockLayer] tileGIDAt:tileCoord];
    NSDictionary *pD = nil;
    pD = [self propertiesForGID:gID];
    
    if (pD)
    {
        NSString *str = nil;
        str = (NSString*)[pD objectForKey:@"blockType"];
        if (str)
        {
            int blockType = [str intValue];
            if (blockType == 2)
            {
                switch (bodyType)
                {
                    case eBody_Normal:
                    {
                        [self showBlockBroken:tileCoord];
                        [[self blockLayer] removeTileAt:tileCoord];
                    }
                        break;
                    case eBody_Small:
                    {
                        
                        [self showBlockJump:tileCoord];
                        [[OALSimpleAudio sharedInstance] playEffect:@"DingYingZhuanKuai.ogg"];
                    }
                        break;
                    default:
                        break;
                }
            }
            else if (blockType == 1)
            {
                if ([self itemCoordArrayContains:tileCoord] == NO)
                {
                    
                    [[self pItemCoordArray] addControlPoint:tileCoord];

                    
                    if ([self mushroomPointContains:tileCoord])
                    {
                        
                        [self resetCoinBlockTexture];
                        [self showNewMushroomWithTileCoord:tileCoord andBodyType:bodyType];
                        [self deleteOneMushPointFromArray:tileCoord];
                    }
                    else
                    {
                        
                        if (CCRANDOM_0_1() > 0.4f)
                        {
                            
                            [[OALSimpleAudio sharedInstance] playEffect:@"EatCoin.ogg"];
                            [self showJumpUpBlinkCoin:tileCoord];
                            [self showCoinJump:tileCoord];
                        }
                        else
                        {
                            [self showCoinJump:tileCoord];
                            
                            self.enemyTilePos = tileCoord;
                            [self runAction:[CCActionSequence actions:[CCActionDelay actionWithDuration:0.2f], [CCActionCallFunc actionWithTarget:self selector:@selector(randomShowEnemy)], nil]]
                        }
                        
                    }
                }
                else
                {
                    [[OALSimpleAudio sharedInstance] playEffect:@"DingYingZhuanKuai.ogg"];
                }
            }
            else if (blockType == 3)
            {
                if ([self itemCoordArrayContains:tileCoord] == NO)
                {
                    
                    [[self pItemCoordArray] addControlPoint:tileCoord];
                    
                    CCSprite *pSprite = [[self blockLayer] tileCoordinateAt:tileCoord];
                    [pSprite setSpriteFrame:[self brokenCoin]];
                    [self showAddLifeMushroom:tileCoord];
                }
            }
        }
    }
}

- (void)randomShowEnemy{
    
    [[OALSimpleAudio sharedInstance] playEffect:@"DingChuMoGuHua.wma"];
    
    // ∂•≥ˆµƒπ÷÷÷¿‡“≤◊ˆ“ª¥ŒÀÊª˙
    if (CCRANDOM_0_1() > 0.5f)
    {
        self.pRandomEnemy = [EnemyMushroom new];
        if (CCRANDOM_0_1() > 0.5f)
        {
            [[self pRandomEnemy] setMoveOffset:[[self pRandomEnemy] ccMoveOffset]];
        }
    }
    else
    {
        int val = 1;
        if (CCRANDOM_0_1() < 0.5f)
        {
            val = 1;
        }
        self.pRandomEnemy = [[EnemyTortoise alloc] initWithStartface:val];
    }
    
    CGPoint pos = [self tilecoordToPosition:[self enemyTilePos]];
    pos.x += self.tileSize.width / 2;
    
    [self.pRandomEnemy setPosition:pos];
    [self addChild:[self pRandomEnemy] z:[[self blockLayer] zOrder] - 1];
    
    [self pRandomEnemy] runAction:[CCActionSequence actions:[CCActionJumpBy actionWithDuration:0.2f position:ccp(0, 16) height:1 jumps:20], [CCActionCallFunc actionWithTarget:self selector:@selector(randomLaunchEnemy)], nil]
}

- (void)randomLaunchEnemy{
    
    [[self pEnemyArray] addObject:[self pRandomEnemy]];
    
    [[self pRandomEnemy] setZOrder:7];
    [[self pRandomEnemy] launchEnemy];
}

- (BOOL)itemCoordArrayContains:(CGPoint)tileCoord{
    CGPoint temp;
    BOOL flag = NO;
    for (unsigned int idx = 0; idx < [[self pItemCoordArray] count]; ++idx)
    {
        temp = [[self pItemCoordArray] getControlPointAtIndex:idx];
        if (temp.x == tileCoord.x && temp.y == tileCoord.y)
        {
            flag = YES;
            break;
        }
    }
    return flag;
}

- (BOOL)mushroomPointContains:(CGPoint)tileCoord{
    CGPoint temp;
    BOOL flag = NO;
    for (unsigned int idx = 0; idx < [[self pMushroomPointArray] count]; ++idx)
    {
        temp = [[self pMushroomPointArray] getControlPointAtIndex:idx];
        if (temp.x == tileCoord.x && temp.y == tileCoord.y)
        {
            flag = YES;
            break;
        }
    }
    return flag;
}

- (void)deleteOneMushPointFromArray:(CGPoint)tileCoord{
    CGPoint temp ;
    for (unsigned int idx = 0; idx < [[self pMushroomPointArray] count]; ++idx)
    {
        temp = [[self pMushroomPointArray] getControlPointAtIndex:idx];
        if (temp.x == tileCoord.x && temp.y == tileCoord.y)
        {
            [[self pMushroomPointArray] removeControlPointAtIndex:idx];
            break;
        }
    }
}

- (void)showBlockBroken:(CGPoint)tileCoord{
    
    [[OALSimpleAudio sharedInstance] playEffect:@"DingPoZhuan.ogg"];
    
    CCTexture *pTexture = [[CCTextureCache sharedTextureCache] addImage:@"singleblock.png"];
    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(0, 0, 8, 8) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
    CGPoint pos = [self tilecoordToPosition:tileCoord];
    pos.x += [self tileSize].width / 2;
    pos.y += [self tileSize].height / 2;
    
    CCSprite *pSprite1 = [CCSprite spriteWithSpriteFrame:frame];
    [pSprite1 setPosition:pos];
    [[self pSpriteArray] addObject:pSprite1];

    CCSprite *pSprite2 = [CCSprite spriteWithSpriteFrame:frame];
    [pSprite2 setPosition:pos];
    [[self pSpriteArray] addObject:pSprite2];
    
    CCSprite *pSprite3 = [CCSprite spriteWithSpriteFrame:frame];
    [pSprite3 setPosition:pos];
    [[self pSpriteArray] addObject:pSprite3];
    
    CCSprite *pSprite4 = [CCSprite spriteWithSpriteFrame:frame];
    [pSprite4 setPosition:pos];
    [[self pSpriteArray] addObject:pSprite4];
    
    [self addChild:pSprite1];
    [self addChild:pSprite2];
    [self addChild:pSprite3];
    [self addChild:pSprite4];
    
    CCActionInterval *pLeftUp = [CCActionJumpBy actionWithDuration:0.2f position:ccp(-[self tileSize].width * 2, [self tileSize].height) height:10 jumps:1];

    CCActionInterval *pRightUp = [CCActionJumpBy actionWithDuration:0.2f position:ccp([self tileSize].width * 2, [self tileSize].height) height:10 jumps:1];

    CCActionInterval *pLeftDown = [CCActionJumpBy actionWithDuration:0.2f position:ccp(-[self tileSize].width * 3, [self tileSize].height) height:5 jumps:1];

    CCActionInterval *pRightDown = [CCActionJumpBy actionWithDuration:0.2f position:ccp([self tileSize].width * 3, [self tileSize].height) height:5 jumps:1];
    
    [pSprite1 runAction:pLeftUp];
    [pSprite2 runAction:pRightUp];
    [pSprite3 runAction:pLeftDown];
    
    [pSprite4 runAction:[CCActionSequence actions:pRightDown, [CCActionCallFunc actionWithTarget:self selector:@selector(clearSpriteArray)], nil]]
}

- (void)showJumpUpBlinkCoin:(CGPoint)tileCoord{
    self.pItem = [Item create:eBlinkCoin];
    CGPoint pos = [self tilecoordToPosition:tileCoord];
    pos.x += [self tileSize].width / 2;
    pos.y += [self tileSize].height;
    [[self pItem] setPosition:pos];
    [[self pItem] setVisible:YES];
    [self addChild:self.pItem];
    
    CCActionInterval *pJump = [CCActionJumpBy actionWithDuration:0.16f position:ccp(0, [self tileSize].height) height:[self tileSize].height * 1.5 jumps:1];
    
    [[[self pItem] itemBody] runAction:[sAnimationMgr createAnimateWithType:eAniBlinkCoin]];

    [[self pItem] runAction:[CCActionSequence actions:pJump, [CCActionCallFunc actionWithTarget:self selector:@selector(clearItem)], nil]]
}

- (void)showBlockJump:(CGPoint)tileCoord{
    CCSprite *tempSprite = [[self blockLayer] tileCoordinateAt:tileCoord];
    [self blockLayer] tileCoordinateAt:tileCoord;888888
    CCActionInterval *pJumpBy = [CCActionJumpBy actionWithDuration:0.2f position:CGPointZero height:[self tileSize].height * 0.5 jumps:1];
    [tempSprite runAction:pJumpBy];
}
- (void)showCoinJump:(CGPoint)tileCoord{
    CCSprite *tempSprite = [[self blockLayer] tileCoordinateAt:tileCoord];
    CCActionInterval *pJumpBy = [CCActionJumpBy actionWithDuration:0.2f position:CGPointZero height:[self tileSize].height * 0.5 jumps:1];
    
    self.resetCoinPoint = tileCoord;
    
    [tempSprite runAction:[CCActionSequence action:pJumpBy, [CCActionCallFunc actionWithTarget:self selector:@selector(resetCoinBlockTexture)], nil]];
}
- (void)resetCoinBlockTexture{
    CCSprite *coinTile = [[self blockLayer] tileCoordinateAt:resetCoinPoint];
    [coinTile setSpriteFrame: [self brokenCoin]];
}
- (void)showNewMushroomWithTileCoord:(CGPoint)tileCoord andBodyType:(enum BodyType)bodyType{
    [[OALSimpleAudio sharedInstance] playEffect:@"DingChuMoGuHuoHua.ogg"];
    
    self.mushTileCoord = ccp(tileCoord.x, tileCoord.y - 1);
    
    CGPoint pos = [self tilecoordToPosition:tileCoord];
    pos.x += [self tileSize].width / 2;
    pos.y += [self tileSize].height / 2;
    
    switch (bodyType)
    {
        case eBody_Small:
        {
            self.pMushSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"rewardMushroomSet.png"] rect:CGRectMake(0, 0, 16, 16)];
        }
            break;
        case eBody_Normal:
        {
            pMushSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Tools.png"] rect:CGRectMake(0, 0, 18, 18)];
        }
            break;
        default:
            break;
    }
    
    pMushSprite->setPosition(pos);
    [[self pMushSprite] setPosition:pos];
    [self addChild:[self pMushSprite]];
    
    CCActionMoveBy *pMushJump = [CCActionMoveBy actionWithDuration:0.4f position:ccp(0, [self tileSize].height)];
    [[self pMushSprite] runAction:pMushJump];
}
- (void)showAddLifeMushroom:(CGPoint)tileCoord{
    [[OALSimpleAudio sharedInstance] playEffect:@"DingChuMoGuHua.wma"]
    
    
    self.addLifePoint = ccp(tileCoord.x, tileCoord.y - 1);
    
    CGPoint pos = [self tilecoordToPosition:tileCoord];
    pos.x += [self tileSize].width / 2;
    pos.y += [self tileSize].height / 2;
    
    self.pAddLifeMushroom = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"rewardMushroomSet.png"] rect:CGRectMake(16, 0, 16, 16)];

    [[self pAddLifeMushroom] setPosition:pos];
    [self addChild:[self pAddLifeMushroom]];
    
    CCActionMoveBy *pMushJump = [CCActionMoveBy actionWithDuration:0.4f position:ccp(0, [self tileSize].height)];
    [[self pAddLifeMushroom] runAction:pMushJump];
}
- (void)clearItem{
    [[self pItem] removeFromParentAndCleanup:YES];
    self.pItem = nil;
}

- (void)clearSpriteArray{
    CCSprite *pS = nil;
    for (unsigned int idx = 0; idx < [[self pSpriteArray] count]; ++idx)
    {
        pS = (CCSprite *)[[self pSpriteArray] objectAtIndex:idx];
        [pS removeFromParentAndCleanup:YES];
    }
}

- (BOOL)isMarioEatMushroom:(CGPoint)tileCoord{
    if (self.pMushSprite == nil)
    {
        return false;
    }
    if (tileCoord.x == self.mushTileCoord.x && tileCoord.y == self.mushTileCoord.y)
    {
        [[self pMushSprite] removeFromParentAndCleanup:YES];
        self.mushTileCoord = CGPointZero;
        self.pMushSprite = nil;
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isMarioEatAddLifeMushroom:(CGPoint)tileCoord{
    if (self.pAddLifeMushroom == nil)
    {
        return NO;
    }
    if (tileCoord.x == self.addLifePoint.x && tileCoord.y == self.addLifePoint.y)
    {
        [[self pAddLifeMushroom] removeFromParentAndCleanup:YES];
        self.mushTileCoord = CGPointZero;
        self.pAddLifeMushroom = nil;
        return YES;
    }
    else
    {
        return NO;
    }
}

- (CGPoint)positionToTileCoord:(CGPoint)pos{
    int x = pos.x / [self tileSize].width;
    int y = ([self tileSize].height - 1) - pos.y / [self tileSize].height;
    return ccp(x, y);
}
- (CGPoint)tilecoordToPosition:(CGPoint)tileCoord{
    float x = tileCoord.x * [self tileSize].width;
    float y = ([self tileSize].height - 1 - tileCoord.y) * [self tileSize].height;
    return ccp(x, y);
}

- (void)createNewBullet{
    Bullet *pBullet = nil;
    switch ([[Global getGlobalInstance] currentBulletType])
    {
        case eBullet_common:
            pBullet = [BulletCommon new];
            break;
        case eBullet_arrow:
            pBullet = [BulletArrow new];
            break;
        default:
            break;
    }

    [[self pBulletArray] addObject:pBullet]

    [pBullet setPosition:[pBullet startPos]];
    [self addChild:pBullet z:7];
    [pBullet launchBullet];
}
- (void)createNewBulletForBossWithPos:(CGPoint)pos andType:(enum EnemyType)enemyType{
    Enemy *pEnemy = nil;
    
    switch (enemyType)
    {
        case eEnemy_BossFire:
            pEnemy = [EnemyBossFire new];
            break;
        case eEnemy_mushroom:
            pEnemy = [EnemyMushroom new];
            break;
        case eEnemy_BatteryBullet:
            pEnemy = [EnemyBatteryBullet new];
            break;
        case eEnemy_Lighting:
            pEnemy = [EnemyLighting new];
            break;
        default:
            break;
    }
    
    if (pEnemy != nil)
    {
        [[self pEnemyArray] addObject:pEnemy];
        [pEnemy setEnemyPos:pos];
        [pEnemy setPosition:pos];
        [self addChild:pEnemy z:7];
        [pEnemy launchEnemy];
    }
}

- (void)bulletVSEnemy{
    unsigned int bulletCount = [[self pBulletArray] count];
    unsigned int enemyCount = [[self pEnemyArray] count];
    Bullet *pBullet = nil;
    Enemy *pEnemy = nil;
    NSMutableArray *delBullet = [NSMutableArray array];
    [delBullet retain];
    NSMutableArray *delEnemy = nil;
    CGRect bulletRect;
    CGRect enemyRect;
    
    for (unsigned int idxBullet = 0; idxBullet < bulletCount; ++idxBullet)
    {
        pBullet = (Bullet *)[[self pBulletArray] objectAtIndex:idxBullet];
        
        if ([pBullet bulletState] == eBulletState_nonactive)
        {
            [delBullet addObject:pBullet];
            continue;
        }
        bulletRect = [pBullet bulletRect];
        
        for (unsigned int idxEnemy = 0; idxEnemy < enemyCount; ++idxEnemy)
        {
            pEnemy = (Enemy *)[[self pEnemyArray] objectAtIndex:idxEnemy];
            switch ([pEnemy enemyType])
            {
                case eEnemy_BatteryBullet:
                case eEnemy_fireString:
                case eEnemy_Lighting:
                case eEnemy_DarkCloud:
                    continue;
                    break;
            }
            
            if ([pBullet bulletType] == eBullet_common &&
                [pEnemy enemyType] == eEnemy_Boss)
            {
                
                continue;
            }
            if ([pBullet bulletType] == eBullet_common &&
                [pEnemy enemyType] == eEnemy_BossFire)
            {
                
                continue;
            }
            
            if ([pEnemy getEnemyState] == eEnemyState_active)
            {
                enemyRect = [pEnemy getEnemyRect];
                
                if (CGRectIntersectsRect(bulletRect, enemyRect))
                {
                    [pBullet forKilledEnemy];
                    [[OALSimpleAudio sharedInstance] playEffect:@"HuoQiuDaDaoGuaiWu.ogg"];
                    [pEnemy forKilledByBullet];
                }
            }
        }
    }
    
    unsigned int delCount = [delBullet count];
    for (unsigned int idxDel = 0; idxDel < delCount; ++idxDel)
    {
        pBullet = (Bullet *)[delBullet objectAtIndex:idxDel];
//        pBulletArray->removeObject(pBullet, true);
        [[self pBulletArray] removeObject:pBullet];
        [self removeChild:pBullet cleanup:YES];
    }
//    delBullet->release();
//    [delBullet release];
}

- (BOOL)isHeroInGadgetWithHeroPos:(CGPoint)heroPos andGadgetLevel:(float)gadgetLevel{
    BOOL ret = NO;
    Gadget *tempGadget = nil;
    unsigned int gadgetCount = [[self pGadgetArray] count];
    CGRect gadgetRect;
    for (unsigned int idx = 0; idx < gadgetCount; ++idx)
    {
        tempGadget = (Gadget *)[[self pGadgetArray] objectAtIndex:idx];
        if ([tempGadget gadgetState] == eGadgetState_active)
        {
            gadgetRect = [tempGadget gadgetRect]
            if (CGRectContainsPoint(gadgetRect, heroPos))
            {
                self.gadgetLevel = [tempGadget position].y + [tempGadget gadgetSize].height;
                ret = YES;
                self.heroInGadget = tempGadget;
                [[Hero getHeroInstance] setGadgetable:YES];
                break;
            }
        }
    }
    return ret;
}

- (void)initBridgeArray{
    self.bridgeTileNums = 13;
    
    CCSprite *pS = nil;
    CGPoint bossPos = [[self pBossEnemy] position];
    CGPoint pos;
    for (int i = 0; i < bridgeTileNums; ++i)
    {
        CGPoint tilePos = self.bridgeTileStartPos;
        self.tilePos.x += i;
        //----------------
        pS = [[self landLayer] tileCoordinateAt:tilePos];
        [pS runAction:[CCActionMoveBy actionWithDuration:1.0f position:ccp(0, -60)]];
        
        [self tilecoordToPosition:tilePos];
        if (pos.x >= bossPos.x)
        {
            if ([[self pBossEnemy] getEnemyState] == eEnemyState_active)
            {
                [[OALSimpleAudio sharedInstance] playEffect:@"BossDiaoLuoQiaoXia.ogg"];
                [self pBossEnemy] runAction:[CCActionMoveBy actionWithDuration:1.0f position:ccp(0, -80)];
            }
        }
    }
    
    
    [[self pFlag] setVisible:NO];
}

- (void)pauseGameMap{
    unsigned int enemyCount = [[self pEnemyArray] count];
    Enemy *pEnemy = nil;
    for (unsigned int idx = 0; idx < enemyCount; ++idx)
    {
        pEnemy = (Enemy *)[[self pEnemyArray] objectAtIndex:idx];
        
        if ([pEnemy getEnemyState] == eEnemyState_active)
        {
            [pEnemy unscheduleAllSelectors];
        }
    }
    
    unsigned int bulletCount = [[self pBulletArray] count];
    Bullet *pBullet = nil;
    for (unsigned int idx = 0; idx < bulletCount; ++idx)
    {
        pBullet = (Bullet *)[[self pBulletArray] objectAtIndex:idx];
        if ([pBullet bulletState] == eBulletState_active)
        {
            [pBullet unscheduleAllSelectors];
        }
    }
    
    
    unsigned int gadgetCount = [[self pGadgetArray] count];
    Gadget *pGadget = nil;
    for (unsigned int idx = 0; idx < gadgetCount; ++idx)
    {
        pGadget = (Gadget *)[[self pGadgetArray] objectAtIndex:idx];
        [pGadget unscheduleAllSelectors];
    }
    
    [self unscheduleAllSelectors];
}

- (void)resumeGameMap{
    
    unsigned int enemyCount = [[self pEnemyArray] count];
    Enemy *pEnemy = nil;
    for (unsigned int idx = 0; idx < enemyCount; ++idx)
    {
        pEnemy = (Enemy *)[[self pEnemyArray] objectAtIndex:idx];
        
        if ([pEnemy getEnemyState] == eEnemyState_active)
        {
//            pEnemy->scheduleUpdate();
        }
    }
    
    unsigned int bulletCount = [[self pBulletArray] count];
    Bullet *pBullet = nil;
    for (unsigned int idx = 0; idx < bulletCount; ++idx)
    {
        pBullet = (Bullet *)[[self pBulletArray] objectAtIndex:idx];
        if ([pBullet bulletState] == eBulletState_active)
        {
//            pBullet->scheduleUpdate();
        }
    }
    
    unsigned int gadgetCount = [[self pGadgetArray] count];
    Gadget *pGadget = nil;
    for (unsigned int idx = 0; idx < gadgetCount; ++idx)
    {
        pGadget = (Gadget *)[[self pGadgetArray] objectAtIndex:idx];
//        pGadget->scheduleUpdate();
    }
    
//    this->scheduleUpdate();
}


// -----------------------------------------------------------------

@end





