//
//  MainMenu.h
//  Super Mario
//
//  Created by 周新哲 on 2018/1/3.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface MainMenu : CCScene

@property CCButton* pStartGame;
@property CCButton* pQuit;
@property CCButton* pAbout;
@property CCButton* pSetting;

- (instancetype)init;

-(void) menuCallBackForStartGame;
-(void) menuCallBackForAbout;
-(void) menuQuit;
-(void) menuSetting;


@end



