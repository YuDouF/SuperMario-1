//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hero.h"
//#import "AnimationManager.h"
#import "Global.h"
#import "OALSimpleAudio.h"

@implementation Hero

static Hero* heroInstance= nil;

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.mainBody = nil;
        self.mainTemp = nil;
        self.jumpLeft = nil;
        self.jumpRight = nil;
        self.lifeOverSmall = nil;
        self.lifeOverNormal = nil;
        self.lifeOverFire = nil;
        self.normalLeft = nil;
        self.normalRight = nil;
        self.smallJumpLeft = nil;
        self.smallJumpRight = nil;
        self.smallLeft = nil;
        self.smallRight = nil;
        self.pLabelUp = nil;
        self.norBodySize = CGSizeMake(18, 32);
        self.smallSize = CGSizeMake(14, 16);
        self.currentSize = self.smallSize;
        self.state = eNormalRight;
        self.statePre = eNormalRight;
        self.face = eRight;
        self.isFlying = NO;
        self.bodyType = eBody_Small;
        
        CCTexture *pTexture = [CCTexture textureWithFile:@"walkLeft.png"];
        self.normalLeft = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(18*9, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
         self.jumpLeft = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(180, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
        pTexture = [CCTexture textureWithFile:@"WalkLeft_fire.png"];
        self.normalLeftFire = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(18*9, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
        self.jumpLeftFire = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(180, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
        pTexture = [CCTexture textureWithFile:@"walkRight.png"];
        self.normalRight = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(0, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
        self.jumpRight = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(180, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
        pTexture = [CCTexture textureWithFile:@"WalkRight_fire.png"];
        self.normalRightFire = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(0, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
        self.jumpRightFire = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(180, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
        
        pTexture = [CCTexture textureWithFile:@"smallWalkLeft.png"];
        self.smallLeft = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(14*9, 0, 14, 16) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(14, 16)];
        self.smallJumpLeft = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(140, 0, 14, 16) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(14, 16)];
        pTexture = [CCTexture textureWithFile:@"smallWalkRight.png"];
        self.smallRight = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(0, 0, 14, 16) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(14, 16)];
        self.smallJumpRight = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(140, 0, 14, 16) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(14, 16)];
        
        pTexture = [CCTexture textureWithFile:@"normal_die.png"];
        self.lifeOverNormal = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(24, 0, 24, 34) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(24, 34)];
        pTexture = [CCTexture textureWithFile:@"small_die.png"];
        self.lifeOverSmall = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(16, 0, 16, 18) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(16, 18)];
        pTexture = [CCTexture textureWithFile:@"fire_die.png"];
        self.lifeOverFire = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(24, 0, 24, 34) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(24, 34)];
        
        pTexture = [CCTexture textureWithFile:@"allow_walkLeft.png"];
        self.normalLeftArrow = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(0, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
        self.jumpLeftArrow = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(180, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
        pTexture = [CCTexture textureWithFile:@"allow_walkRight.png"];
        self.normalRightArrow = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(0, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
        self.jumpRightArrow = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(180, 0, 18, 32) rotated:NO offset:CGPointMake(0, 0) originalSize:CGSizeMake(18, 32)];
        
        self.isDied = false;
        self.isSafeTime = false;
        self.bulletable = false;
        self.gadgetable = false;
        self.currentBulletType = eBullet_common;
    }
    return self;
}

+(Hero*)getHeroInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
         heroInstance= [[self alloc]init];
    });
    return heroInstance;
}

-(bool)heroInit{
    [self setContentSize:self.smallSize];
    CCTexture *pTexture = [CCTexture textureWithFile:@"smallWalkRight.png"];
    self.mainBody = [CCSprite spriteWithTexture:pTexture rect:CGRectMake(0,0,14,16)];
    [self.mainBody setAnchorPoint:ccp(0, 0)];
    [self addChild:self.mainBody];
    self.state = eNormalRight;
    return true;
}

-(enum BodyType)bodyType{
    return self.bodyType;
}
-(void)setBodyType:(enum BodyType)bodyType{
    self.bodyType = bodyType;
    switch (bodyType)
    {
        case eBody_Normal:
            self.currentSize = self.norBodySize;
            [self.mainBody setSpriteFrame:self.normalRight];
            break;
        case eBody_Small:
            self.currentSize = self.smallSize;
            [self.mainBody setSpriteFrame:self.smallRight];
            break;
        case eBody_Fireable:
        {
            bodyType = eBody_Normal;
            self.currentSize = self.norBodySize;
            self.bulletable = true;
            switch ([[Global getGlobalInstance] currentBulletType])
            {
                case eBullet_arrow:
                    [self.mainBody setSpriteFrame:self.normalRightArrow];
                    break;
                case eBullet_common:
                    [self.mainBody setSpriteFrame:self.normalRightFire];
                    break;
            }
            break;
        }
        default:
            break;
    }
    [self setContentSize:self.currentSize];
}

-(void)reSetForSuccess{
    switch (self.bodyType)
    {
        case eBody_Small:
            [self.mainBody setSpriteFrame:self.smallRight];
            break;
        case eBody_Normal:
            if (self.bulletable)
            {
                switch ([[Global getGlobalInstance] currentBulletType])
                {
                    case eBullet_common:
                        [self.mainBody setSpriteFrame:self.normalRightFire];
                        break;
                    case eBullet_arrow:
                        [self.mainBody setSpriteFrame:self.normalRightArrow];
                        break;
                }
            }
            else
            {
                [self.mainBody setSpriteFrame:self.normalRight];
            }
            break;
        default:
            break;
    }
}

-(void)setHeroDie:(bool) die{
    self.isDied = die;
    if(die){
        [Global getGlobalInstance].currentHeroType = eBody_Small;
        [[Global getGlobalInstance] lifeNumCutOne];
    }
}

/*设置英雄状态*/
-(void)setHeroState:(enum marioDirection)state{
    if (self.isDied || self.state == state){
        return;
    }
    self.statePre = self.state;
    self.state = state;
    
    [self.mainBody stopAllActions];
    switch (state)
    {
        case eFireTheHole:
            break;
        case eNormalRight:
        {
            if (self.bodyType == eBody_Normal)
            {
                if (self.bulletable)
                {
                    switch ([[Global getGlobalInstance] currentBulletType])
                    {
                        case eBullet_common:
                            [self.mainBody setSpriteFrame:self.normalRightFire];
                            break;
                        case eBullet_arrow:
                            [self.mainBody setSpriteFrame:self.normalRightArrow];
                            break;
                    }
                }
                else
                {
                    [self.mainBody setSpriteFrame:self.normalRight];
                }
            }
            else
            {
                [self.mainBody setSpriteFrame:self.smallRight];
            }
            self.face = eRight;
            break;
        }
        case eNormalLeft:
        {
            if (self.bodyType == eBody_Normal)
            {
                if (self.bulletable)
                {
                    switch ([[Global getGlobalInstance] currentBulletType])
                    {
                        case eBullet_common:
                            [self.mainBody setSpriteFrame:self.normalLeftFire];
                            break;
                        case eBullet_arrow:
                            [self.mainBody setSpriteFrame:self.normalLeftArrow];
                            break;
                    }
                }
                else
                {
                    [self.mainBody setSpriteFrame:self.normalLeft];
                }
            }
            else
            {
                [self.mainBody setSpriteFrame:self.smallLeft];
            }
            self.face = eLeft;
            break;
        }
        case eRight:
        {
            if (!self.isFlying)
            {
                if (self.bodyType == eBody_Normal)
                {
                    if (self.bulletable)
                    {
                        switch ([[Global getGlobalInstance] currentBulletType])
                        {
                            case eBullet_common:
                                //[self.mainBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimate:eAniRightFire]];
                                break;
                            case eBullet_arrow:
                                //[self.mainBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimate:eAniArrowRight]];
                                break;
                        }
                    }
                    else
                    {
                        //[self.mainBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimate:eAniRight]];
                    }
                }
                else
                {
                    //[self.mainBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimate:eAniRightSmall]];
                }
            }
            self.face = eRight;
            break;
        }
        case eLeft:
        {
            if (!self.isFlying)
            {
                if (self.bodyType == eBody_Normal)
                {
                    if (self.bulletable)
                    {
                        switch ([[Global getGlobalInstance] currentBulletType])
                        {
                            case eBullet_common:
                                //[self.mainBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimate:eAniLeftFire]];
                                break;
                            case eBullet_arrow:
                                //[self.mainBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimate:eAniArrowLeft]];
                                break;
                        }
                    }
                    else
                    {
                        //[self.mainBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimate:eAniLeft]];
                    }
                }
                else
                {
                    //[self.mainBody runAction:[CCActionRepeatForever actionWithAction:[sAnimationMgr createAnimate:eAniLeftSmall]];
                }
                
            }
            self.face = eLeft;
            break;
        }
        case eJumpLeft:
        {
            if (self.bodyType == eBody_Normal)
            {
                if (self.bulletable)
                {
                    switch ([[Global getGlobalInstance] currentBulletType])
                    {
                        case eBullet_common:
                            [self.mainBody setSpriteFrame:self.jumpLeftFire];
                            break;
                        case eBullet_arrow:
                            [self.mainBody setSpriteFrame:self.jumpLeftArrow];
                            break;
                    }
                }
                else
                {
                    [self.mainBody setSpriteFrame:self.jumpLeft];
                }
            }
            else
            {
                [self.mainBody setSpriteFrame:self.smallJumpLeft];
            }
            self.face = eLeft;
            break;
        }
        case eJumpRight:
        {
            if (self.bodyType == eBody_Normal)
            {
                if (self.bulletable)
                {
                    switch ([[Global getGlobalInstance] currentBulletType])
                    {
                        case eBullet_common:
                            [self.mainBody setSpriteFrame:self.jumpRightFire];
                            break;
                        case eBullet_arrow:
                            [self.mainBody setSpriteFrame:self.jumpRightArrow];
                            break;
                    }
                }
                else
                {
                    [self.mainBody setSpriteFrame:self.jumpRight];
                }
            }
            else
            {
                [self.mainBody setSpriteFrame:self.smallJumpRight];
            }
            self.face = eRight;
            break;
        }
        default:
            break;
    }
}

/*陷阱死亡*/
-(void)dieForTrap{
    [self.mainBody stopAllActions];
    
    switch (self.bodyType)
    {
        case eBody_Small:
            [self.mainBody setSpriteFrame:self.lifeOverSmall];
            //[self.mainBody runAction:[sAnimationMgr createAnimate:eAniSmallDie]];
            break;
        case eBody_Normal:
            if (self.bulletable)
            {
                switch ([[Global getGlobalInstance] currentBulletType])
                {
                    case eBullet_common:
                        [self.mainBody setSpriteFrame:self.lifeOverFire];
                        //[self.mainBody runAction:[sAnimationMgr createAnimate:eAniFireDie]];
                        break;
                    case eBullet_arrow:
                        self.lifeOverFire =[CCSpriteFrame frameWithTextureFilename:@"arrow_die.png" rectInPixels:CGRectMake(24, 0, 24, 32) rotated:NO offset:ccp(0, 0) originalSize:CGSizeMake(24, 32)];
                        [self.mainBody setSpriteFrame:self.lifeOverFire];
                        //[self.mainBody runAction:[sAnimationMgr createAnimate:eAniArrowDie]];
                }
            }
            else
            {
                [self.mainBody setSpriteFrame:self.lifeOverNormal];
                //[self.mainBody runAction:[sAnimationMgr createAnimate:eAniNormalDie]];
            }
            break;
        default:
            break;
    }
    
    CCActionInterval *pMoveUp = [CCActionMoveBy actionWithDuration:0.6f position:ccp(0, 32)];
    CCActionInterval *pMoveDown = [CCActionMoveBy actionWithDuration:0.6f position:ccp(0, -32)];
    CCActionInterval *pDeley =[CCActionDelay actionWithDuration:0.2f];
    
    [self runAction:[CCActionSequence actions:pMoveUp, pDeley, pMoveDown,[CCActionCallFunc actionWithTarget:self selector:@selector(reSetNonVisible)], nil]];
}

-(void)reSetNonVisible{
    [self.mainBody stopAllActions];
    [self setVisible:NO];
}

-(void)fireAction{
    CCActionInterval *pAction = NULL;
    [self setHeroState:eFireTheHole];
    switch (self.face)
    {
        case eRight:
        {
            switch ([[Global getGlobalInstance] currentBulletType])
            {
                case eBullet_common:
                    //pAction = [sAnimationMgr createAnimate:eAniFireActionR];
                    break;
                case eBullet_arrow:
                    //pAction = [sAnimationMgr createAnimate:eAniArrowActionR];
                    break;
            }
            break;
        }
        case eLeft:
        {
            switch ([[Global getGlobalInstance] currentBulletType])
            {
                case eBullet_common:
                    //pAction = [sAnimationMgr createAnimate:eAniFireActionL];
                    break;
                case eBullet_arrow:
                    //pAction = [sAnimationMgr createAnimate:eAniArrowActionL];
                    break;
            }
            break;
        }
        default:
            break;
    }
    [self.mainBody runAction:[CCActionSequence actions:pAction,[CCActionCallFunc actionWithTarget:self selector:@selector(reSetStateForFired)], nil]];
}
-(void)reSetStateForFired{
    [self setHeroState:self.statePre];
}

-(void)changeForGotAddLifeMushroom{
    [[OALSimpleAudio sharedInstance] playEffect:@"AddLife.ogg"];
    [[Global getGlobalInstance] lifeNumPlusOne];
    self.pLabelUp = [CCLabelTTF labelWithString:@"UP!" fontName:@"Arial" fontSize:20];
    [self.pLabelUp setPosition:CGPointZero];
    [self addChild:self.pLabelUp];
    CCActionJumpBy *pJump = [CCActionJumpBy actionWithDuration:0.5f position:ccp(0, self.contentSize.height/2) height:self.contentSize.height jumps:1];
    [self.pLabelUp runAction:[CCActionSequence actions:pJump,[CCActionCallFunc actionWithTarget:self selector:@selector(clearLabelUp)], nil]];
}

-(void)clearLabelUp{
    [self.pLabelUp removeFromParentAndCleanup:YES];
    self.pLabelUp = nil;
}

-(void)changeForGotMushroom{
    [[OALSimpleAudio sharedInstance] playEffect:@"EatMushroomOrFlower.ogg"];
    switch (self.bodyType)
    {
        case eBody_Small:
        {
            [Global getGlobalInstance].currentHeroType = eBody_Normal;
            [self setHeroTypeForNormal];
            CCActionInterval *pBlink = [CCActionBlink actionWithDuration:1 blinks:5];
            [self runAction:pBlink];
            break;
            
        }
        case eBody_Normal:
        {
            self.bulletable = true;
            [Global getGlobalInstance].currentHeroType = eBody_Fireable;
            if (!self.bulletable)
            {
                switch (self.face)
                {
                    case eRight:
                        [self.mainBody setSpriteFrame:self.normalRightFire];
                        break;
                    case eLeft:
                        [self.mainBody setSpriteFrame:self.normalLeftFire];
                        break;
                    default:
                        break;
                }
            }
            break;
        }
        default:
            break;
    }
}

-(void)changeForGotEnemy{
    self.isSafeTime = true;
    CCActionInterval *pDelay = [CCActionDelay actionWithDuration:3.0f];
    [self runAction:[CCActionSequence actions:pDelay,[CCActionCallFunc actionWithTarget:self selector:@selector(reSetSafeTime)], nil]];
    
    switch (self.bodyType)
    {
        case eBody_Normal:
        case eBody_Fireable:
        {
            [[OALSimpleAudio sharedInstance] playEffect:@"SuoXiao.ogg"];
            [Global getGlobalInstance].currentHeroType = eBody_Small;
            [self setHeroTypeForSmall];
            CCActionInterval *pBlink = [CCActionBlink actionWithDuration:3.0f blinks:15];
            [self runAction:pBlink];
            break;
        }
        case eBody_Small:
        {
            [[OALSimpleAudio sharedInstance] playEffect:@"YuDaoGuaiWuSi.ogg"];
            [self.mainBody stopAllActions];
            [self.mainBody setSpriteFrame:self.lifeOverSmall];
            [self setHeroDie:YES];
            break;
        }
        default:
            break;
    }
}

-(void)setHeroTypeForNormal{
    [self setBodyType:eBody_Normal];
    switch (self.face)
    {
        case eRight:
            [self.mainBody setSpriteFrame:self.normalRight];
            break;
        case eLeft:
            [self.mainBody setSpriteFrame:self.normalLeft];
            break;
        default:
            break;
    }
}

-(void)setHeroTypeForSmall{
    [self setBodyType:eBody_Small];
    self.bulletable = false;
    switch (self.face)
    {
        case eRight:
            [self.mainBody setSpriteFrame:self.smallRight];
            break;
        case eLeft:
            [self.mainBody setSpriteFrame:self.smallLeft];
            break;
        default:
            break;
    }
}

-(void)reSetSafeTime{
    self.isSafeTime = NO;
}

-(enum BulletType)currentBulletType{
    return self.currentBulletType;
}

-(void)setCurrentBulletType:(enum BulletType)currentBulletType{
    if (self.currentBulletType != currentBulletType)
    {
        self.currentBulletType = currentBulletType;
        switch (self.face)
        {
            case eRight:
            {
                switch (self.currentBulletType)
                {
                    case eBullet_common:
                        [self.mainBody setSpriteFrame:self.normalRightFire];
                        break;
                    case eBullet_arrow:
                        [self.mainBody setSpriteFrame:self.normalRightArrow];
                        break;
                }
                break;
            }
            case eLeft:
            {
                switch (currentBulletType)
                {
                    case eBullet_common:
                        [self.mainBody setSpriteFrame:self.normalLeftFire];
                        break;
                    case eBullet_arrow:
                        [self.mainBody setSpriteFrame:self.normalLeftArrow];
                        break;
                }
                break;
            }
            default:
                break;
        }
    }
}

@end

