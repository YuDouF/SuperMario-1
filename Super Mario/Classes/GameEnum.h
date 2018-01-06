//
//  Enum.h
//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

enum marioDirection
{
    eLeft,
    eRight,
    eJumpLeft,
    eJumpRight,
    eNormalRight,
    eNormalLeft,
    eFireTheHole
};

enum GameElement
{
    eElement_GameLayer,
    eElement_GameMap
};

enum BodyType
{
    eBody_Normal,
    eBody_Small,
    eBody_Fireable
};

enum AnimationType
{
    eAniLeft,
    eAniRight,
    eAniLeftSmall,
    eAniRightSmall,
    eAniLeftFire,
    eAniRightFire,
    eAniBlinkCoin,
    eAniMushroom,
    eAniflower,
    eAniTortoiseLeft,
    eAniTortoiseRight,
    eAniTortoiseFly,
    eAniRotatedFireBall,
    eAniBoomedFireBall,
    eAniFireActionR,
    eAniFireActionL,
    eAniFlyFishR,
    eAniFlyFishL,
    eAniArrowBroken,
    eAniSmallDie,
    eAniNormalDie,
    eAniFireDie,
    eAniBossMoveLeft,
    eAniBossMoveRight,
    eAniBossFireLeft,
    eAniBossFireRight,
    eAniBatteryBoom,
    eAniLighting,
    eAniArrowLeft,
    eAniArrowRight,
    eAniArrowDie,
    eAniArrowActionL,
    eAniArrowActionR
};

enum ItemType
{
    eBlinkCoin
};

enum TileType
{
    eTile_Land,
    eTile_Block,
    eTile_Pipe,
    eTile_Trap,
    eTile_Coin,
    eTile_NoneH,
    eTile_NoneV,
    eTile_Flagpole
};

enum EnemyType
{
    eEnemy_mushroom,
    eEnemy_flower,
    eEnemy_tortoise,
    eEnemy_tortoiseRound,
    eEnemy_tortoiseFly,
    eEnemy_fireString,
    eEnemy_flyFish,
    eEnemy_Boss,
    eEnemy_BossFire,
    eEnemy_AddMushroom,
    eEnemy_Battery,
    eEnemy_BatteryBullet,
    eEnemy_DarkCloud,
    eEnemy_Lighting
};

enum EnemyState
{
    eEnemyState_active,
    eEnemyState_nonactive,
    eEnemyState_over
};

enum EnemyVSHero
{
    eVS_enemyKilled,
    eVS_heroKilled,
    eVS_nonKilled
};

enum BulletType
{
    eBullet_common,
    eBullet_arrow
};

enum BulletState
{
    eBulletState_active,
    eBulletState_nonactive
};

enum GadgetType
{
    eGadget_LadderUD,
    eGadget_LadderLR
    
};

enum GadgetState
{
    eGadgetState_active,
    eGadgetState_nonactive,
    eGadgetState_over
};

enum ToMainMenuFor
{
    efor_PassFailure,
    efor_PassSuccess,
    efor_Non,
    efor_StartGame,
    efor_GameOver,
    efor_PassAll
};

