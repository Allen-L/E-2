//
//  RootViewController.m
//  compxLostFind
//
//  Created by Compx on 14-5-1.
//  Copyright (c) 2014年 compx.com.cn. All rights reserved.
//

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define AlermTimer 2.0

#import "RootViewController.h"
#define delayTime 1.0

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize setBtn;
@synthesize mapLocationBtn;
@synthesize cameraBtn;
@synthesize videoBtn;
@synthesize photoalbumBtn;
@synthesize batteryStateImageView;
@synthesize connectStateImageView;
@synthesize findBtn;
@synthesize backgroundImageView;
@synthesize setImageView;
//电话检测
@synthesize callCenter;
//用于报警
@synthesize distenceAlerm;
@synthesize findAlerm;
@synthesize lostConAlerm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //实现单列，并且记得要实现委托对象
        blecon=[BLEController getInstance];
        blecon.delegate=self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    firstOpen=YES;
    themIndex=0;
    isMusicOpen=NO;
    
    ////////////////////////////////
    /////页面配置
    ///////////////////////////////
    if (iPhone5) {
        UIImageView *batteryBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, [UIScreen mainScreen].bounds.size.height-100, 50, 50)];
        batteryBackImageView.image=[UIImage imageNamed:@"灰圆心.png"];
        [self.view addSubview:batteryBackImageView];
        
        batteryStateImageView=[[UIImageView alloc]initWithFrame:CGRectMake(9, 16, 32, 18)];
        batteryStateImageView.image=[UIImage imageNamed:@"电池灰.png"];
        [batteryBackImageView addSubview:batteryStateImageView];
        
        
        
        UIImageView *blueBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(180, [UIScreen mainScreen].bounds.size.height-100, 50, 50)];
        blueBackImageView.image=[UIImage imageNamed:@"灰圆心.png"];
        [self.view addSubview:blueBackImageView];
        
        connectStateImageView=[[UIImageView alloc]initWithFrame:CGRectMake(16, 9, 18, 32)];
        connectStateImageView.image=[UIImage imageNamed:@"蓝牙灰.png"];
        [blueBackImageView addSubview:connectStateImageView];
    }
    else{
        UIImageView *batteryBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, [UIScreen mainScreen].bounds.size.height-70, 50, 50)];
        batteryBackImageView.image=[UIImage imageNamed:@"灰圆心.png"];
        [self.view addSubview:batteryBackImageView];
        
        batteryStateImageView=[[UIImageView alloc]initWithFrame:CGRectMake(9, 16, 32, 18)];
        batteryStateImageView.image=[UIImage imageNamed:@"电池灰.png"];
        [batteryBackImageView addSubview:batteryStateImageView];
        
        
        
        UIImageView *blueBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(180, [UIScreen mainScreen].bounds.size.height-70, 50, 50)];
        blueBackImageView.image=[UIImage imageNamed:@"灰圆心.png"];
        [self.view addSubview:blueBackImageView];
        
        connectStateImageView=[[UIImageView alloc]initWithFrame:CGRectMake(16, 9, 18, 32)];
        connectStateImageView.image=[UIImage imageNamed:@"蓝牙灰.png"];
        [blueBackImageView addSubview:connectStateImageView];
        
    }
    
    
    //设置按钮的方法事件
    [setBtn addTarget:self action:@selector(goSetingView) forControlEvents:UIControlEventTouchUpInside];
    
    //寻物按钮的方法事件
    [findBtn addTarget:self action:@selector(findBtnTouchDown) forControlEvents:UIControlEventTouchUpInside];
    //地图定位的方法事件
    [mapLocationBtn addTarget:self action:@selector(locationIsExist) forControlEvents:UIControlEventTouchUpInside];
    //照相按钮的方法事件
    [cameraBtn addTarget:self action:@selector(gotoCamera) forControlEvents:UIControlEventTouchUpInside];
    //摄像按钮的方法事件
    [videoBtn addTarget:self action:@selector(goVideo) forControlEvents:UIControlEventTouchUpInside];
    //打开相册按钮的方法事件－》改成打开音乐
    [photoalbumBtn addTarget:self action:@selector(openMusic) forControlEvents:UIControlEventTouchUpInside];
    
    
    videoTimerStr = [NSString stringWithFormat:@"%02d:%02d:%02d",00,00,00];
    
    //修改电池电量为空
    [batteryStateImageView setImage:[UIImage imageNamed:@"电池灰.png"]];
    //修改蓝牙连接标志为未连接状态；
    [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙灰.png"]];
    
    locationEnable=YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(judeThelocationEanbleState:) name:@"mapLocationEnable" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SetVCSwitchChangeValued) name:notifictionStr object:nil];
    
    //监听手机的电话状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RCCallInComing) name:@"RCCallComing" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RCCallFinish) name:@"RCCallFinish" object:nil];
    
    
    //检测有电话打进来
    callCenter = [[CTCallCenter alloc] init];
    callCenter.callEventHandler = ^(CTCall* call)
    {
        if (call.callState == CTCallStateDisconnected)
        {
            //电话挂断
        
           [[NSNotificationCenter defaultCenter]postNotificationName:@"RCCallFinish" object:nil];
        }
        else if (call.callState == CTCallStateConnected)
        {
            //电话接通时
        }
        else if(call.callState == CTCallStateIncoming)
        {
            //有电话打进来
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RCCallComing" object:nil];
           
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            //主动打电话
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RCCallComing" object:nil];
        }
        else
        {
           // NSLog(@"None of the conditions");
        }
    };
    
    
    //监听音量的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setVCVolumeChanged:) name:notifictionVolume object:nil];
    
    //告诉应用程序开始接收远程控制事件,旨在控制多媒体应用程序提出的。
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //监听主题变化的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changThemToDefaultColor) name:themChangeToDefault object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeThemToOrange) name:themChangeToOrange object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeThemToGreen) name:themChangeToGreen object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeThemToPurple) name:themChangeToPurple object:nil];
    
    //监听音乐播放页面是否关闭的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNOtiCloseMusicVC) name:notiMusicVcClose object:nil];
    
    
    //查看用户之前保存的主题设置
    NSUserDefaults *defaultThem=[NSUserDefaults standardUserDefaults];
    NSString *them=[defaultThem stringForKey:@"e2Them"];
//    if ([them isEqualToString:@"default"]) {
//        
//    }
    if ([them isEqualToString:@"orange"]){
        backgroundImageView.image=[UIImage imageNamed:@"背景橙色.png"];
        setImageView.image=[UIImage imageNamed:@"设置橙色.png"];
        themIndex=1;
    }
    
    else if ([them isEqualToString:@"green"]){
        backgroundImageView.image=[UIImage imageNamed:@"背景绿色.png"];
        setImageView.image=[UIImage imageNamed:@"设置绿色.png"];
        themIndex=2;
    }
    else if ([them isEqualToString:@"purple"])
    {
        backgroundImageView.image=[UIImage imageNamed:@"背景紫色.png"];
        setImageView.image=[UIImage imageNamed:@"设置紫色.png"];
        themIndex=3;
    }
    else{
        backgroundImageView.image=[UIImage imageNamed:@"圆心蓝绿.png"];
        setImageView.image=[UIImage imageNamed:@"设置蓝绿.png"];
        themIndex=0;
    }
    
}


//手机是否打电话状态通知调用的方法
-(void)RCCallInComing
{
    isRCcallComing=TRUE;
    
    //判断当前的距离报警是否已经发生，如果有，则先关闭
    if ([alermTimer isValid]==TRUE) {
        [alermTimer invalidate];
        isAlerm=NO;
    }
    //判断当前的短线报警是否已经发生，如果有，则先关闭
    if ([findIphoneTimer isValid]==TRUE) {
        [findIphoneTimer invalidate];
        counterDeviceFindIphone=0;
        deviceFindIphoneState=NO;
    }
    //此时接收到报警信号也不用报警,因为正在打电话
    if (blecon._peripheral.state==CBPeripheralStateConnected) {
        for (int i=0; i<blecon._peripheral.services.count; i++) {
            CBService *cbp=[blecon._peripheral.services objectAtIndex:i];
            if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFD0"]]) {
                for (int j=0; j<cbp.characteristics.count; j++) {
                    CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                    if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFD6"]]) {
                        NSString *str=@"01";
                        NSData *PWMdata=[self NSStringToNSData:str];
                        [blecon._peripheral writeValue:PWMdata forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                        //NSLog(@"已经发送停掉报警的值了");
                    }
                }
            }
        }
    }
    else if (blecon._peripheral.state==CBPeripheralStateDisconnected  || blecon._peripheral.state==CBPeripheralStateConnecting)
    {
        // NSLog(@"蓝牙没有连接上");
    }
}
-(void)RCCallFinish
{
    isRCcallComing=FALSE;
    //此时接收到报警信号时需要报警，打电话已经结束了
    if (blecon._peripheral.state==CBPeripheralStateConnected) {
        for (int i=0; i<blecon._peripheral.services.count; i++) {
            CBService *cbp=[blecon._peripheral.services objectAtIndex:i];
            if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFD0"]]) {
                for (int j=0; j<cbp.characteristics.count; j++) {
                    CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                    if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFD6"]]) {
                        NSString *str=@"00";
                        NSData *PWMdata=[self NSStringToNSData:str];
                        [blecon._peripheral writeValue:PWMdata forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                          //NSLog(@"已经发送开始报警的值了");
                    }
                }
            }
        }
    }
    else if (blecon._peripheral.state==CBPeripheralStateDisconnected  || blecon._peripheral.state==CBPeripheralStateConnecting)
    {
        //NSLog(@"蓝牙没有连接上");
    }
}
//用于判断手势
- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

-(void)judeThelocationEanbleState:(NSNotification *)noti
{
    NSString *str=[noti object];
    if ([str isEqualToString:@"1"]) {
        locationEnable=YES;
    }
    else if ([str isEqualToString:@"0"]){
        locationEnable=NO;
    }
}

-(void)changePhotolight
{
    imagepickerCon.cameraViewTransform = CGAffineTransformMakeScale(photoSlider.value, photoSlider.value);
}
-(void) viewWillDisappear:(BOOL)animated
{
    isGoSetView=YES;
    firstOpen=NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    isGoSetView=NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //重新进入拍照页面应该要将镜头的放大倍数变成1倍
    photoSlider.value=1.0;
    
    //将相册的打开状态设置为未打开
    openPicLibraryIsFinsh=NO;
    
}

-(void)SetVCSwitchChangeValued
{
    //本段先禁用定时发送RSSI的功能，2s之后再次启用定时发送RSSI的功能
    if ([repetSendRssiTimer isValid]==TRUE) {
        [repetSendRssiTimer invalidate];
    }
    if ([setVCSwitchValuedChangeTimer isValid]==TRUE) {
        [setVCSwitchValuedChangeTimer invalidate];
    }
    if ([findKeyTouchTimer isValid]==TRUE) {
        [findKeyTouchTimer invalidate];
    }
    
    setVCSwitchValuedChangeTimer=[NSTimer scheduledTimerWithTimeInterval:delayTime target:self selector:@selector(getSendData) userInfo:nil repeats:NO];
    
    //当距离报警已经在报警状态时，切换了设置页面得关闭距离报警按钮时要把自己得报警给关掉
    if (setVC._switchThree.status==CustomSwitchStatusOff) {
        if ([alermTimer isValid]==TRUE) {
            [alermTimer invalidate];
            isAlerm=NO;
        }
    }
}
//将音乐播放页面的打开的标志位置为NO
-(void)getNOtiCloseMusicVC
{
    isMusicOpen=NO;
}

//
-(void)setVCVolumeChanged:(NSNotification *)noti
{
    NSString *StrVolume=[noti object];
    float volumes=[StrVolume floatValue];
    [self changeAlermVolume:volumes];
}
#pragma mark-
#pragma mark-切换主题的方法

-(void)changThemToDefaultColor
{
    //首先读取setImageOragne.plist中的数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"setImageDefault" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    [backgroundImageView setImage:[UIImage imageNamed:[dictionary objectForKey:@"01"]]];
    [setImageView setImage:[UIImage imageNamed:[dictionary objectForKey:@"04"]]];
    
    themIndex=0;
    
    //暂停发送RISSI
    [self SetVCSwitchChangeValued];
    if (blecon._peripheral.state==CBPeripheralStateConnected) {
        [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙蓝绿.png"]];
        
        for (int i=0; i<blecon._peripheral.services.count; i++) {
            CBService *cbp=[blecon._peripheral.services objectAtIndex:i];
            
            if ([[cbp  UUID]isEqual:[CBUUID UUIDWithString:@"180F"]]) {
                
                for (int j=0; j<cbp.characteristics.count; j++) {
                    CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                    // 获取电池电量报告
                    if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"2A19"]])
                    {
                        [blecon._peripheral readValueForCharacteristic:cbc];
                    }
                }
            }
        }
    }
    else {
        [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙灰.png"]];
    }
}
-(void)changeThemToOrange
{
    //首先读取setImageOragne.plist中的数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"setImageOragne" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    [backgroundImageView setImage:[UIImage imageNamed:[dictionary objectForKey:@"01"]]];
    [setImageView setImage:[UIImage imageNamed:[dictionary objectForKey:@"04"]]];
    
    themIndex=1;
    
    //暂停发送RISSI
    [self SetVCSwitchChangeValued];
    if (blecon._peripheral.state==CBPeripheralStateConnected) {
        [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙已连接橙色.png"]];
        
        for (int i=0; i<blecon._peripheral.services.count; i++) {
            CBService *cbp=[blecon._peripheral.services objectAtIndex:i];
            
            if ([[cbp  UUID]isEqual:[CBUUID UUIDWithString:@"180F"]]) {
                
                for (int j=0; j<cbp.characteristics.count; j++) {
                    CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                    // 获取电池电量报告
                    if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"2A19"]])
                    {
                        [blecon._peripheral readValueForCharacteristic:cbc];
                    }
                }
            }
        }
    }
    else {
        [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙灰.png"]];
    }
}

-(void)changeThemToGreen
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"setImageGreen" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    [backgroundImageView setImage:[UIImage imageNamed:[dictionary objectForKey:@"01"]]];
    [setImageView setImage:[UIImage imageNamed:[dictionary objectForKey:@"04"]]];
    themIndex=2;
    
    //暂停发送RISSI
    [self SetVCSwitchChangeValued];
    if (blecon._peripheral.state==CBPeripheralStateConnected) {
        [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙已连接绿色.png"]];
        
        for (int i=0; i<blecon._peripheral.services.count; i++) {
            CBService *cbp=[blecon._peripheral.services objectAtIndex:i];
            
            if ([[cbp  UUID]isEqual:[CBUUID UUIDWithString:@"180F"]]) {
                
                for (int j=0; j<cbp.characteristics.count; j++) {
                    CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                    // 获取电池电量报告
                    if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"2A19"]])
                    {
                        [blecon._peripheral readValueForCharacteristic:cbc];
                    }
                }
            }
        }
    }
    else {
        [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙灰.png"]];
    }
}

-(void)changeThemToPurple
{
    [backgroundImageView setImage:[UIImage imageNamed:@"背景紫色.png"]];
    [setImageView setImage:[UIImage imageNamed:@"设置紫色.png"]];
    themIndex=3;
    
    //暂停发送RISSI
    [self SetVCSwitchChangeValued];
    
    if (blecon._peripheral.state==CBPeripheralStateConnected) {
        [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙已连接紫色.png"]];
        for (int i=0; i<blecon._peripheral.services.count; i++) {
            CBService *cbp=[blecon._peripheral.services objectAtIndex:i];
            
            if ([[cbp  UUID]isEqual:[CBUUID UUIDWithString:@"180F"]]) {
                
                for (int j=0; j<cbp.characteristics.count; j++) {
                    CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                    // 获取电池电量报告
                    if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"2A19"]])
                    {
                        [blecon._peripheral readValueForCharacteristic:cbc];
                    }
                }
            }
        }
    }
    else {
        [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙灰.png"]];
    }
}
#pragma mark-
#pragma mark-首页五个功能键的方法
bool isGoSetView=NO;

-(void)goSetingView
{
    if (isGoSetView==NO) {
        if (!setVC) {
            setVC=[[SetViewController alloc]init];
        }
        [self.navigationController pushViewController:setVC animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
}

bool  findBtnIsTouchDown=YES;

-(void)findBtnTouchDown
{
    if (!setVC) {
        setVC=[[SetViewController alloc]init];
    }
    if ( setVC._switchOne.status==CustomSwitchStatusOn) {
        //Find功能处于打开状态，需要找外设
        //发送一个值让外设报警
        ///////////////////
        //本段先禁用定时发送RSSI的功能，2s之后再次启用定时发送RSSI的功能
        if ([repetSendRssiTimer isValid]==TRUE) {
            [repetSendRssiTimer invalidate];
        }
        if ([findKeyTouchTimer isValid]==TRUE) {
            [findKeyTouchTimer invalidate];
        }
        if ([setVCSwitchValuedChangeTimer isValid]==TRUE) {
            [setVCSwitchValuedChangeTimer invalidate];
        }
        findKeyTouchTimer=[NSTimer scheduledTimerWithTimeInterval:delayTime target:self selector:@selector(getSendData) userInfo:nil repeats:NO];
        /////////////////
        
        if (blecon._peripheral.state==CBPeripheralStateConnected) {
            for (int i=0; i<blecon._peripheral.services.count; i++) {
                CBService *cbp=[blecon._peripheral.services objectAtIndex:i];
                if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFD0"]]) {
                    for (int j=0; j<cbp.characteristics.count; j++) {
                        CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                        if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFD1"]]) {
                            
                            [blecon._peripheral setNotifyValue:YES forCharacteristic:cbc];
                            NSString *str;
                            if (findBtnIsTouchDown==YES) {
                                str=@"01";
                                findBtnIsTouchDown=NO;
                                
                                if (themIndex==0) {
                                     backgroundImageView.image=[UIImage imageNamed:@"背景外圈蓝绿.png"];
                                }
                                else if (themIndex==1) {
                                    backgroundImageView.image=[UIImage imageNamed:@"背景橙色按下.png"];
                                }
                                else if (themIndex==2) {
                                    backgroundImageView.image=[UIImage imageNamed:@"背景绿色按下.png"];
                                }
                                else if (themIndex==3) {
                                    backgroundImageView.image=[UIImage imageNamed:@"背景紫色按下.png"];
                                }
                            }
                            else{
                                str=@"00";
                                findBtnIsTouchDown=YES;
                                if (themIndex==0) {
                                    backgroundImageView.image=[UIImage imageNamed:@"背景深灰.png"];
                                }
                                else if (themIndex==1) {
                                    backgroundImageView.image=[UIImage imageNamed:@"背景橙色.png"];
                                }
                                else if (themIndex==2) {
                                    backgroundImageView.image=[UIImage imageNamed:@"背景绿色.png"];
                                }
                                else if (themIndex==3) {
                                    backgroundImageView.image=[UIImage imageNamed:@"背景紫色.png"];
                                }

                            }
                            NSData *PWMdata=[self NSStringToNSData:str];
                            if (isAlerm==YES) {
                                //正在处于距离报警状态，不用给外设发报警值
                            }
                            else{
                                [blecon._peripheral writeValue:PWMdata forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                            }
                        }
                    }
                }
            }
        }
        else if (blecon._peripheral.state==CBPeripheralStateDisconnected  || blecon._peripheral.state==CBPeripheralStateConnecting)
        {
            //..........
        }
    }
    else if (setVC._switchOne.status==CustomSwitchStatusOff){
         //Find功能处于关闭状态，不需要找外设
    }
}

//手机页面定位按钮按下时调用的一键定位
-(void)locationIsExist
{
    //取出来定位过的经纬度
    NSUserDefaults *userdefau=[NSUserDefaults standardUserDefaults];
    double mapLongitude=[userdefau doubleForKey:@"compxLongitude"];
    double mapLatitude=[userdefau doubleForKey:@"compxLatitude"];
    if (mapLongitude==0 || mapLatitude==0) {
        //没有定位过，跳转到定位功能页面
        [self recordUserLocation];
    }
    else{
        //定位过，直接打开地图
        mapVC=[[MapViewController alloc]init];
        [self presentViewController:mapVC animated:YES completion:^{}];
    }

}

//链接断开时调用的定位
-(void)breakConnectLocation
{
    UIApplicationState appState=[UIApplication sharedApplication].applicationState;
    
    if (appState==UIApplicationStateActive) {
        //NSLog(@"程序在前台");
    }
    else if (appState==UIApplicationStateBackground)
    {
        //NSLog(@"程序在后台");
    }
    if ([NetUnity networkreachable]==YES) {
        if (locationEnable==YES) {
            // 1. 实例化定位管理器
            locationMan=[[CLLocationManager alloc]init];
            locationMan.delegate=self;
            [locationMan setDesiredAccuracy:kCLLocationAccuracyBest];
            [locationMan startUpdatingLocation];
            [self dismissLocationView];
        }
        
        else if (locationEnable==NO){
        }
    }
    else if ([NetUnity networkreachable]==NO)
    {
        UIApplicationState appState=[UIApplication sharedApplication].applicationState;
        if (appState==UIApplicationStateActive) {
            if (alertShowIsOn==NO) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"No-network", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                [alert show];
                alertShowIsOn=YES;
            }
        }
        else if (appState==UIApplicationStateBackground)
        {
            //NSLog(@"程序在后台,不用提醒！");
        }
    }
}

//外设按键按下时调用的一键定位
UITextView *viewLocationOK;
-(void)recordUserLocation
{
    UIApplicationState appState=[UIApplication sharedApplication].applicationState;

    if (appState==UIApplicationStateActive) {
    
    }
    else if (appState==UIApplicationStateBackground)
    {
    
    }
    
    if ([NetUnity networkreachable]==YES) {
        if (locationEnable==YES) {
            // 1. 实例化定位管理器
            locationMan=[[CLLocationManager alloc]init];
            locationMan.delegate=self;
            [locationMan setDesiredAccuracy:kCLLocationAccuracyBest];
            [locationMan startUpdatingLocation];
            
            if (!viewLocationOK) {
                viewLocationOK=[[UITextView alloc]initWithFrame:CGRectMake(80, 280,160,60)];
            }
            viewLocationOK.backgroundColor=[UIColor whiteColor];
            viewLocationOK.layer.cornerRadius=10.0;
            viewLocationOK.text=@"Locating Succeeded!";
            viewLocationOK.textColor=[UIColor blackColor];
            viewLocationOK.textAlignment=NSTextAlignmentCenter;
            viewLocationOK.font=[UIFont systemFontOfSize:16.0];
            [self dismissLocationView];
//            [self performSelector:@selector(dismissLocationView) withObject:self afterDelay:0.5];
        }
        
        else if (locationEnable==NO){
               if (alertShowIsOn==NO) {
                   alertMapLocationEnable=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"Please-trun-on-Map-location", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                   [alertMapLocationEnable show];
                   alertShowIsOn=YES;
            }
        }
    }
    else if ([NetUnity networkreachable]==NO)
    {
        
        UIApplicationState appState=[UIApplication sharedApplication].applicationState;
        if (appState==UIApplicationStateActive) {
           
            if (alertShowIsOn==NO) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"No-network", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                [alert show];
                alertShowIsOn=YES;
            }
        }
        else if (appState==UIApplicationStateBackground)
        {
            
        }
    }
}

#pragma mark-
#pragma mark-首页五个功能键的方法会调用到的相关方法
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
{
    alertShowIsOn=NO;
}
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;
{
    clcoordinate=[newLocation coordinate];
    //定位成功之后关闭定位，省电
    [locationMan stopUpdatingLocation];
    
     //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:clcoordinate]) {
        //转换后的coord
        clcoordinate=[WGS84TOGCJ02 transformFromWGSToGCJ:clcoordinate];
    }
    
    //经纬度
    double clcoordinateLongitude=clcoordinate.longitude;
    double clcoordinateLatitude=clcoordinate.latitude;

    NSUserDefaults *userdefau=[NSUserDefaults standardUserDefaults];
    [userdefau setDouble:clcoordinateLongitude forKey:@"compxLongitude"];
    [userdefau setDouble:clcoordinateLatitude forKey:@"compxLatitude"];
    [userdefau synchronize];
    
}

-(void)dismissLocationView
{
    if ([viewLocationOK isDescendantOfView:self.view]==TRUE) {
        [viewLocationOK removeFromSuperview];
    }
    if ([changeLovcationTimer isValid]==TRUE) {
        
    }
    else{
        changeLovcationTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeLocationImage) userInfo:nil repeats:YES];
    }

}

bool LocationImageOn=NO;
int LocationImageCounter=0;
-(void)changeLocationImage
{
    if (LocationImageOn==NO) {
       [mapLocationBtn setImage:[UIImage imageNamed:@"红色.png"] forState:UIControlStateNormal];
        LocationImageOn=YES;
    }
    else if (LocationImageOn==YES){
        [mapLocationBtn setImage:[UIImage imageNamed:@"白色.png"] forState:UIControlStateNormal];
        LocationImageOn=NO;
    }
    LocationImageCounter++;
    if (LocationImageCounter>5) {
        if ([changeLovcationTimer isValid]==YES) {
            [changeLovcationTimer invalidate];
        }
        LocationImageCounter=0;
    }
    
}


bool CamerOpenFinsh=NO;
NSInteger photoTime=0;
int takePickerTureCounter=0;

-(void)gotoCamera
{
    if (!imagepickerCon) {
        
        imagepickerCon = [[UIImagePickerController alloc] init];

        imagepickerCon.view.multipleTouchEnabled=NO;
        
        UIView *overLayView=[[UIView alloc]initWithFrame:self.view.bounds];
        
        //创建一个导航栏
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
        navigationBar.alpha=0.7;
//        navigationBar.tintColor=[UIColor colorWithRed:30 green:144 blue:255 alpha:1.0];
        navigationBar.tintColor=[UIColor blackColor];
        //创建一个导航栏集合
        UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
        
        //创建一个左边按钮
        leftButtonCamera=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"闪关灯关.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pushButton:)];

        //创建一个右边按钮
        rightButtonCamera=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"镜头切换.png"] style:UIBarButtonItemStyleDone target:self action:@selector(changeCameraDevice)];
        
        //设置导航栏内容
        [navigationItem setTitle:@"Camera"];
        //把导航栏集合添加入导航栏中，设置动画关闭
        [navigationBar pushNavigationItem:navigationItem animated:NO];
        //把左右两个按钮添加入导航栏集合中
        [navigationItem setLeftBarButtonItem:leftButtonCamera];
        [navigationItem setRightBarButtonItem:rightButtonCamera];
        //把导航栏添加到视图中
        [overLayView addSubview:navigationBar];
        
        overLayView.userInteractionEnabled=YES;
        overLayView.multipleTouchEnabled=NO;
        imagepickerCon.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 不使用系统的控制界面
        imagepickerCon.showsCameraControls=NO;
        imagepickerCon.allowsEditing=YES;
    
        //修改镜头焦距的
        imagepickerCon.cameraViewTransform = CGAffineTransformMakeScale(1.0, 1.0);
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

            NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagepickerCon.sourceType];
            imagepickerCon.mediaTypes = temp_MediaTypes;

            if (UIImagePickerControllerCameraDeviceFront) {
                imagepickerCon.cameraDevice=UIImagePickerControllerCameraDeviceFront;//将摄像头修改为前置摄像头，如果设备有前置摄像头的话
                [imagepickerCon setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
                leftButtonCamera.enabled=NO;
            }
            else
            {
                //NSLog(@"你的前置摄像头不能用！");
            }
            
            imagepickerCon.delegate = self;
        }
    
        CGRect rx = [ UIScreen mainScreen ].bounds;
        UIToolbar *controlViewImage ;
        if (rx.size.height>480.0) {
            controlViewImage = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-142, self.view.frame.size.width, 142)];
        }
        else
        {
            controlViewImage = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-84, self.view.frame.size.width, 84)];
        }
        controlViewImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        controlViewImage.alpha=1;
        
        /*
        //闪光灯
        flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        flashBtn.frame = CGRectMake(0, 0, 55, 55);
        flashBtn.showsTouchWhenHighlighted = YES;
        flashBtn.tag = 100;
        [flashBtn setImage:[UIImage imageNamed:@"camera_flash_auto.png"] forState:UIControlStateNormal];
        [flashBtn addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *flashItem = [[UIBarButtonItem alloc] initWithCustomView:flashBtn];
        if (isPad) {
            //ipad,禁用闪光灯
            flashItem.enabled = NO;
        }
        */
        
        /*
         //打开相册
         UIButton *cameraOpenLibery = [UIButton buttonWithType:UIButtonTypeCustom];
         cameraOpenLibery.frame = CGRectMake(0, 0, 55, 55);
         cameraOpenLibery.showsTouchWhenHighlighted = YES;
         [cameraOpenLibery setImage:[UIImage imageNamed:@"换图片-相册图标.png"] forState:UIControlStateNormal];
         [cameraOpenLibery addTarget:self action:@selector(openPicLibrary) forControlEvents:UIControlEventTouchUpInside];
         UIBarButtonItem *cameraDeviceItem = [[UIBarButtonItem alloc] initWithCustomView:cameraOpenLibery];
         if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
         //判断是否支持前置摄像头
         cameraDeviceItem.enabled = NO;
         }
         */
        /*
        //拍照
        cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraButton.frame = CGRectMake(0, 0, 80, 80);
        cameraButton.showsTouchWhenHighlighted = YES;
        [cameraButton setImage:[UIImage imageNamed:@"拍照前.png"] forState:UIControlStateNormal];
        [cameraButton addTarget:self action:@selector(takeImage) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *takePicItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
        
        
//        UIBarButtonItem *takePicItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"08"] style:UIBarButtonItemStylePlain target:self action:@selector(takeImage)];
        
        //取消、完成
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(0, 0, 40, 40);
        doneBtn.showsTouchWhenHighlighted = YES;
        [doneBtn setImage:[UIImage imageNamed:@"拍照返回.png"] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
        
        //空item
        UIBarButtonItem *spItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray *items = [NSArray arrayWithObjects:spItem,doneItem,spItem,takePicItem,spItem,spItem,spItem, nil];
        [controlViewImage setItems:items];
        */
     
        //////////////////////////
        
        UIView *myview;
        
        if (iPhone5) {
            myview=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-143, 320, 143)];
            myview.backgroundColor=[UIColor lightGrayColor];
            [overLayView addSubview:myview];
            
            
            photoSlider=[[UISlider alloc]init];
            photoSlider.frame=CGRectMake(20, 15, 280, 20);
            photoSlider.minimumValue=1.0;
            photoSlider.maximumValue=2.5;
            photoSlider.value=1.0;
            [photoSlider addTarget:self action:@selector(changePhotolight) forControlEvents:UIControlEventValueChanged];
            [controlViewImage addSubview:photoSlider];
            [myview addSubview:photoSlider];
            
            UIButton *buttonCancel=[UIButton buttonWithType:UIButtonTypeCustom];
            buttonCancel.frame=CGRectMake(20, 55, 25, 45);
            [buttonCancel setImage:[UIImage imageNamed:@"拍照返回.png"] forState:UIControlStateNormal];
            [buttonCancel addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchDown];
            [myview addSubview:buttonCancel];
            
            
            buttonCam=[UIButton buttonWithType:UIButtonTypeCustom];
            buttonCam.frame=CGRectMake(125, 45, 70, 70);
            [buttonCam setImage:[UIImage imageNamed:@"拍照前.png"] forState:UIControlStateNormal];
            [buttonCam addTarget:self action:@selector(takeImage) forControlEvents:UIControlEventTouchUpInside];
            [myview addSubview:buttonCam];
        }
        else{
            myview=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-90, 320, 90)];
            myview.backgroundColor=[UIColor lightGrayColor];
            myview.alpha=0.7;
            myview.multipleTouchEnabled=NO;
            [overLayView addSubview:myview];
            
            
            photoSlider=[[UISlider alloc]init];
            photoSlider.frame=CGRectMake(20, 8, 280, 18);
            photoSlider.minimumValue=1.0;
            photoSlider.maximumValue=2.5;
            photoSlider.value=1.0;
            [photoSlider addTarget:self action:@selector(changePhotolight) forControlEvents:UIControlEventValueChanged];
            [controlViewImage addSubview:photoSlider];
            [myview addSubview:photoSlider];
            
            UIButton *buttonCancel=[UIButton buttonWithType:UIButtonTypeCustom];
            buttonCancel.frame=CGRectMake(25, 38, 20, 40);
            [buttonCancel setImage:[UIImage imageNamed:@"拍照返回.png"] forState:UIControlStateNormal];
            [buttonCancel addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchDown];
            [myview addSubview:buttonCancel];
            
            
            buttonCam=[UIButton buttonWithType:UIButtonTypeCustom];
            buttonCam.frame=CGRectMake(130, 31, 53, 53);
            [buttonCam setImage:[UIImage imageNamed:@"拍照前.png"] forState:UIControlStateNormal];
            [buttonCam addTarget:self action:@selector(takeImage) forControlEvents:UIControlEventTouchUpInside];
            [myview addSubview:buttonCam];
        }
       
        [overLayView addSubview:myview];
        //////////////////
        
//        [overLayView addSubview:controlView];
        imagepickerCon.cameraOverlayView = overLayView;
        controlViewImage = nil;
    }
    
    if (CamerOpenFinsh==NO) {
        [self takePicketure];
    }
}

bool VideoOpenFinsh=NO;
bool startVideoFlag=NO;
int hourTimer=0; //摄像时的计时器
int minTimer=0;
int secTimer=0;

-(void)goVideo
{
    if (!videopickerCon) {
        videopickerCon = [[UIImagePickerController alloc] init];
        UIView *overLayView=[[UIView alloc]initWithFrame:self.view.bounds];
        
        //创建一个导航栏
        navigationBarGoVideo = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        navigationBarGoVideo.tintColor=[UIColor blackColor];
        navigationBarGoVideo.alpha=0.7;
        //创建一个导航栏集合
        navigationItemGoVideo = [[UINavigationItem alloc] initWithTitle:nil];
        
        //创建一个左边按钮
        leftButtonVideo=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"闪关灯自动.png"] style:UIBarButtonItemStyleDone target:self action:@selector(videoFalshModes)];
        
        
        //创建一个右边按钮
        rightButtonVideo=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"镜头切换.png"] style:UIBarButtonItemStyleDone target:self action:@selector(changeVideoDevice)];
//        rightButton=[[UIBarButtonItem alloc]initWithTitle:@"123456789" style:UIBarButtonItemStyleDone target:self action:@selector(changeVideoDevice:)];
//        [rightButton setTintColor:[UIColor redColor]];
        
        //设置导航栏内容
        [navigationItemGoVideo setTitle:@"Video"];
        //把导航栏集合添加入导航栏中，设置动画关闭
        [navigationBarGoVideo pushNavigationItem:navigationItemGoVideo animated:NO];
        //把左右两个按钮添加入导航栏集合中
        [navigationItemGoVideo setLeftBarButtonItem:leftButtonVideo];
        [navigationItemGoVideo setRightBarButtonItem:rightButtonVideo];
        //把导航栏添加到视图中
        [overLayView addSubview:navigationBarGoVideo];
        
        videopickerCon.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 不使用系统的控制界面
        videopickerCon.showsCameraControls=NO;
        videopickerCon.view.multipleTouchEnabled=NO;
        
        //修改镜头焦距的
        //        videopickerCon.cameraViewTransform = CGAffineTransformMakeScale(1.0, 1.0);
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:videopickerCon.sourceType];
            videopickerCon.mediaTypes = temp_MediaTypes;
            
            /*
             //判断闪光灯是否可用，这里是系统自动调用闪光灯，要是自己想打开闪光灯，需要需要调用AVFoundation框架
             if (UIImagePickerControllerCameraDeviceFront) {
             videopickerCon.cameraDevice=UIImagePickerControllerCameraDeviceFront;//将摄像头修改为前置摄像头，如果设备有前置摄像头的话
             }
             else
             {
             NSLog(@"你的前置摄像头不能用！");
             }
             */
            videopickerCon.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
            if (iPhone5) {
                videopickerCon.videoQuality = UIImagePickerControllerQualityTypeHigh;
            }
            else{
                videopickerCon.videoQuality = UIImagePickerControllerQualityTypeMedium;
            }
            videopickerCon.delegate = self;
        }
        
        CGRect rx = [ UIScreen mainScreen ].bounds;
        UIToolbar *controlView ;
        if (rx.size.height>480.0) {
            controlView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-78, self.view.frame.size.width, 78)];
        }
        else
        {
            controlView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64)];
        }
        controlView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        controlView.alpha=0.5;
        
        /*

        //摄像
        videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        videoButton.frame = CGRectMake(0, 0, 65, 65);
        videoButton.showsTouchWhenHighlighted = YES;
//        [videoButton setImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
        [videoButton setImage:[UIImage imageNamed:@"摄像前.png"] forState:UIControlStateNormal];
        [videoButton addTarget:self action:@selector(startVideo) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *takePicItem = [[UIBarButtonItem alloc] initWithCustomView:videoButton];
        //取消、完成
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(0, 0, 25, 45);
        doneBtn.showsTouchWhenHighlighted = YES;
        [doneBtn setImage:[UIImage imageNamed:@"拍照返回.png"] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
        
        //空item
        UIBarButtonItem *spItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *items = [NSArray arrayWithObjects:spItem,doneItem,spItem,spItem,takePicItem,spItem,spItem,spItem, nil];
        [controlView setItems:items];
        [overLayView addSubview:controlView];
        
        */
        
        /////////////////////////////
        UIView *videoView;
        if (iPhone5) {
        }
        else{
        }
        
        videoView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-83, 320, 83)];
        videoView.backgroundColor=[UIColor lightGrayColor];
        videoView.alpha=0.7;
        [overLayView addSubview:videoView];
   
        
        UIButton *buttonCancel=[UIButton buttonWithType:UIButtonTypeCustom];
        buttonCancel.frame=CGRectMake(25, 17.5, 20, 40);
        [buttonCancel setImage:[UIImage imageNamed:@"拍照返回.png"] forState:UIControlStateNormal];
        [buttonCancel addTarget:self action:@selector(cancleVideo) forControlEvents:UIControlEventTouchDown];
        [videoView addSubview:buttonCancel];
        
        videoButton=[UIButton buttonWithType:UIButtonTypeCustom];
        videoButton.frame=CGRectMake(130, 10, 60, 60);
        [videoButton setImage:[UIImage imageNamed:@"摄像前.png"] forState:UIControlStateNormal];
        [videoButton addTarget:self action:@selector(startVideo) forControlEvents:UIControlEventTouchUpInside];
        [videoView addSubview:videoButton];
        [overLayView addSubview:videoView];
        videopickerCon.cameraOverlayView = overLayView;
        controlView = nil;
    }
    if (VideoOpenFinsh==NO) {
        [self takeVideo];
    }
    /*
     //屏蔽掉了在打开录像页面是还继续接收指令
    else if (VideoOpenFinsh==YES)
    {
        if (videopickerCon.cameraCaptureMode==UIImagePickerControllerCameraCaptureModeVideo) {
            if (startVideoFlag==NO) {
                //创建一个录像时间的指示
                videoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
                [videoTimer fire];
                [videopickerCon startVideoCapture];
                startVideoFlag=YES;
                
            }
            else if(startVideoFlag==YES)
            {
                [videopickerCon stopVideoCapture];
                if (videoTimer.isValid==TRUE) {
                    [videoTimer invalidate];
                    secTimer=0;
                    minTimer=0;
                    hourTimer=0;
                }
                [rightButtonVideo setImage:[UIImage imageNamed:@"camera_mode40.png"]];
                [rightButtonVideo setTitle:nil];
                rightButtonVideo.enabled=YES;
                [rightButtonVideo setTintColor:[UIColor greenColor]];
                [rightButtonVideo setAction:@selector(changeVideoDevice)];
                startVideoFlag=NO;
            }
        }
    }
     */
    
}

bool isNotiMusic=NO;

//封装系统加载函数
-(void)loadMusic:(NSString*)name type:(NSString*)type
{
    NSString* path= [[NSBundle mainBundle] pathForResource: name ofType:type];
    NSURL* url = [NSURL fileURLWithPath:path];
    if (!setVC) {
        setVC=[[SetViewController alloc]init];
    }
    _audioPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    _audioPlayer.delegate=self;
    _audioPlayer.volume=setVC.sliderVolume.value;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [_audioPlayer prepareToPlay];
    
    
    //发通知给音乐播放界面告知自己需要报警了
    if (isNotiMusic==NO) {
//       [[NSNotificationCenter defaultCenter]postNotificationName:notiAudioWillPlay object:self userInfo:nil];
        isNotiMusic=YES;
        //四秒之后才可以再次连接
        [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(setNotiMusicState) userInfo:nil repeats:NO];
    }
    
//    musicVC=[[MusicViewController alloc]init];
//    [musicVC.player pause];
//    if (musicVC.MusicVCisPlaying==YES) {
//        
//    }
    
}
-(void)setNotiMusicState
{
    isNotiMusic=NO;
}

/////////////////////////

#pragma mark
#pragma Mark-AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    [_audioPlayer stop];
}
/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;

{
}

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;
{
    [_audioPlayer pause];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
   
}
/* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags NS_AVAILABLE_IOS(6_0);
{
     [_audioPlayer play];
    
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags NS_DEPRECATED_IOS(4_0, 6_0);
{
     [_audioPlayer play];
}
/* audioPlayerEndInterruption: is called when the preferred method, audioPlayerEndInterruption:withFlags:, is not implemented. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 6_0);

{
     [_audioPlayer play];
}


////////////////////////
bool flagReadBattery=NO; //读取电池电量标志

- (void)noticeToReadBattery{
    
    for (int i=0; i<blecon._peripheral.services.count; i++) {
        CBService *cbp=[blecon._peripheral.services objectAtIndex:i];
        
        if ([[cbp  UUID]isEqual:[CBUUID UUIDWithString:@"180F"]]) {
            
            for (int j=0; j<cbp.characteristics.count; j++) {
                CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                // 获取电池电量报告
                if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"2A19"]])
                {
                    [blecon._peripheral readValueForCharacteristic:cbc];
                }
            }
        }
    }
    
    [self performSelector:@selector(noticeToReadBattery) withObject:nil afterDelay:60];
}

#pragma mark-
#pragma mark-蓝牙协议的方法实现部分

-(void) getCheckInfo:(NSString *)manuFaCtureInfo;
{}
-(void) peripheralUpdateNumbers:(NSMutableArray *)peripheralArray;
{}
bool autoSendFlag=NO;//自动发送数据的标志

-(void) getNameAndUUID;
{
     
    for (int i=0; i<blecon._peripheral.services.count; i++) {
        CBService *cbp=[blecon._peripheral.services objectAtIndex:i];
        
        if ([[cbp  UUID]isEqual:[CBUUID UUIDWithString:@"180F"]]) {
            
            for (int j=0; j<cbp.characteristics.count; j++) {
                CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                // 获取电池电量报告
                if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"2A19"]])
                {
                    [blecon._peripheral readValueForCharacteristic:cbc];
                }
            }
        }
    }
    
    //获取外设电池电量：当前为60s一次
    if (flagReadBattery==NO) {
        [self noticeToReadBattery];
        flagReadBattery=YES;
    }
    
    //修改蓝牙连接标志为连接状态；
    if (themIndex==1) {
        
        [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙已连接橙色.png"]];
    }
    else if (themIndex==2){
        
        [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙已连接绿色.png"]];
    }
    else if (themIndex==3){
       
        [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙已连接紫色.png"]];
    }
    else
    //修改蓝牙连接标志为连接状态；
    [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙蓝绿.png"]];
    
    
    //周期发RSSI的数据

    if (autoSendFlag==NO) {
        countConnectTimer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(getSendData) userInfo:nil repeats:NO];
        
        autoSendFlag=YES;
    }
    
    //判断断线报警是否还在继续存在，存在就直接关掉
    if ([findIphoneTimer isValid]==TRUE) {
        [findIphoneTimer invalidate];
        deviceFindIphoneState=NO;
    }
    //把两秒计时的计数器清零
    alermTimeCount=0.0;
    if ([alermCounteTimer isValid]==TRUE) {
        [alermCounteTimer invalidate];
    }
    linkLossAlermIsOn=NO;
    
    ////////////////////
    //断线重连后发送一次设置页面的开关状态值给外设
    if (!setVC) {
        setVC=[[SetViewController alloc]init];
    }
    [setVC lostEnableSwitchChangeState];
    [setVC rangeSwitchChangeState];
    [setVC linkLostSwitchChangeState];
    ////////////////////
    
    
}

//将设置页面的开关状态值给外设
-(void)sendSetViewControllerSwitchStateToPerpheral
{
    if (!setVC) {
        setVC=[[SetViewController alloc]init];
    }
    [setVC lostEnableSwitchChangeState];
    [setVC rangeSwitchChangeState];
    [setVC linkLostSwitchChangeState];
}


float alermTimeCount=0.0;
bool linkLossAlermIsOn=NO;
-(void) breakConnect;
{
    //修改电池电量为空
    [batteryStateImageView setImage:[UIImage imageNamed:@"电池灰.png"]];
    
    //修改蓝牙连接标志为未连接状态；
    [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙灰.png"]];
    
    if (isRCcallComing==TRUE) {
        //正在打电话，什么也不用做,直接返回
        return;
    }
    //开始断线计时，达到了两秒钟才需要开始启动报警
    if (linkLossAlermIsOn==NO) {
        alermCounteTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addCountAlerm) userInfo:nil repeats:YES];
        [alermCounteTimer fire];
        linkLossAlermIsOn=YES;
        
    }
    
    //////////////////清空定时发送
    autoSendFlag=NO;
    if ([repetSendRssiTimer isValid]==TRUE) {
        [repetSendRssiTimer invalidate];
    }
}

-(void)addCountAlerm
{
    alermTimeCount=alermTimeCount+1.0;
    //达到两秒后需要报警
    if (alermTimeCount>=2.0) {
        if ([alermCounteTimer isValid]==TRUE) {
            [alermCounteTimer invalidate];
        }
        alermTimeCount=0.0;
        
        //判断是否需要断开报警
        if (!setVC) {
            setVC=[[SetViewController alloc]init];
        }
        if (setVC._switchThree.status==CustomSwitchStatusOff) {
            //不用报警   setVC.linkLossSwitch.on==NO || setVC.lostEnableSwitch.on==NO
        }
        else{
            //需要报警
            if (deviceFindIphoneState==NO) {
                UIApplicationState appState=[UIApplication sharedApplication].applicationState;
                if (appState==UIApplicationStateActive) {
                    
                    findIphoneTimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(alermBycounterLinkLoss) userInfo:nil repeats:YES];
                    [findIphoneTimer fire];
                    deviceFindIphoneState=YES;
                   
                }
                else if (appState==UIApplicationStateBackground){
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:notiAudioWillPlay object:self userInfo:nil];
                    
                    [[UIApplication sharedApplication]cancelAllLocalNotifications];
                    UILocalNotification *notification=[[UILocalNotification alloc] init];
                    if (notification!=nil) {
                        NSDate *now = [NSDate date];
                        //从现在开始，1秒以后通知
                        notification.fireDate=[now dateByAddingTimeInterval:0.5];
                        //使用本地时区
                        notification.timeZone=[NSTimeZone defaultTimeZone];
                        //notification.alertBody=@"外设正在寻找手机";
                        //通知提示音 使用默认的
                        notification.soundName= @"newLinkLossBack.caf";
                        //这个通知到时间时，你的应用程序右上角显示的数字。
                        //notification.applicationIconBadgeNumber = 1;
                        //启动这个通知
                        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
                        deviceFindIphoneState=NO;
                    }
                }
            }
        }
        //断开定位
        [self breakConnectLocation];
    }
    //判断断开连接，当前超过RSSI预设值报警是否有效，有效则关闭超过RSSI预设值报警
    if ([alermTimer isValid]==TRUE) {
        [alermTimer invalidate];
        isAlerm=NO;
    }
}

BOOL isAlerm=NO; //判断当前是否再报警
NSString *receiveInfo1=@"";
NSString *receiveInfo2=@"";
int receiveInfoCounter=0;
-(void) getCharAndUUID:(CBCharacteristic *)characteristic;
{
    if (isRCcallComing==TRUE) {
        //正在打电话，什么也不用做,直接返回
        //return;
    }
    else{
        UIApplicationState appState=[UIApplication sharedApplication].applicationState;
        
        if ([[self UUIDToString:characteristic.UUID] isEqualToString:@"ffe1"]) {
            const unsigned char *hexBytesHome = [characteristic.value bytes];
            NSString *hexString= [NSString stringWithFormat:@"%02x%02x", hexBytesHome[0],hexBytesHome[1]];
            NSString *rangeString = [hexString substringWithRange:NSMakeRange(0, 2)];
            
            if (CamerOpenFinsh==YES) {
                if ([rangeString isEqualToString:@"02"]) {
                    
                    if (appState==UIApplicationStateActive) {
                        if (CamerOpenFinsh==YES) {
                            //拍照页面已经打开，此时用做调焦距用
                            for (int i=0; i<100; i++) {
                                if (photoSlider.value<=3.0) {
                                    photoSlider.value=photoSlider.value+0.001;
                                    [self changePhotolight];
                                }
                            }
                        }
                    }
                    else if (appState==UIApplicationStateBackground)
                    {
                    }
                }
                if ([rangeString isEqualToString:@"04"]) {
                    
                    if (appState==UIApplicationStateActive) {
                        if (CamerOpenFinsh==YES) {
                            //拍照页面已经打开，此时用做调焦距用
                            for (int i=0; i<100; i++) {
                                if (photoSlider.value>=1.0) {
                                    photoSlider.value=photoSlider.value-0.001;
                                    [self changePhotolight];
                                }
                            }
                        }
                    }
                    else if (appState==UIApplicationStateBackground){
                    }
                }
                if ([rangeString isEqualToString:@"01"]) {
                    
                    if (appState==UIApplicationStateActive) {
                        
                        if (CamerOpenFinsh==YES) {
                            [self doneAction];
                        }
                    }
                    else if (appState==UIApplicationStateBackground)
                    {
                    }
                }
                if ([rangeString isEqualToString:@"10"]) {
                    
                    if (appState==UIApplicationStateActive) {
                        if (CamerOpenFinsh==YES) {
                            [self takeImage];
                        }
                    }
                    else if (appState==UIApplicationStateBackground)
                    {
                        [self deviceFindIphone];
                    }
                }
                if ([rangeString isEqualToString:@"08"]) {
                    if (appState==UIApplicationStateActive) {
                        if (CamerOpenFinsh==YES) {
                            [self changeCameraDevice];
                        }
                    }
                    else if (appState==UIApplicationStateBackground)
                    {
                    }
                }
            }
            
            else if (isMusicOpen==YES){
                if (receiveInfoCounter<2) {
                    if (receiveInfoCounter==0) {
                        receiveInfo1=rangeString;
                        receiveInfoCounter++;
                        //检测用户是否在没有打开拍照也页面时长按了，如果长按则不于操作
                        if ([receiveInfo1 isEqualToString:@"00"]) {
                            receiveInfoCounter=0;
                        }
                    }
                    else if (receiveInfoCounter==1){
                        receiveInfo2=rangeString;
                        receiveInfoCounter=0;
                        
                        if ([receiveInfo1 isEqualToString:@"02"] && [receiveInfo2 isEqualToString:@"00"]) {
                            if (isMusicOpen==YES) {
                                //音乐页面已经打开，此时用做调音量距用
                                if (!musicVC) {
                                    musicVC=[[MusicViewController alloc]init];
                                }
                                [musicVC addVolume];
                            }
                        }
                        
                        if ([receiveInfo1 isEqualToString:@"10"] && [receiveInfo2 isEqualToString:@"00"]) {
                            //对马建 ，此处用做播放暂停建
                            if (!musicVC) {
                                musicVC=[[MusicViewController alloc]init];
                            }
                            [musicVC playPausePressed];
                        }
                        
                        if ([receiveInfo1 isEqualToString:@"04"] && [receiveInfo2 isEqualToString:@"00"]) {
                            //音量减
                            if (!musicVC) {
                                musicVC=[[MusicViewController alloc]init];
                            }
                            [musicVC subVolume];
                        }
                        
                        if ([receiveInfo1 isEqualToString:@"08"] && [receiveInfo2 isEqualToString:@"00"]) {
                            //上一首，定位键
                            if (!musicVC) {
                                musicVC=[[MusicViewController alloc]init];
                            }
                            [musicVC rewindPressed];
                        }
                        
                        if ([receiveInfo1 isEqualToString:@"01"] && [receiveInfo2 isEqualToString:@"00"]) {
                            //下一首，返回键
                            
                            if (!musicVC) {
                                musicVC=[[MusicViewController alloc]init];
                            }
                            [musicVC fastForwardPressed];
                        }
                    }
                }
            }
            
            else{
                if (receiveInfoCounter<2) {
                    if (receiveInfoCounter==0) {
                        receiveInfo1=rangeString;
                        receiveInfoCounter++;
                        //检测用户是否在没有打开拍照也页面时长按了，如果长按则不于操作
                        if ([receiveInfo1 isEqualToString:@"00"]) {
                            receiveInfoCounter=0;
                        }
                    }
                    else if (receiveInfoCounter==1){
                        receiveInfo2=rangeString;
                        receiveInfoCounter=0;
                        
                        if ([receiveInfo1 isEqualToString:@"02"] && [receiveInfo2 isEqualToString:@"00"]) {
                            if (appState==UIApplicationStateActive) {
                                
                                if (CamerOpenFinsh==YES) {
                                    //拍照页面已经打开，此时用做调焦距用
                                    for (int i=0; i<100; i++) {
                                        if (photoSlider.value<=3.0) {
                                            photoSlider.value=photoSlider.value+0.001;
                                            [self changePhotolight];
                                        }
                                    }
                                }
                                else{
                                    [self goVideo];
                                }
                            }
                            else if (appState==UIApplicationStateBackground)
                            {
                            }
                        }
                        
                        if ([receiveInfo1 isEqualToString:@"10"] && [receiveInfo2 isEqualToString:@"00"]) {
                            if (appState==UIApplicationStateActive) {
                                if (CamerOpenFinsh==YES) {
                                    [self takeImage];
                                }
                                else if (VideoOpenFinsh==YES)
                                {
                                    [self startVideo];
                                }
                                else
                                {
                                    /*
                                     /////////////////
                                     //新添加的不在音乐播放页面打开播放功能
                                     if (!setVC) {
                                     setVC=[[SetViewController alloc]init];
                                     }
                                     if ( setVC._switchOne.status==CustomSwitchStatusOff) {
                                     //对马建 ，此处用做播放暂停建
                                     if (!musicVC) {
                                     musicVC=[[MusicViewController alloc]init];
                                     }
                                     [musicVC playPausePressed];
                                     }
                                     else{
                                     
                                     }
                                     */
                                    [self deviceFindIphone];
                                    ///////////////////
                                }
                            }
                            else if (appState==UIApplicationStateBackground)
                            {
                                [self deviceFindIphone];
                            }
                        }
                        
                        if ([receiveInfo1 isEqualToString:@"04"] && [receiveInfo2 isEqualToString:@"00"]) {
                            if (appState==UIApplicationStateActive) {
                                if (CamerOpenFinsh==YES) {
                                    //拍照页面已经打开，此时用做调焦距用
                                    for (int i=0; i<100; i++) {
                                        if (photoSlider.value>=1.0) {
                                            photoSlider.value=photoSlider.value-0.001;
                                            [self changePhotolight];
                                        }
                                    }
                                }
                                else
                                {
                                    [self gotoCamera];
                                }
                            }
                            else if (appState==UIApplicationStateBackground)
                            {
                            }
                        }
                        
                        if ([receiveInfo1 isEqualToString:@"08"] && [receiveInfo2 isEqualToString:@"00"]) {
                            if (appState==UIApplicationStateActive) {
                                if (CamerOpenFinsh==YES) {
                                    [self changeCameraDevice];
                                }
                                else if (VideoOpenFinsh==YES)
                                {
                                    [self changeVideoDevice];
                                }
                                else
                                {
                                    [self recordUserLocation];
                                }
                            }
                            else if (appState==UIApplicationStateBackground)
                            {
                                [self recordUserLocation];
                            }
                        }
                        
                        if ([receiveInfo1 isEqualToString:@"01"] && [receiveInfo2 isEqualToString:@"00"]) {
                            if (appState==UIApplicationStateActive) {
                                if (CamerOpenFinsh==YES) {
                                    [self doneAction];
                                }
                                else if (VideoOpenFinsh==YES){
                                    [self cancleVideo];
                                }
                                else if (isGoSetView==YES && openPicLibraryIsFinsh==NO){
                                    
                                }
                                else if (openPicLibraryIsFinsh==YES){
                                    // [self cancleOpenPicLab];
                                    
                                    musicVC=[[MusicViewController alloc]init];
                                    [musicVC backToMainView];
                                    
                                }
                                else{
                                    //[self openPicLibrary];
                                    [self openMusic];
                                    isMusicOpen=YES;
                                }
                            }
                            else if (appState==UIApplicationStateBackground)
                            {
                                
                            }
                        }
                    }
                }
            }
            /*
             if ([rangeString isEqualToString:@"02"]) {
             NSLog(@"你按了摄像键！！");
             if (appState==UIApplicationStateActive) {
             NSLog(@"程序在前台");
             
             if (CamerOpenFinsh==YES) {
             //拍照页面已经打开，此时用做调焦距用
             for (int i=0; i<100; i++) {
             if (photoSlider.value<=3.0) {
             photoSlider.value=photoSlider.value+0.001;
             [self changePhotolight];
             }
             }
             
             }
             else{
             [self goVideo];
             }
             }
             else if (appState==UIApplicationStateBackground)
             {
             NSLog(@"程序在后台");
             }
             }
             
             if ([rangeString isEqualToString:@"10"]) {
             NSLog(@"你按了设置/拍照/对码键");
             if (appState==UIApplicationStateActive) {
             NSLog(@"程序在前台");
             if (CamerOpenFinsh==YES) {
             [self takeImage];
             }
             else if (VideoOpenFinsh==YES)
             {
             [self startVideo];
             }
             else
             {
             [self deviceFindIphone];
             }
             }
             else if (appState==UIApplicationStateBackground)
             {
             NSLog(@"程序在后台");
             if (CamerOpenFinsh==YES) {
             [self takeImage];
             }
             else if (VideoOpenFinsh==YES)
             {
             [self startVideo];
             }
             else
             {
             [self deviceFindIphone];
             }
             }
             }
             
             if ([rangeString isEqualToString:@"04"]) {
             NSLog(@"你按了相机键");
             if (appState==UIApplicationStateActive) {
             NSLog(@"程序在前台");
             if (CamerOpenFinsh==YES) {
             //拍照页面已经打开，此时用做调焦距用
             for (int i=0; i<100; i++) {
             if (photoSlider.value>=1.0) {
             photoSlider.value=photoSlider.value-0.001;
             [self changePhotolight];
             }
             }
             }
             else
             {
             [self gotoCamera];
             }
             }
             else if (appState==UIApplicationStateBackground)
             {
             NSLog(@"程序在后台");
             }
             }
             
             if ([rangeString isEqualToString:@"08"]) {
             NSLog(@"你按了镜头切换，一键定位键");
             if (CamerOpenFinsh==YES) {
             [self changeCameraDevice];
             }
             else if (VideoOpenFinsh==YES)
             {
             [self changeVideoDevice];
             }
             else
             {
             [self recordUserLocation];
             }
             }
             
             if ([rangeString isEqualToString:@"01"]) {
             NSLog(@"你按了返回键");
             
             NSLog(@"openPicLibraryIsFinsh=%d",openPicLibraryIsFinsh);
             
             if (CamerOpenFinsh==YES) {
             [self doneAction];
             }
             else if (VideoOpenFinsh==YES){
             [self doneAction];
             }
             else if (isGoSetView==YES && openPicLibraryIsFinsh==NO){
             //                 if (isGoSetView==YES)
             //                {
             //                    [self.navigationController popToRootViewControllerAnimated:YES];
             //                }
             }
             else if (openPicLibraryIsFinsh==YES){
             [self cancleOpenPicLab];
             }
             else{
             [self openPicLibrary];
             }
             }
             
             */
            //还有一个ID_KEY键的值为20，为保留使用
        }
        //电池电量
        if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"2A19"]]){
            
            const unsigned char *hexBytesLight = [characteristic.value bytes];
            NSString *hexString= [NSString stringWithFormat:@"%02x", hexBytesLight[0]];
            int batteryInt;
            sscanf(hexString.UTF8String,"%X",&batteryInt);
            [self showBatteryState:batteryInt];
        }
        //是否报警-K报警
        if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"FFD4"]]){
            const unsigned char *hexBytesLight = [characteristic.value bytes];
            NSString *hexString= [NSString stringWithFormat:@"%02x", hexBytesLight[0]];
            int alermData;
            sscanf(hexString.UTF8String,"%X",&alermData);
            if (alermData==1) {
                if (isAlerm==NO) {
                    if (!setVC) {
                        setVC=[[SetViewController alloc]init];
                    }
                    if (setVC._switchThree.status==CustomSwitchStatusOff) {
                        
                    }
                    else{
                        UIApplicationState appState=[UIApplication sharedApplication].applicationState;
                        if (appState==UIApplicationStateActive) {
                            //创建一个报警时间的指示
                            alermTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(StartAlarmFind) userInfo:nil repeats:YES];
                            //                     [alermTimer fire];
                            isAlerm=YES;
                        }
                        else if (appState==UIApplicationStateBackground){
                            
                            [[NSNotificationCenter defaultCenter]postNotificationName:notiAudioWillPlay object:self userInfo:nil];
                            
                            
                            //程序在后台时候的动作
                            [[UIApplication sharedApplication]cancelAllLocalNotifications];
                            UILocalNotification *notification=[[UILocalNotification alloc] init];
                            if (notification!=nil) {
                                NSDate *now = [NSDate date];
                                //从现在开始，10秒以后通知
                                notification.fireDate=[now dateByAddingTimeInterval:0.1];
                                //使用本地时区
                                notification.timeZone=[NSTimeZone defaultTimeZone];
                                // notification.alertBody=@"外设正在寻找手机";
                                //通知提示音
                                notification.soundName= @"FindMusic.caf";
                                //notification.alertAction=NSLocalizedString(@"你锁屏啦，通知时间到啦", nil);
                                //这个通知到时间时，你的应用程序右上角显示的数字。
                                //notification.applicationIconBadgeNumber = 1;
                                //启动这个通知
                                [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
                            }
                        }
                    }
                }
            }
            else if (alermData==0){
                if ([alermTimer isValid]==TRUE) {
                    [alermTimer invalidate];
                    isAlerm=NO;
                }
            }
        }
    }
}
-(void) getRSSIforDevice: (NSNumber *) DeviceRSSI;
{
    /*该项目中没有使用*/
}

//系统直接关掉蓝牙
-(void) systemCloseblue;
{
    //修改电池电量为空
    [batteryStateImageView setImage:[UIImage imageNamed:@"电池灰.png"]];
    //修改蓝牙连接标志为未连接状态；
    [connectStateImageView setImage:[UIImage imageNamed:@"蓝牙灰.png"]];
    /*
    //判断是否需要断开报警
    if (!setVC) {
        setVC=[[SetViewController alloc]init];
    }
    if (setVC._switchThree.status==CustomSwitchStatusOff) {
        //不用报警   setVC.linkLossSwitch.on==NO || setVC.lostEnableSwitch.on==NO
        
    }
    else{
        //需要报警
        if (deviceFindIphoneState==NO) {
            findIphoneTimer=[NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(alermBycounterLinkLoss) userInfo:nil repeats:YES];
            [findIphoneTimer fire];
            deviceFindIphoneState=YES;
        }
    }
    
    //判断断开连接，当前超过RSSI预设值报警是否有效，有效则关闭超过RSSI预设值报警
    if ([alermTimer isValid]==TRUE) {
        [alermTimer invalidate];
        isAlerm=NO;
    }
     */
}
///////////////////////////////////////

//3s后调用的的方法
-(void)getSendData
{
    if ([repetSendRssiTimer isValid]==TRUE) {
        [repetSendRssiTimer invalidate];
    }
    repetSendRssiTimer=[NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(intervalSenddata) userInfo:nil repeats:YES];
}
//周期给外设发送数据，以便外设读取手机的RSSI
-(void)intervalSenddata
{
    if (blecon._peripheral.state==CBPeripheralStateConnected) {
        for (int i=0; i<blecon._peripheral.services.count; i++) {
            CBService *cbp=[blecon._peripheral.services objectAtIndex:i];
            if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FEA0"]]) {
                for (int j=0; j<cbp.characteristics.count; j++) {
                    CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                    if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FEA1"]]) {
                        [blecon._peripheral setNotifyValue:YES forCharacteristic:cbc];
                        NSString *str=@"00";
                        NSData *PWMdata=[self NSStringToNSData:str];
                        [blecon._peripheral writeValue:PWMdata forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                    }
                }
            }
        }
    }
    else if (blecon._peripheral.state==CBPeripheralStateDisconnected || blecon._peripheral.state==CBPeripheralStateConnecting)
    {
//        NSLog(@"蓝牙没有连接上");
    }
    
//    [self performSelector:@selector(intervalSenddata) withObject:self afterDelay:0.7];
}

//外设找手机
int counterDeviceFindIphone=0;
bool  deviceFindIphoneState=NO;
bool  deviceFindIsAlerm=NO;
-(void)deviceFindIphone
{
    if (deviceFindIsAlerm==NO) {
        if (firstOpen==YES) {
            if (deviceFindIphoneState==NO) {
                UIApplicationState appState=[UIApplication sharedApplication].applicationState;
                if (appState==UIApplicationStateActive) {
                 
                    //程序在前台时候的动作
                    findIphoneTimer=[NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(alermBycounterFind) userInfo:nil repeats:YES];
                    [findIphoneTimer fire];
                    deviceFindIphoneState=YES;
                    deviceFindIsAlerm=YES;

                }
                
                
                else if (appState==UIApplicationStateBackground){
                    //程序在后台时候的动作
                  
                    [[NSNotificationCenter defaultCenter]postNotificationName:notiAudioWillPlay object:self userInfo:nil];
                    
                    [[UIApplication sharedApplication]cancelAllLocalNotifications];
                    UILocalNotification *notification=[[UILocalNotification alloc] init];
                    if (notification!=nil) {
                        NSDate *now = [NSDate date];
                        //从现在开始，10秒以后通知
                        notification.fireDate=[now dateByAddingTimeInterval:0.5];
                        //使用本地时区
                        notification.timeZone=[NSTimeZone defaultTimeZone];
                        //notification.alertBody=@"外设正在寻找手机";
                        //通知提示音 使用默认的
                        notification.soundName= @"FindLong.caf";
                        //notification.alertAction=NSLocalizedString(@"你锁屏啦，通知时间到啦", nil);
                        //这个通知到时间时，你的应用程序右上角显示的数字。
                        //notification.applicationIconBadgeNumber = 1;
                        //启动这个通知
                        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
                    }
                }
              
            }
        }
        else if (firstOpen==NO) {
            if (!setVC) {
                setVC=[[SetViewController alloc]init];
            }
            if ( setVC._switchOne.status==CustomSwitchStatusOn) {
                if (deviceFindIphoneState==NO) {
                    UIApplicationState appState=[UIApplication sharedApplication].applicationState;
                    if (appState==UIApplicationStateActive) {
                        //程序在前台时候的动作
                        
                        findIphoneTimer=[NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(alermBycounterFind) userInfo:nil repeats:YES];
                        [findIphoneTimer fire];
                        deviceFindIphoneState=YES;
                        deviceFindIsAlerm=YES;

                    }
                    
                    else if (appState==UIApplicationStateBackground){
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:notiAudioWillPlay object:self userInfo:nil];
                        
                        //程序在后台时候的动作
                        [[UIApplication sharedApplication]cancelAllLocalNotifications];
                        UILocalNotification *notification=[[UILocalNotification alloc] init];
                        if (notification!=nil) {
                            NSDate *now = [NSDate date];
                            //从现在开始，10秒以后通知
                            notification.fireDate=[now dateByAddingTimeInterval:0.5];
                            //使用本地时区
                            notification.timeZone=[NSTimeZone defaultTimeZone];
                           // notification.alertBody=@"外设正在寻找手机";
                            //通知提示音
                            notification.soundName= @"FindLong.caf";
                            //notification.alertAction=NSLocalizedString(@"你锁屏啦，通知时间到啦", nil);
                            //这个通知到时间时，你的应用程序右上角显示的数字。
                            //notification.applicationIconBadgeNumber = 1;
                            //启动这个通知
                            [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
                        }
                    }
                }
                else if (deviceFindIphoneState==YES){
                    deviceFindIphoneState=NO;
                }
            }
        }
    }
    else if (deviceFindIsAlerm==YES){
        if ([findIphoneTimer isValid]==TRUE) {
            [findIphoneTimer invalidate];
            counterDeviceFindIphone=0;
        }
        //修改了的断线之后不报警的bug，将这一句提出来了：deviceFindIphoneState=NO;
        deviceFindIphoneState=NO;
        deviceFindIsAlerm=NO;
    }
}
-(void)startNotiMusicVC
{
    [[NSNotificationCenter defaultCenter]postNotificationName:notiAudioEndPlay object:self userInfo:nil];
}
-(void)alermBycounterFind
{
    [self StartAlarmFind];
    counterDeviceFindIphone++;
    if (counterDeviceFindIphone>2) {
        if ([findIphoneTimer isValid]==TRUE) {
            [findIphoneTimer invalidate];
            counterDeviceFindIphone=0;
            deviceFindIphoneState=NO;
        }
        deviceFindIsAlerm=NO;
    }
}


-(void)audioPlayEnd
{
    musicVC=[[MusicViewController alloc]init];
    [musicVC.player play];
    [[NSNotificationCenter defaultCenter]postNotificationName:notiAudioEndPlay object:self userInfo:nil];
}
-(void)alermBycounterLinkLoss
{
    [self StartAlarmLinkLoss];
    counterDeviceFindIphone++;
    if (counterDeviceFindIphone>2) {
        if ([findIphoneTimer isValid]==TRUE) {
            [findIphoneTimer invalidate];
            counterDeviceFindIphone=0;
            deviceFindIphoneState=NO;
        }
//    [[NSNotificationCenter defaultCenter]postNotificationName:notiAudioEndPlay object:self userInfo:nil];
    }
}
//NSString转NSData
-(NSData *)NSStringToNSData:(NSString *) aString
{
    int lengthstr=(int)[aString length];
    Byte viewData[lengthstr];
    char index;
    int counterint=0;
    NSString *bString;
    for (index = 0; index < lengthstr; index=index+2,counterint++) {
        bString = [aString substringWithRange:NSMakeRange(index, 2)];
        int a;
        sscanf(bString.UTF8String,"%2X",&a);
        viewData[counterint] =a;
    }
    NSData *ddd = [NSData dataWithBytes:viewData length:lengthstr/2];
    return ddd;
}
//将十六进制数和二进制数进行转换
-(NSString *)getBinaryByhex:(NSString *)hex
{
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"A"];
    
    [hexDic setObject:@"1011" forKey:@"B"];
    
    [hexDic setObject:@"1100" forKey:@"C"];
    
    [hexDic setObject:@"1101" forKey:@"D"];
    
    [hexDic setObject:@"1110" forKey:@"E"];
    
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binaryString=[[NSString alloc] init];
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        //将十六进制数一个一个的截取出来转换为二进制数
        NSString *key = [hex substringWithRange:rage];
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    //NSLog(@"转化后的二进制为:%@",binaryString);
    
    //返回转换之后的二进制数
    return binaryString;
}
//将设备的UUID号转换为字符串类型
-(NSString*)UUIDToString:(CBUUID *)_uuid
{
    const unsigned char *myserBytesHome = [_uuid.data bytes];
    return [NSString stringWithFormat:@"%02x%02x", myserBytesHome[0], myserBytesHome[1]];
}

//播放报警音乐
-(void)StartAlarmFind
{
//    [self playsound:@"FindLK80.wav"];
    [self loadMusic:@"FindLK80" type:@"wav"];
    [_audioPlayer play];
}
-(void)StartAlarmLinkLoss
{
//    [self playsound:@"LinkLossLK.wav"];
    [self loadMusic:@"LinkLossLK" type:@"wav"];
    [_audioPlayer play];
}

//调节报警的音量
-(void)changeAlermVolume:(float)volumes
{
    _audioPlayer.volume=volumes;
}
#pragma mark -
#pragma mark AVAudioPlayerDelegate

-(void)playsound:(NSString *)soundname
{
    NSString *tempstr1=[[NSString alloc]init];
    NSString *tempstr2=[[NSString alloc]init];
    NSRange subrange;
    subrange = [soundname rangeOfString:@".wav"];
    if (subrange.location !=NSNotFound) {
        tempstr1=[soundname substringToIndex:subrange.location];
        tempstr2=[soundname substringFromIndex:subrange.location+1];
    }else{
        return;
    }
    //加载本地的声频文件
    NSURL* system_sound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:tempstr1 ofType:tempstr2]];
    //利用系统声音服务来播放短暂音效（时长30秒以内），并震动：
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //播放指定音效：
    // NSURL *fileURL = [NSURL fileURLWithPath: path isDirectory: NO];
    // 创建音效ID
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge  CFURLRef)(system_sound_url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark-
#pragma mark-首页功能部分按钮调用的方法
-(void)clickLeftButton
{
   
}

-(void)clickRightButton
{
    //检查摄像头是否支持摄像机模式
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagepickerCon.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepickerCon.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        return;
    }
    
    //仅对视频拍摄有效
    imagepickerCon.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
    
    imagepickerCon.videoQuality = UIImagePickerControllerQualityTypeMedium;
    
}

//拍照
- (void)takeImage
{
    if (imagepickerCon.cameraCaptureMode==UIImagePickerControllerCameraCaptureModePhoto) {
        [buttonCam setImage:[UIImage imageNamed:@"拍照时.png"] forState:UIControlStateNormal];
        [imagepickerCon takePicture];
    }
}

//录像
- (void)startVideo
{
    if (videopickerCon.cameraCaptureMode==UIImagePickerControllerCameraCaptureModeVideo) {
        if (startVideoFlag==NO) {
            
            //创建一个录像时间的指示
            videoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
            [videoTimer fire];
            [videopickerCon startVideoCapture];
            [videoButton setImage:[UIImage imageNamed:@"摄像时.png"] forState:UIControlStateNormal];
            startVideoFlag=YES;
            
            
            changeVideoImageTimer=[NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(changeStartVideoImage) userInfo:nil repeats:YES];
            
        }
        else if(startVideoFlag==YES)
        {
            [videopickerCon stopVideoCapture];
            if (videoTimer.isValid==TRUE) {
                [videoTimer invalidate];
                secTimer=0;
                minTimer=0;
                hourTimer=0;
            }
            
            if (changeVideoImageTimer.isValid==TRUE) {
                [changeVideoImageTimer invalidate];
                [videoButton setImage:[UIImage imageNamed:@"摄像前.png"] forState:UIControlStateNormal];
            }
            
            [navigationItemGoVideo setTitle:@"Video"];
            startVideoFlag=NO;
            [videoButton setImage:[UIImage imageNamed:@"摄像前.png"] forState:UIControlStateNormal];
        }
    }
}


//摄像时切换摄像按钮的图标
bool startVideoOn=NO;
-(void)changeStartVideoImage
{
    if (startVideoOn==NO) {
        [videoButton setImage:[UIImage imageNamed:@"摄像前.png"] forState:UIControlStateNormal];
        startVideoOn=YES;
    }
    else if (startVideoOn==YES){
        [videoButton setImage:[UIImage imageNamed:@"摄像时.png"] forState:UIControlStateNormal];
        startVideoOn=NO;
    }
}


//取消照相
- (void)doneAction
{
    [self imagePickerControllerDidCancel:imagepickerCon];
}

//取消摄像
-(void)cancleVideo
{
    [self imagePickerControllerDidCancel:videopickerCon];
    
    if(startVideoFlag==YES)
    {
        [videopickerCon stopVideoCapture];
        if (videoTimer.isValid==TRUE) {
            [videoTimer invalidate];
            secTimer=0;
            minTimer=0;
            hourTimer=0;
        }
        [navigationItemGoVideo setTitle:@"Video"];
        [videoButton setImage:[UIImage imageNamed:@"摄像前.png"] forState:UIControlStateNormal];
        startVideoFlag=NO;
        
        if (changeVideoImageTimer.isValid==TRUE) {
            [changeVideoImageTimer invalidate];
            [videoButton setImage:[UIImage imageNamed:@"摄像前.png"] forState:UIControlStateNormal];
        }
    }
    
    
    //判断一下当前音乐是否正在播放，在播放就得要先恢复播放
    if (!musicVC) {
        musicVC=[[MusicViewController alloc]init];
    }
    if (musicVC.MusicVCisPlaying==YES) {
        [[NSNotificationCenter defaultCenter ]postNotificationName:notiAudioEndPlay object:nil];
    }
}
//取消打开相册
-(void)cancleOpenPicLab
{
    [self imagePickerControllerDidCancel:pickerPicLibrary];
    
}
//切换拍照模式下的镜头
- (void)changeCameraDevice
{
    if (imagepickerCon.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            imagepickerCon.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            [leftButtonCamera setImage:[UIImage imageNamed:@"闪关灯关.png"]];
            leftButtonCamera.enabled=NO;
            flashBtnTouchCounter=1;
        }
    }
    else {
        imagepickerCon.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [imagepickerCon setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
        [leftButtonCamera setImage:[UIImage imageNamed:@"闪关灯自动.png"]];
        leftButtonCamera.enabled=YES;
        flashBtnTouchCounter=0;
    }
}

//切换摄像模式下的镜头
- (void)changeVideoDevice
{
    if (videopickerCon.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            videopickerCon.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            [leftButtonVideo setImage:[UIImage imageNamed:@"闪关灯关.png"]];
            leftButtonVideo.enabled=NO;
        }
    }
    else {
        videopickerCon.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [videopickerCon setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
        [leftButtonVideo setImage:[UIImage imageNamed:@"闪关灯自动.png"]];
        leftButtonVideo.enabled=YES;
        flashBtnTouchCounter=0;
    }
}

int flashBtnTouchCounter=0;
//照片时弹出闪光灯选择
- (void)pushButton:(UIButton *)sender
{
    //    UIImagePickerControllerCameraFlashModeOff  = -1,
    //    UIImagePickerControllerCameraFlashModeAuto = 0,
    //    UIImagePickerControllerCameraFlashModeOn   = 1
    if (imagepickerCon.cameraDevice==UIImagePickerControllerCameraDeviceFront) {
        leftButtonCamera.enabled=NO;
    }
    else
    {
        leftButtonCamera.enabled=YES;
        if (flashBtnTouchCounter==0) {
            [imagepickerCon setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
            flashBtnTouchCounter++;
            [leftButtonCamera setImage:[UIImage imageNamed:@"闪关灯关.png"]];
        }
        else if (flashBtnTouchCounter==1) {
            [imagepickerCon setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
            flashBtnTouchCounter++;
            [leftButtonCamera setImage:[UIImage imageNamed:@"闪关灯开.png"]];
        }
        else if (flashBtnTouchCounter==2) {
            [imagepickerCon setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
            flashBtnTouchCounter=0;
            [leftButtonCamera setImage:[UIImage imageNamed:@"闪关灯自动.png"]];
        }
    }
}

int videoflashcounter=0;
//摄像时弹出闪光灯选择
-(void)videoFalshModes
{
    if (videoflashcounter==0) {
        [videopickerCon setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
        videoflashcounter++;
        [leftButtonVideo setImage:[UIImage imageNamed:@"闪关灯关.png"]];
    }
    else if (videoflashcounter==1) {
        [videopickerCon setCameraFlashMode:UIImagePickerControllerCameraFlashModeOn];
        videoflashcounter++;
        [leftButtonVideo setImage:[UIImage imageNamed:@"闪关灯开.png"]];
    }
    else if (videoflashcounter==2) {
        [videopickerCon setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
        videoflashcounter=0;
        [leftButtonVideo setImage:[UIImage imageNamed:@"闪关灯自动.png"]];
    }
    
}
//打开拍照页面
-(void)takePicketure
{
    if (cameraIsOnHome==false) {
        
        CamerOpenFinsh=YES;
        [self presentViewController:imagepickerCon animated:YES completion:^{
            cameraIsOnHome=true;
        }];
    }
}
//打开录像页面
-(void)takeVideo
{
    if (cameraIsOnHome==false) {
        
        //判断一下当前音乐是否正在播放，在播放就得要先暂停播放
        if (!musicVC) {
            musicVC=[[MusicViewController alloc]init];
        }
        if (musicVC.MusicVCisPlaying==YES) {
            [[NSNotificationCenter defaultCenter ]postNotificationName:@"willStartVideo" object:nil];
        }
        
        
        VideoOpenFinsh=YES;
        [self presentViewController:videopickerCon animated:YES completion:^{
            cameraIsOnHome=true;
        }];
    }
}

//相册打开
bool openPicLibraryIsFinsh=NO;
-(void)openPicLibrary
{
    //相册是可以用模拟器打开的
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerPicLibrary = [[UIImagePickerController alloc]init];
        pickerPicLibrary.allowsEditing = YES;//是否可以编辑
//        pickerPicLibrary.delegate=self;
        //打开相册选择照片
        pickerPicLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:pickerPicLibrary animated:YES completion:^{}];
        openPicLibraryIsFinsh=YES;
        
    }else{
    }
}

//打开音乐播放器
-(void)openMusic
{
    openPicLibraryIsFinsh=YES;
    isMusicOpen=YES;
//    musicVC=[[MusicViewController alloc]init];
    if (!musicVC) {
        musicVC=[[MusicViewController alloc]init];
    }
    
//    [self.navigationController pushViewController:musicVC animated:YES];
    [self presentViewController:musicVC animated:YES completion:^{}];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
//显示外设电池电量状态
-(void)showBatteryState :(int)batteryState
{
    
    NSDictionary *dictionary;
    if (themIndex==0) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"setImageDefault" ofType:@"plist"];
        dictionary= [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    else if (themIndex==1) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"setImageOragne" ofType:@"plist"];
         dictionary= [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    else if (themIndex==2){
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"setImageGreen" ofType:@"plist"];
        dictionary= [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    else if (themIndex==3){
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"setImagePurple" ofType:@"plist"];
        dictionary= [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    
    if (batteryState>80) {
        //满电
        [batteryStateImageView setImage:[UIImage imageNamed:[dictionary objectForKey:@"05"]]];
    }
    else if (batteryState<=80 && batteryState>60){
        //两格电
        [batteryStateImageView setImage:[UIImage imageNamed:[dictionary objectForKey:@"06"]]];
    }
    else if (batteryState<=60 && batteryState>40){
        //一格电
       [batteryStateImageView setImage:[UIImage imageNamed:[dictionary objectForKey:@"07"]]];
    }
    else if (batteryState<=40 && batteryState>0){
        //一格电报警红色
        [batteryStateImageView setImage:[UIImage imageNamed:@"电池红.png"]];
    }
}
- (NSString *) updateTime
{
    secTimer++;
    if (secTimer>=60) {
        minTimer++;
        secTimer=0;
    }
    if (minTimer>=60) {
        hourTimer++;
        minTimer=0;
    }
    videoTimerStr = [NSString stringWithFormat:@"%02d:%02d:%02d",hourTimer,minTimer,secTimer];

    //设置导航栏内容
    [navigationItemGoVideo setTitle:videoTimerStr];
    
    return videoTimerStr;
}
#pragma mark-
#pragma mark-Imagepickerdelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0);
{
 
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        cameraIsOnHome=NO;
        CamerOpenFinsh=NO;
        VideoOpenFinsh=NO;
        openPicLibraryIsFinsh=NO;
    }];
    
    
    //判断一下当前音乐是否正在播放，在播放就得要先恢复播放
    if (!musicVC) {
        musicVC=[[MusicViewController alloc]init];
    }
    if (musicVC.MusicVCisPlaying==YES) {
        [[NSNotificationCenter defaultCenter ]postNotificationName:notiAudioEndPlay object:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	
	if([mediaType isEqualToString:@"public.movie"])			//被选中的是视频
	{
		NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        
		//保存视频到相册
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:nil];
        
		//获取视频的某一帧作为预览
        [self getPreViewImg:url];
	}
	else if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *Oriimage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *newImage;
        
        if ( imagepickerCon.cameraDevice==UIImagePickerControllerCameraDeviceFront) {
            //前置摄像头
            if ( photoSlider.value>1.1 && photoSlider.value<1.5) {
                CGRect imageRect=CGRectMake(50, 50, 1200, 900);
                newImage=[self getImageFromImage:Oriimage subImageSize:imageRect.size subImageRect:imageRect];
            }
            else if (photoSlider.value>=1.5 && photoSlider.value<2.0)
            {
                CGRect imageRect=CGRectMake(120, 120, 1000, 700);
                newImage=[self getImageFromImage:Oriimage subImageSize:imageRect.size subImageRect:imageRect];
            }
            else if (photoSlider.value>=2.0 && photoSlider.value<=2.5)
            {
                CGRect imageRect=CGRectMake(350, 250, 650, 460);
                newImage=[self getImageFromImage:Oriimage subImageSize:imageRect.size subImageRect:imageRect];
            }
            else
            {
                newImage=Oriimage;
            }
        }
        else{
            //后置摄像头
            if ( photoSlider.value>1.1 && photoSlider.value<1.5) {
                
//                CGRect imageRect=CGRectMake(200, 100, Oriimage.size.width-200 , Oriimage.size.height-100);
                CGRect imageRect=CGRectMake(200, 300, 2592-400 , 1963-600);
                newImage=[self getImageFromImage:Oriimage subImageSize:imageRect.size subImageRect:imageRect];
            }
            else if (photoSlider.value>=1.5 && photoSlider.value<2.0)
            {
                
//                CGRect imageRect=CGRectMake(250, 200, Oriimage.size.width-200 , Oriimage.size.height-400);
                CGRect imageRect=CGRectMake(350, 400, 2592-700 , 1963-800);
                newImage=[self getImageFromImage:Oriimage subImageSize:imageRect.size subImageRect:imageRect];
            }
            else if (photoSlider.value>=2.0 && photoSlider.value<=2.5)
            {
//                CGRect imageRect=CGRectMake(400, 400, Oriimage.size.width-800 , Oriimage.size.height-1400);
                 CGRect imageRect=CGRectMake(750, 600, 2592-1500 , 1963-1200);
                newImage=[self getImageFromImage:Oriimage subImageSize:imageRect.size subImageRect:imageRect];
            }
            else
            {
                newImage=Oriimage;
            }
        }
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[newImage CGImage]
                                  orientation:ALAssetOrientationRight
                              completionBlock:nil];
//        [cameraButton setImage:[UIImage imageNamed:@"08.png"] forState:UIControlStateNormal];
        [buttonCam setImage:[UIImage imageNamed:@"拍照前.png"] forState:UIControlStateNormal];
	}
	else
	{
		return;
	}
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//图片裁剪
-(UIImage *)getImageFromImage:(UIImage*) superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect {
    //    CGSize subImageSize = CGSizeMake(WIDTH, HEIGHT); //定义裁剪的区域相对于原图片的位置
    //    CGRect subImageRect = CGRectMake(START_X, START_Y, WIDTH, HEIGHT);
    CGImageRef imageRef = superImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext(); //返回裁剪的部分图像
    return returnImage;
}

#pragma mark -
#pragma mark userFunc

-(void)getPreViewImg:(NSURL *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    //    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    //    [self performSelector:@selector(saveImg:) withObject:img afterDelay:0.1];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
