//
//  SelectMenu.h
//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface SelectMenu : CCScene


@property CGPoint m_touchPoint;
@property int m_nCurPage;
@property CCLabelTTF *m_pLevel;
@property CCButton *pNewGame;
@property CCScene *pScene;

- (instancetype)init;

-(void)adjustView:(float)offset;
-(void)menuBegin;
-(void)menuBack;

@end

    

