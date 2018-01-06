//
//  Global.h
//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameEnum.h"

@interface Global : CCNode

- (instancetype)init;

@property int currentLevel;
@property int totalLevels;
@property enum BodyType currentHeroType;
@property enum BulletType currentBulletType;
@property int lifeNum;

-(void)reSetLevel;
-(void)currentLevelPlusOne;
-(void)lifeNumPlusOne;
-(void)lifeNumCutOne;

+(Global*) getGlobalInstance;

@end
