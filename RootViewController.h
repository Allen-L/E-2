//
//  RootViewController.h
//  compxLostFind
//
//  Created by Compx on 14-5-1.
//  Copyright (c) 2014年 compx.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NetUnity.h"
#import "BLEController.h"
#import "WGS84TOGCJ02.h"
#import "MapViewController.h"

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#import "MusicViewController.h"




@interface RootViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,MKMapViewDelegate,BLEControllerDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>
{
    CLLocationManager *locationMan;//用于定位
    MKMapView *mapMan;//用于定位
    CLLocationCoordinate2D  clcoordinate;
    BOOL locationEnable;
    UIAlertView *alertMapLocationEnable;
    
    UIImagePickerController *imagepickerCon;//相机
    UIImagePickerController *videopickerCon;//摄像
    UIImagePickerController * pickerPicLibrary;//相册
    NSTimer *videoTimer;//摄像计时器
    NSString *videoTimerStr;
    
    bool cameraIsOnHome;
    UIButton *flashBtn;// 闪关灯模式设置按钮
    UISlider *photoSlider;
    
    UIBarButtonItem *leftButtonCamera;//camera
    UIBarButtonItem *rightButtonCamera;
    UIBarButtonItem *leftButtonVideo;//video
    UIBarButtonItem *rightButtonVideo;
    
    //创建一个导航栏
    UINavigationBar *navigationBarGoVideo;
    //创建一个导航栏集合
    UINavigationItem *navigationItemGoVideo;
    
    //风火轮
    UIActivityIndicatorView *activityIV;
    
    // 蓝牙
    BLEController *blecon;
    
    //报警计时器
    NSTimer *alermTimer;
    
    //找手机的定时器
    NSTimer *findIphoneTimer;
    
    //设置页面
    SetViewController *setVC;
    
    //判断是不是第一次打开
    BOOL firstOpen;
    
    
    //拍照
    UIButton *cameraButton;
    UIButton *buttonCam;
    //录像按钮
    UIButton *videoButton;
    //
    AVAudioPlayer* _audioPlayer;
    
    //alertView是否在显示
    BOOL alertShowIsOn;
    
    //地图定位闪图标定时器
    NSTimer *changeLovcationTimer;
    //摄像时闪图标定时器
    NSTimer *changeVideoImageTimer;
    //报警计时器
    NSTimer *alermCounteTimer;
    //mapView
    MapViewController *mapVC;
    
    
    UIImageView *batteryStateImageView;//电池电量图标
    UIImageView *connectStateImageView;//蓝牙连接标志
    
    
    //测试延时3秒给外设发送
    NSTimer *countConnectTimer;
    NSTimer *repetSendRssiTimer;
    
    //外设寻物时暂停发送RSSI的定时器
    NSTimer *findKeyTouchTimer;
    
    //设置页面开关值改变触发的方法
    NSTimer *setVCSwitchValuedChangeTimer;
    
    //断开连接重连后，3S之后把设置页面的开关状态值发送给外设
    NSTimer *sendSetVCSwitchStateTimer;
    
    //监听电话
    CTCallCenter *callCenter;
    BOOL isRCcallComing;
    
    
    //监听主题的改变
    int themIndex;
    
    //
    MusicViewController *musicVC;
    //音乐播放页面是否已经打开
    BOOL isMusicOpen;
}
@property(retain,nonatomic)IBOutlet UIButton *setBtn;


@property(retain,nonatomic)IBOutlet UIButton *findBtn;
@property(retain,nonatomic)IBOutlet UIButton *mapLocationBtn;
@property(retain,nonatomic)IBOutlet UIButton *cameraBtn;
@property(retain,nonatomic)IBOutlet UIButton *videoBtn;
@property(retain,nonatomic)IBOutlet UIButton *photoalbumBtn;
@property(retain,nonatomic)UIImageView *batteryStateImageView;//电池电量图标
@property(retain,nonatomic)UIImageView *connectStateImageView;//蓝牙连接标志

@property(retain,nonatomic)IBOutlet UIImageView *backgroundImageView;
@property(retain,nonatomic)IBOutlet UIImageView *setImageView;//设置按钮的图片


@property(retain,nonatomic)CTCallCenter *callCenter;

//用于报警
@property(assign)BOOL distenceAlerm;
@property(assign)BOOL findAlerm;
@property(assign)BOOL lostConAlerm;
@end
