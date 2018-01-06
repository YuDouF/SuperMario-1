//
//  AnimationManager.h
//  Super Mario
//
//  Created by Mr.Right on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameEnum.h"

@interface AnimationManager : NSObject

+ (AnimationManager*)getInstance;
- (void)initAnimationMap;
- (void)preLoadEffectAndMusic;
- (CCAnimation*)getAnimation:(enum AnimationType)key;
- (CCActionAnimate*)createAnimateWithString:(NSString*)key;
- (CCActionAnimate*)createAnimateWithType:(enum AnimationType)key;
- (void)setSelectLevel;
- (void)setMusicSwitch;
@end
