//
//  AnimationManager.m
//  Super Mario
//
//  Created by Mr.Right on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import "AnimationManager.h"
#import "OALSimpleAudio.h"
#import "CCTextureCache.h"
#import "CCAnimationCache.h"

@implementation AnimationManager
static AnimationManager *aniMngInstance = nil;
+(AnimationManager*)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        aniMngInstance = [[self alloc]init];
    });
    return aniMngInstance;
}
- (CCAnimation*)createAnimationByAnimationType:(enum AnimationType)key{
    NSMutableArray* pArray = [NSMutableArray array];

    CCSpriteFrame *frame = nil;
    CCTexture *pTexture;
    CCAnimation *pAnimation = nil;
    
    switch (key)
    {
        case eAniRight:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"walkRight.png"];
            for (int i = 0; i < 10; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(18 * i, 0, 18, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniLeft:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"walkLeft.png"];
            for (int i = 9; i >= 0; --i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(18 * i, 0, 18, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniLeftSmall:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"smallWalkLeft.png"];
            for (int i = 9; i >= 0; --i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(14 * i, 0, 14, 16) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniRightSmall:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"smallWalkRight.png"];
            for (int i = 0; i < 10; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(14 * i, 0, 14, 16) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniLeftFire:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"WalkLeft_fire.png"];
            for (int i = 9; i >= 0; --i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(18 * i, 0, 18, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniRightFire:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"WalkRight_fire.png"];
            for (int i = 0; i < 10; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(18 * i, 0, 18, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniBlinkCoin:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"coinani.png"];
            for (int i = 0; i < 4; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(8 * i, 0, 8, 14) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniMushroom:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"Mushroom0.png"];
            for (int i = 0; i < 2; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(16 * i, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.3f];
            break;
        }
        case eAniflower:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"flower0.png"];
            for (int i = 0; i < 2; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(16 * i, 0, 16, 24) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.3f];
            break;
        }
        case eAniTortoiseLeft:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"tortoise0.png"];
            for (int i = 2; i < 4; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(18 * i, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.3f];
            break;
        }
        case eAniTortoiseRight:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"tortoise0.png"];
            for (int i = 4; i < 6; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(18 * i, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.3f];
            break;
        }
        case eAniTortoiseFly:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"tortoise0.png"];
            for (int i = 0; i < 2; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(18 * i, 0, 18, 24) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.3f];
            break;
        }
        case eAniRotatedFireBall:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"fireRight.png"];
            for (int i = 0; i < 8; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(10 * i, 3, 10, 10) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.01f];
            break;
        }
        case eAniBoomedFireBall:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"fireRight.png"];
            
            frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(80, 3, 10, 10) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];

            frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(90, 0, 14, 16) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];

            frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(105, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.05f];
            break;
        }
        case eAniFireActionR:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"fireActionR.png"];
            for (int i = 0; i < 6; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(25 * i, 0, 25, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniArrowActionR:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"arrowActionR.png"];
            for (int i = 0; i < 6; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(25 * i, 0, 25, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniFireActionL:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"fireActionL.png"];
            for (int i = 5; i >= 0; --i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(25 * i, 0, 25, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniArrowActionL:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"arrowActionL.png"];
            for (int i = 5; i >= 0; --i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(25 * i, 0, 25, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniFlyFishR:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"flyFishRight.png"];

            frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(16 * 4, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];

            frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(16 * 5, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.05f];
            break;
        }
        case eAniFlyFishL:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"flyFishLeft.png"];

            frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(16 * 4, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];

            frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(16 * 5, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.05f];
            break;
        }
        case eAniArrowBroken:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"arrowBroken.png"];
            for (int i = 0; i < 3; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(16 * i, 0, 16, 16) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.05f];
            break;
        }
        case eAniSmallDie:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"small_die.png"];
            for (int i = 0; i < 7; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(16 * i, 0, 16, 18) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
                [pArray addObject:frame];
            }
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.1f];
            break;
        }
        case eAniNormalDie:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"normal_die.png"];
            for (int i = 0; i < 7; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(24 * i, 0, 24, 34) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
                [pArray addObject:frame];
            }
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.1f];
            break;
        }
        case eAniFireDie:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"fire_die.png"];
            for (int i = 0; i < 7; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(24 * i, 0, 24, 34) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
                [pArray addObject:frame];
            }
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.1f];
            break;
        }
        case eAniBossMoveLeft:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"boss.png"];
            for (int i = 3; i >=0; --i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(32 * i, 0, 32, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.2f];
            break;
        }
        case eAniBossMoveRight:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"boss.png"];
            for (int i = 4; i < 8; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(32 * i, 0, 32, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.2f];
            break;
        }
        case eAniBossFireLeft:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"bossBullet.png"];
            for (int i = 0; i < 2; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(24 * i, 0, 24, 8) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.1f];
            break;
        }
        case eAniBossFireRight:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"bossBullet.png"];
            for (int i = 3; i >= 2; --i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(24 * i, 0, 24, 8) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.1f];
            break;
        }
        case eAniBatteryBoom:
        {
            frame = [CCSpriteFrame frameWithTextureFilename:@"batteryBoom1.png" rectInPixels:CGRectMake(0, 0, 32, 27) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];
            
            frame = [CCSpriteFrame frameWithTextureFilename:@"batteryBoom2.png" rectInPixels:CGRectMake(0, 0, 32, 18) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];
            
            frame = [CCSpriteFrame frameWithTextureFilename:@"batteryBoom3.png" rectInPixels:CGRectMake(0, 0, 32, 20) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.1f];
            break;
        }
        case eAniLighting:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"lighting.png"];
            
            frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(0, 0, 16, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];
            
            frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(16, 0, 16, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
            [pArray addObject:frame];
            
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.1f];
            break;
        }
        case eAniArrowLeft:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"allow_walkLeft.png"];
            for (int i = 9; i >= 0; --i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(18 * i, 0, 18, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniArrowRight:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"allow_walkRight.png"];
            for (int i = 0; i < 10; ++i)
            {
                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(18 * i, 0, 18, 32) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.02f];
            break;
        }
        case eAniArrowDie:
        {
            pTexture = [[CCTextureCache sharedTextureCache] addImage:@"arrow_die.png"];
            for (int i = 0; i < 7; ++i)
            {

                frame = [CCSpriteFrame frameWithTexture:pTexture rectInPixels:CGRectMake(24 * i, 0, 24, 34) rotated:NO offset:ccp(0, 0) originalSize:pTexture.contentSize];
                [pArray addObject:frame];
                [pArray addObject:frame];
            }
            pAnimation = [CCAnimation animationWithSpriteFrames:(NSArray*)[pArray copy] delay:0.1f];
            break;
        }
        default:
            break;
    }
    
//    pArray->release();
    
    return pAnimation;
}
- (void)initAnimationMap{
    [self preLoadEffectAndMusic];
    
    [self setSelectLevel];
    
    [self setMusicSwitch];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniRight] name:[NSString stringWithFormat:@"%d", eAniRight]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniLeft] name:[NSString stringWithFormat:@"%d", eAniLeft]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniLeftSmall] name:[NSString stringWithFormat:@"%d", eAniLeftSmall]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniRightSmall] name:[NSString stringWithFormat:@"%d", eAniRightSmall]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniBlinkCoin] name:[NSString stringWithFormat:@"%d", eAniBlinkCoin]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniMushroom] name:[NSString stringWithFormat:@"%d", eAniMushroom]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniflower] name:[NSString stringWithFormat:@"%d", eAniflower]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniTortoiseLeft] name:[NSString stringWithFormat:@"%d", eAniTortoiseLeft]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniTortoiseRight] name:[NSString stringWithFormat:@"%d", eAniTortoiseRight]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniTortoiseFly] name:[NSString stringWithFormat:@"%d", eAniTortoiseFly]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniRightFire] name:[NSString stringWithFormat:@"%d", eAniRightFire]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniLeftFire] name:[NSString stringWithFormat:@"%d", eAniLeftFire]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniRotatedFireBall] name:[NSString stringWithFormat:@"%d", eAniRotatedFireBall]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniBoomedFireBall] name:[NSString stringWithFormat:@"%d", eAniBoomedFireBall]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniFireActionR] name:[NSString stringWithFormat:@"%d", eAniFireActionR]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniFireActionL] name:[NSString stringWithFormat:@"%d", eAniFireActionL]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniFlyFishR] name:[NSString stringWithFormat:@"%d", eAniFlyFishR]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniFlyFishL] name:[NSString stringWithFormat:@"%d", eAniFlyFishL]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniArrowBroken] name:[NSString stringWithFormat:@"%d", eAniArrowBroken]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniSmallDie] name:[NSString stringWithFormat:@"%d", eAniSmallDie]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniNormalDie] name:[NSString stringWithFormat:@"%d", eAniNormalDie]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniFireDie] name:[NSString stringWithFormat:@"%d", eAniFireDie]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniBossMoveLeft] name:[NSString stringWithFormat:@"%d", eAniBossMoveLeft]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniBossMoveRight] name:[NSString stringWithFormat:@"%d", eAniBossMoveRight]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniBossFireLeft] name:[NSString stringWithFormat:@"%d", eAniBossFireLeft]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniBossFireRight] name:[NSString stringWithFormat:@"%d", eAniBossFireRight]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniBatteryBoom] name:[NSString stringWithFormat:@"%d", eAniBatteryBoom]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniLighting] name:[NSString stringWithFormat:@"%d", eAniLighting]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniArrowLeft] name:[NSString stringWithFormat:@"%d", eAniArrowLeft]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniArrowRight] name:[NSString stringWithFormat:@"%d", eAniArrowRight]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniArrowDie] name:[NSString stringWithFormat:@"%d", eAniArrowDie]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniArrowActionL] name:[NSString stringWithFormat:@"%d", eAniArrowActionL]];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:[self createAnimationByAnimationType:eAniArrowActionR] name:[NSString stringWithFormat:@"%d", eAniArrowActionR]];
}
- (void)preLoadEffectAndMusic{
    [[OALSimpleAudio sharedInstance] preloadBg:@"OnLand.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"DingChuMoGuHuoHua.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"AddLife.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"EatMushroomOrFlower.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"SuoXiao.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"BossDiaoLuoQiaoXia.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"BossDie.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"BossHuoQiu.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"CaiSiGuaiWu.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"DiaoRuXianJingSi.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"DingPoZhuan.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"DingYingZhuanKuai.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"EatCoin.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"GameOver.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"HuoQiuDaDaoGuaiWu.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"Jump.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"QiZiLuoXia.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"YuDaoGuaiWuSi.ogg"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"RengHuoQiu.ogg"];
}
- (CCAnimation*)getAnimation:(enum AnimationType)key{

    NSString *str = [NSString stringWithFormat:@"%d", key];
    return [[CCAnimationCache sharedAnimationCache] animationByName:str];
}
- (CCActionAnimate*)createAnimateWithString:(NSString*)key{
    CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:key];
    if (anim)
    {
        return [CCActionAnimate actionWithAnimation:anim];
    }
    return nil;
}
- (CCActionAnimate*)createAnimateWithType:(enum AnimationType)key{
    CCAnimation *anim = [self getAnimation:key];
    if (anim)
    {
        return [CCActionAnimate actionWithAnimation:anim];
    }
    return nil;
}
- (void)setSelectLevel{
    NSString *str = nil;
    
    for (int i = 2; i <= 8; ++i)
    {
        str= [str initWithString:[NSString stringWithFormat:@"Level%d", i]];
//        CCUserDefault::sharedUserDefault()->setStringForKey(str->m_sString.c_str(), "no");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:str forKey:@"no"];
    }
}
- (void)setMusicSwitch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Music" forKey:@"on"];
    [defaults setObject:@"SoundEffect" forKey:@"on"];
}

@end
