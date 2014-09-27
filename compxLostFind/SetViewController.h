//
//  SetViewController.h
//  compxLostFind
//
//  Created by Compx on 14-5-2.
//  Copyright (c) 2014年 compx.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "BLEController.h"
#import "SevenSwitch.h"
#import "CustomSwitch.h"
#import <AVFoundation/AVFoundation.h>

#define notifictionStr @"SetViewCSwitchChangeValued"
#define notifictionVolume @"VolumesChanged"

//监听主题切换的通知
#define themChangeToDefault @"Default"
#define themChangeToOrange @"Orange"
#define themChangeToGreen @"Green"
#define themChangeToPurple @"Purple"



@interface SetViewController : UIViewController<CustomSwitchDelegate>
{
    BLEController *bleController;//蓝牙对象
    MapViewController *mapVC;
    UISwitch *linkLossSwitch;
//      CustomSwitch *_switchOne;
//      CustomSwitch *_switchTwo;
//      CustomSwitch *_switchThree;
//      CustomSwitch *_switchFour;
    AVAudioPlayer *audioPlayer;
    
    
    
    UIButton *defaultThemBtn;
    UIButton *orangeBtn;
    UIButton *greenBtn;
    UIButton *purpleBtn;
    
    //喇叭
    UIImageView *labaView;
    //音量滑条
    UISlider *sliderVolume;
    
}
/*
@property(retain,nonatomic)IBOutlet UISwitch *lostEnableSwitch;
@property(retain,nonatomic)IBOutlet UISwitch *rangeSwitch;
@property(retain,nonatomic)IBOutlet UISwitch *linkLossSwitch;
@property(retain,nonatomic)IBOutlet UIButton *findKeyFinderBtn;
@property(retain,nonatomic)IBOutlet UISwitch *mapLocationEnableSwitch;


@property(retain,nonatomic) SevenSwitch *lostEnableST;
@property(retain,nonatomic) SevenSwitch *rangeST;
@property(retain,nonatomic) SevenSwitch *linkLossST;
@property(retain,nonatomic) SevenSwitch *mapLocationEnableST;
*/

@property(retain,nonatomic)IBOutlet  CustomSwitch *_switchOne;
@property(retain,nonatomic)IBOutlet  CustomSwitch *_switchTwo;
@property(retain,nonatomic)IBOutlet  CustomSwitch *_switchThree;
@property(retain,nonatomic)IBOutlet  CustomSwitch *_switchFour;


@property(retain,nonatomic)IBOutlet UILabel *LossProofLab;
@property(retain,nonatomic)IBOutlet UILabel *RangeLab;
@property(retain,nonatomic)IBOutlet UILabel *OutOffRangeLab;
@property(retain,nonatomic)IBOutlet UILabel *LocatorLab;
@property(retain,nonatomic)IBOutlet UILabel *MapLocationLab;


@property(retain,nonatomic)IBOutlet UIButton *mapBtn;
@property(assign)bool mapLocationEnableSwitchState;


@property(retain,nonatomic)UISlider *sliderVolume;//音量滑条



//切换主题的按钮
//@property(retain,nonatomic)IBOutlet UIButton *defaultThemBtn;
//@property(retain,nonatomic)IBOutlet UIButton *orangeBtn;
//@property(retain,nonatomic)IBOutlet UIButton *greenBtn;
//@property(retain,nonatomic)IBOutlet UIButton *purpleBtn;


@property(retain,nonatomic) UIButton *defaultThemBtn;
@property(retain,nonatomic) UIButton *orangeBtn;
@property(retain,nonatomic) UIButton *greenBtn;
@property(retain,nonatomic) UIButton *purpleBtn;

-(void)lostEnableSwitchChangeState;
-(void)rangeSwitchChangeState;
-(void)linkLostSwitchChangeState;


@end
