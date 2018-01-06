//
//  Global.m
//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@implementation Global

static Global *globalInstance = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentLevel = 1;
        
        self.totalLevels = 8;
        
        self.currentHeroType = eBody_Small;
        
        self.currentBulletType = eBullet_common;
        
        self.lifeNum = 3;
    }
    return self;
}

+(Global*)getGlobalInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        globalInstance = [[self alloc]init];
    });
    return globalInstance;
}


-(void)currentLevelPlusOne{
    self.currentLevel++;
}

-(void)reSetLevel{
    self.currentLevel = 1;
}

-(void)lifeNumPlusOne{
    self.lifeNum++;
}

-(void)lifeNumCutOne{
    self.lifeNum--;
}

@end
