//
//  SetViewController.m
//  compxLostFind
//
//  Created by Compx on 14-5-2.
//  Copyright (c) 2014年 compx.com.cn. All rights reserved.
//

#import "SetViewController.h"
#import "CustomSwitch.h"


@interface SetViewController ()

@end

@implementation SetViewController
@synthesize mapBtn;

/*
@synthesize linkLossSwitch;
@synthesize rangeSwitch;
@synthesize lostEnableSwitch;
@synthesize mapLocationEnableSwitch;
@synthesize findKeyFinderBtn;
@synthesize mapLocationEnableSwitchState;


@synthesize linkLossST;
@synthesize rangeST;
@synthesize lostEnableST;
@synthesize mapLocationEnableST;
*/
@synthesize _switchOne;
@synthesize _switchTwo;
@synthesize _switchThree;
@synthesize _switchFour;

@synthesize LossProofLab;@synthesize RangeLab;
@synthesize OutOffRangeLab;@synthesize LocatorLab;
@synthesize MapLocationLab;

@synthesize sliderVolume;

@synthesize defaultThemBtn;
@synthesize orangeBtn;
@synthesize greenBtn;
@synthesize purpleBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bleController=[BLEController getInstance];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //对相关的Lable进行国际化
    LossProofLab.font=[UIFont boldSystemFontOfSize:18.0];
    LossProofLab.text=NSLocalizedString(@"Loss-Proof", nil);
    RangeLab.font=[UIFont boldSystemFontOfSize:18.0];
    RangeLab.text=NSLocalizedString(@"Range", nil);
    OutOffRangeLab.font=[UIFont boldSystemFontOfSize:18.0];
    OutOffRangeLab.text=NSLocalizedString(@"Outoff-Range", nil);
    LocatorLab.font=[UIFont boldSystemFontOfSize:18.0];
    LocatorLab.text=NSLocalizedString(@"Locator", nil);
    MapLocationLab.font=[UIFont boldSystemFontOfSize:18.0];
    MapLocationLab.text=NSLocalizedString(@"Map-Location", nil);
    
    
    //音量左轨的图片
    UIImage *stetchLeftTrack;
    //喇叭初始化
    labaView=[[UIImageView alloc]initWithFrame:CGRectMake(35,255,30,30)];

    //四个切换主题的按钮初始化
    if (iPhone5) {
        defaultThemBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        defaultThemBtn.frame=CGRectMake(32, self.view.bounds.size.height-160, 40, 35);
        [defaultThemBtn setImage:[UIImage imageNamed:@"蓝绿色图标.png"] forState:UIControlStateNormal];
        [self.view addSubview:defaultThemBtn];
        
        
        orangeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        orangeBtn.frame=CGRectMake(104, self.view.bounds.size.height-160, 40, 35);
        [orangeBtn setImage:[UIImage imageNamed:@"橙色图标.png"] forState:UIControlStateNormal];
        [self.view addSubview:orangeBtn];
        
        
        greenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        greenBtn.frame=CGRectMake(176, self.view.bounds.size.height-160, 40, 35);
        [greenBtn setImage:[UIImage imageNamed:@"绿色图标.png"] forState:UIControlStateNormal];
        [self.view addSubview:greenBtn];
        
        
        purpleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        purpleBtn.frame=CGRectMake(248, self.view.bounds.size.height-160, 40, 35);
        [purpleBtn setImage:[UIImage imageNamed:@"紫色图标.png"] forState:UIControlStateNormal];
        [self.view addSubview:purpleBtn];
    }
    else
    {
        defaultThemBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        defaultThemBtn.frame=CGRectMake(32, self.view.bounds.size.height-180, 40, 35);
        [defaultThemBtn setImage:[UIImage imageNamed:@"蓝绿色图标.png"] forState:UIControlStateNormal];
        [self.view addSubview:defaultThemBtn];
        
        
        orangeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        orangeBtn.frame=CGRectMake(104, self.view.bounds.size.height-180, 40, 35);
        [orangeBtn setImage:[UIImage imageNamed:@"橙色图标.png"] forState:UIControlStateNormal];
        [self.view addSubview:orangeBtn];
        
        
        greenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        greenBtn.frame=CGRectMake(176, self.view.bounds.size.height-180, 40, 35);
        [greenBtn setImage:[UIImage imageNamed:@"绿色图标.png"] forState:UIControlStateNormal];
        [self.view addSubview:greenBtn];
        
        
        purpleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        purpleBtn.frame=CGRectMake(248, self.view.bounds.size.height-180, 40, 35);
        [purpleBtn setImage:[UIImage imageNamed:@"紫色图标.png"] forState:UIControlStateNormal];
        [self.view addSubview:purpleBtn];
    }

    
    //查看用户之前保存的主题设置
    NSUserDefaults *defaultThem=[NSUserDefaults standardUserDefaults];
    NSString *them=[defaultThem stringForKey:@"e2Them"];
    
    
    labaView.image=[UIImage imageNamed:@"音量灰.png"];
    
//    if ([them isEqualToString:@"default"]) {
//        
//    }
    if ([them isEqualToString:@"orange"]){
        
        [orangeBtn setImage:[UIImage imageNamed:@"橙色图标按下.png"] forState:UIControlStateNormal];
        _switchOne.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
        _switchOne.onImage = [UIImage imageNamed:@"On橙色.png"];
        _switchTwo.onImage = [UIImage imageNamed:@"Near橙色.png"];
        _switchTwo.offImage = [UIImage imageNamed:@"Far橙色.png"];
        _switchThree.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
        _switchThree.onImage = [UIImage imageNamed:@"On橙色.png"];
        _switchFour.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
        _switchFour.onImage = [UIImage imageNamed:@"On橙色.png"];
//        labaView.image=[UIImage imageNamed:@"喇叭橙色.png"];
//        stetchLeftTrack= [UIImage imageNamed:@"音量条橙色.png"];
        
    }
    
    else if ([them isEqualToString:@"green"]){
        [greenBtn setImage:[UIImage imageNamed:@"绿色图标按下.png"] forState:UIControlStateNormal];
        
        _switchOne.offImage = [UIImage imageNamed:@"OFF灰绿色.png"];
        _switchOne.onImage = [UIImage imageNamed:@"On绿色.png"];
        _switchTwo.onImage = [UIImage imageNamed:@"Near绿色.png"];
        _switchTwo.offImage = [UIImage imageNamed:@"Far绿色.png"];
        _switchThree.offImage = [UIImage imageNamed:@"OFF灰绿色.png"];
        _switchThree.onImage = [UIImage imageNamed:@"On绿色.png"];
        _switchFour.offImage = [UIImage imageNamed:@"OFF灰绿色.png"];
        _switchFour.onImage = [UIImage imageNamed:@"On绿色.png"];
//        labaView.image=[UIImage imageNamed:@"喇叭绿色.png"];
//        stetchLeftTrack= [UIImage imageNamed:@"音量条绿色.png"];

    }
    else if ([them isEqualToString:@"purple"])
    {
        [purpleBtn setImage:[UIImage imageNamed:@"紫色图标按下.png"] forState:UIControlStateNormal];
        _switchOne.offImage = [UIImage imageNamed:@"OFF灰紫色.png"];
        _switchOne.onImage = [UIImage imageNamed:@"On紫色.png"];
        _switchTwo.onImage = [UIImage imageNamed:@"Near紫色.png"];
        _switchTwo.offImage = [UIImage imageNamed:@"Far紫色.png"];
        _switchThree.offImage = [UIImage imageNamed:@"OFF灰紫色.png"];
        _switchThree.onImage = [UIImage imageNamed:@"On紫色.png"];
        _switchFour.offImage = [UIImage imageNamed:@"OFF灰紫色.png"];
        _switchFour.onImage = [UIImage imageNamed:@"On紫色.png"];
//        labaView.image=[UIImage imageNamed:@"喇叭紫色.png"];
//        stetchLeftTrack= [UIImage imageNamed:@"音量条紫色.png"];
    }
    else{
        [defaultThemBtn setImage:[UIImage imageNamed:@"蓝绿色图标按下.png"] forState:UIControlStateNormal];
        
        _switchOne.onImage = [UIImage imageNamed:@"ON蓝绿.png"];
        _switchOne.offImage = [UIImage imageNamed:@"OFF灰.png"];
        _switchTwo.onImage = [UIImage imageNamed:@"NEAR蓝绿条80.png"];
        _switchTwo.offImage = [UIImage imageNamed:@"蓝绿FAR.png"];
        _switchThree.onImage = [UIImage imageNamed:@"ON蓝绿.png"];
        _switchThree.offImage = [UIImage imageNamed:@"OFF灰.png"];
        _switchFour.onImage = [UIImage imageNamed:@"ON蓝绿.png"];
        _switchFour.offImage = [UIImage imageNamed:@"OFF灰.png"];
//        labaView.image=[UIImage imageNamed:@"喇叭蓝绿.png"];
//        stetchLeftTrack= [UIImage imageNamed:@"音量条蓝.png"];
    }
    //防丢使能按钮－－改成外设找手机，手机找外设的使能按钮
    _switchOne.arrange = CustomSwitchArrangeONLeftOFFRight;
   
    _switchOne.status = CustomSwitchStatusOn;
    _switchOne.delegate=self;
     [_switchOne addTarget:self action:@selector(lostEnableSwitchChangeState) forControlEvents:UIControlEventValueChanged];
    
    
    //距离调节按钮
    _switchTwo.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchTwo.status = CustomSwitchStatusOff;
    [_switchTwo addTarget:self action:@selector(rangeSwitchChangeState) forControlEvents:UIControlEventValueChanged];
    
    //关闭断线报警
    _switchThree.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchThree.status = CustomSwitchStatusOn;
    [_switchThree addTarget:self action:@selector(linkLostSwitchChangeState) forControlEvents:UIControlEventValueChanged];
    
    //地图定位按钮
    _switchFour.arrange = CustomSwitchArrangeONLeftOFFRight;
   
    _switchFour.status = CustomSwitchStatusOn;
    [_switchFour addTarget:self action:@selector(mapLocationChangeState) forControlEvents:UIControlEventValueChanged];
    
    /*
    
    // Example of a bigger switch with images
    lostEnableST = [[SevenSwitch alloc] initWithFrame:CGRectMake(230, 82, 61, 31)];
    [lostEnableST addTarget:self action:@selector(lostEnableSwitchChangeState) forControlEvents:UIControlEventValueChanged];
    lostEnableST.offImage = [UIImage imageNamed:@"OFF1.png"];
    lostEnableST.onImage = [UIImage imageNamed:@"ON1.png"];
    lostEnableST.onColor = [UIColor colorWithHue:0.53  saturation:0.8 brightness:0.70 alpha:1.00f];
    lostEnableST.isRounded = NO;
    lostEnableST.knobColor=[UIColor colorWithRed:245 green:245 blue:245 alpha:1.0];
//    [self.view addSubview:lostEnableST];
    [lostEnableST setOn:YES animated:YES];
    
    
    rangeST = [[SevenSwitch alloc] initWithFrame:CGRectMake(230, 140, 61, 31)];
    [rangeST addTarget:self action:@selector(rangeSwitchChangeState) forControlEvents:UIControlEventValueChanged];
    rangeST.offImage = [UIImage imageNamed:@"FAR35.png"];
    rangeST.onImage = [UIImage imageNamed:@"NEAR35.png"];
    rangeST.onColor = [UIColor colorWithHue:0.53  saturation:0.8 brightness:0.70 alpha:1.00f];
    rangeST.isRounded = NO;
    rangeST.knobColor=[UIColor colorWithRed:245 green:245 blue:245 alpha:1.0];
//    [self.view addSubview:rangeST];
    [rangeST setOn:NO animated:YES];
    
    
    linkLossST = [[SevenSwitch alloc] initWithFrame:CGRectMake(230, 186, 61, 31)];
    [linkLossST addTarget:self action:@selector(linkLostSwitchChangeState) forControlEvents:UIControlEventValueChanged];
    linkLossST.offImage = [UIImage imageNamed:@"SwitchOFF35.png"];
    linkLossST.onImage = [UIImage imageNamed:@"SwitchON35.png"];
    linkLossST.onColor = [UIColor colorWithHue:0.53  saturation:0.8 brightness:0.70 alpha:1.00f];
    linkLossST.isRounded = NO;
    linkLossST.knobColor=[UIColor colorWithRed:245 green:245 blue:245 alpha:1.0];
//    [self.view addSubview:linkLossST];
    [linkLossST setOn:YES animated:YES];

    
    mapLocationEnableST = [[SevenSwitch alloc] initWithFrame:CGRectMake(230, 325, 61, 31)];
    [mapLocationEnableST addTarget:self action:@selector(mapLocationChangeState) forControlEvents:UIControlEventValueChanged];
    mapLocationEnableST.offImage = [UIImage imageNamed:@"SwitchOFF35.png"];
    mapLocationEnableST.onImage = [UIImage imageNamed:@"SwitchON35.png"];
    mapLocationEnableST.onColor = [UIColor colorWithHue:0.53  saturation:0.8 brightness:0.70 alpha:1.00f];
    mapLocationEnableST.isRounded = NO;
    mapLocationEnableST.knobColor=[UIColor colorWithRed:245 green:245 blue:245 alpha:1.0];
//    [self.view addSubview:mapLocationEnableST];
    [mapLocationEnableST setOn:NO animated:YES];
    
    
    
    [lostEnableSwitch addTarget:self action:@selector(lostEnableSwitchChangeState) forControlEvents:UIControlEventValueChanged];
    [rangeSwitch addTarget:self action:@selector(rangeSwitchChangeState) forControlEvents:UIControlEventValueChanged];
    [linkLossSwitch addTarget:self action:@selector(linkLostSwitchChangeState) forControlEvents:UIControlEventValueChanged];
    
    [mapLocationEnableSwitch addTarget:self action:@selector(mapLocationChangeState) forControlEvents:UIControlEventValueChanged];
     */
//    [findKeyFinderBtn addTarget:self action:@selector(findKeyTouchDown) forControlEvents:UIControlEventTouchUpInside];
    
    [mapBtn addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];
    
    [self judeLocationIsOn];
    
    //版本号
    if (iPhone5) {
        UILabel *versionInfo=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-75, self.view.bounds.size.height-80, 150, 50)];
        versionInfo.textColor=[UIColor darkGrayColor];
        versionInfo.text=@"E-2 version 1.1";
        versionInfo.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:versionInfo];
    }
    else{
        UILabel *versionInfo=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-75, self.view.bounds.size.height-135, 150, 50)];
        versionInfo.textColor=[UIColor darkGrayColor];
        versionInfo.text=@"E-2 version 1.1";
        versionInfo.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:versionInfo];
    }
    
    //添加喇叭到视图
//    labaView.image=[UIImage imageNamed:@"喇叭蓝绿.png"];
    [self.view addSubview:labaView];
    
    //音量右轨的图片
//    UIImage *stetchLeftTrack= [UIImage imageNamed:@"音量条蓝.png"];
    stetchLeftTrack= [UIImage imageNamed:@"音量条灰色.png"];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"音量条灰.png"];
    //滑块图片
    UIImage *thumbImage = [UIImage imageNamed:@"圆圈.png"];
    
    sliderVolume=[[UISlider alloc]initWithFrame:CGRectMake(70, 265, 215, 10)];
    sliderVolume.backgroundColor = [UIColor clearColor];
    sliderVolume.value=1.0;
    sliderVolume.minimumValue=0.0;
    sliderVolume.maximumValue=1.0;
    
    [sliderVolume setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [sliderVolume setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [sliderVolume setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [sliderVolume setThumbImage:thumbImage forState:UIControlStateNormal];
    //滑块拖动时的事件
    [sliderVolume addTarget:self action:@selector(volumeSet:) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    //    [sliderA addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sliderVolume];
    
    
    //切换主题的按钮
    [defaultThemBtn addTarget:self action:@selector(changeThemToDefault) forControlEvents:UIControlEventTouchUpInside];
    [orangeBtn addTarget:self action:@selector(changThemToOrange) forControlEvents:UIControlEventTouchUpInside];
    [greenBtn addTarget:self action:@selector(changThemToGreen) forControlEvents:UIControlEventTouchUpInside];
    [purpleBtn addTarget:self action:@selector(changThemToPurple) forControlEvents:UIControlEventTouchUpInside];
    
    
    //监听主题变化的通知
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeThemToDefaultSetVC) name:themChangeToDefault object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeThemToOrangeSetVC) name:themChangeToOrange object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeThemToGreenSetVC) name:themChangeToGreen object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeThemToPurpleSetVC) name:themChangeToPurple object:nil];
    
}


- (id)init {
    self = [super init];
    if (self) {
        _switchOne.status = CustomSwitchStatusOn;
        _switchThree.status = CustomSwitchStatusOn; 
        _switchFour.status = CustomSwitchStatusOn;
        sliderVolume=[[UISlider alloc]init];
        sliderVolume.value=1.0;
        
        /*
        
        lostEnableST = [[SevenSwitch alloc] initWithFrame:CGRectMake(230, 82, 61, 31)];
        lostEnableST.on=YES;
        linkLossST = [[SevenSwitch alloc] initWithFrame:CGRectMake(230, 186, 61, 31)];
        linkLossST.on=YES;
         */
    }
    return self;
}

#pragma mark - customSwitch delegate
-(void)customSwitchSetStatus:(CustomSwitchStatus)status
{
    switch (status) {
        case CustomSwitchStatusOn:
            //todo
         
            break;
        case CustomSwitchStatusOff:
            //todo
            break;
        default:
            break;
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self judeLocationIsOn];
}



-(void)orangeColor
{
    _switchOne.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchOne.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
    _switchOne.onImage = [UIImage imageNamed:@"On橙色.png"];
    [_switchOne setNeedsDisplay];
    
    _switchTwo.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchTwo.offImage = [UIImage imageNamed:@"Far橙色.png"];
    _switchTwo.onImage = [UIImage imageNamed:@"Near橙色.png"];
    [_switchTwo setNeedsDisplay];
    
    //关闭断线报警
    _switchThree.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchThree.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
    _switchThree.onImage = [UIImage imageNamed:@"On橙色.png"];
    
    [_switchThree setNeedsDisplay];
    //地图定位按钮
    
    _switchFour.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchFour.onImage = [UIImage imageNamed:@"On橙色.png"];
    _switchFour.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
    [_switchFour setNeedsDisplay];
    
//    [self.view becomeFirstResponder];
//    [self.view awakeFromNib];
  
}



//音量设置
bool isAfterTime=YES;
-(void)volumeSet:(UISlider*)slider
{
    NSString *strVolume=[NSString stringWithFormat:@"%f",slider.value];
    [[NSNotificationCenter defaultCenter]postNotificationName:notifictionVolume object:strVolume];
    
    //播放一次音乐来给用户试听音量的大小，并且1.2秒之内不能重复播放
    if (isAfterTime==YES) {
        [self loadMusic:@"FindLK80" type:@"wav"];
        [audioPlayer play];
        [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(timeIsOk) userInfo:nil repeats:NO];
        isAfterTime=NO;
    }
}
-(void)timeIsOk
{
    isAfterTime=YES;
}


#pragma mark-
#pragma mark-开关按钮值改变时调用的方法
- (void)switchChanged:(SevenSwitch *)sender {
   // NSLog(@"Changed value to: %@", sender.on ? @"ON" : @"OFF");
}

-(void)lostEnableSwitchChangeState
{
    if (_switchOne.status==CustomSwitchStatusOn) {
        
    }else if (_switchOne.status==CustomSwitchStatusOff){
        
    }
    
    
    if (_switchOne.status==CustomSwitchStatusOn) {
        
        //此时接收到报警信号时需要报警
        if (bleController._peripheral.state==CBPeripheralStateConnected) {
            for (int i=0; i<bleController._peripheral.services.count; i++) {
                CBService *cbp=[bleController._peripheral.services objectAtIndex:i];
                if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFD0"]]) {
                    for (int j=0; j<cbp.characteristics.count; j++) {
                        CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                        if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFD6"]]) {
                            NSString *str=@"00";
                            NSData *PWMdata=[self NSStringToNSData:str];
                            [bleController._peripheral writeValue:PWMdata forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                        }
                    }
                }
            }
        }
        else if (bleController._peripheral.state==CBPeripheralStateDisconnected  || bleController._peripheral.state==CBPeripheralStateConnecting)
        {
            //NSLog(@"蓝牙没有连接上");
        }
    }
    else if (_switchOne.status==CustomSwitchStatusOff){

        //此时接收到报警信号也不用报警
        if (bleController._peripheral.state==CBPeripheralStateConnected) {
            for (int i=0; i<bleController._peripheral.services.count; i++) {
                CBService *cbp=[bleController._peripheral.services objectAtIndex:i];
                if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFD0"]]) {
                    for (int j=0; j<cbp.characteristics.count; j++) {
                        CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                        if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFD6"]]) {
                            NSString *str=@"01";
                            NSData *PWMdata=[self NSStringToNSData:str];
                            [bleController._peripheral writeValue:PWMdata forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                        }
                    }
                }
            }
        }
        else if (bleController._peripheral.state==CBPeripheralStateDisconnected  || bleController._peripheral.state==CBPeripheralStateConnecting)
        {
           //NSLog(@"蓝牙没有连接上");
        }
    }

    [[NSNotificationCenter defaultCenter]postNotificationName:notifictionStr object:nil];
}
-(void)rangeSwitchChangeState
{
    //默认是远距离报警，发送值－－00
    //rangeSwitch.on==YES代表:Near
    if (_switchTwo.status==CustomSwitchStatusOn) {
        //此时应该告诉外设我是近距离时就要报警-－－发01
        if (bleController._peripheral.state==CBPeripheralStateConnected) {
            for (int i=0; i<bleController._peripheral.services.count; i++) {
                CBService *cbp=[bleController._peripheral.services objectAtIndex:i];
                if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFD0"]]) {
                    for (int j=0; j<cbp.characteristics.count; j++) {
                        CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                        if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFD5"]]) {
                            NSString *str=@"01";
                            NSData *PWMdata=[self NSStringToNSData:str];
                            [bleController._peripheral writeValue:PWMdata forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                        }
                    }
                }
            }
        }
        else if (bleController._peripheral.state==CBPeripheralStateDisconnected  || bleController._peripheral.state==CBPeripheralStateConnecting)
        {
            //NSLog(@"蓝牙没有连接上");
        }
        
    }
    else if (_switchTwo.status==CustomSwitchStatusOff){
        //此时应该告诉外设我是远距离时要报警
        if (bleController._peripheral.state==CBPeripheralStateConnected) {
            for (int i=0; i<bleController._peripheral.services.count; i++) {
                CBService *cbp=[bleController._peripheral.services objectAtIndex:i];
                if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFD0"]]) {
                    for (int j=0; j<cbp.characteristics.count; j++) {
                        CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                        if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFD5"]]) {
                            NSString *str=@"00";
                            NSData *PWMdata=[self NSStringToNSData:str];
                            [bleController._peripheral writeValue:PWMdata forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                        }
                    }
                }
            }
        }
        else if (bleController._peripheral.state==CBPeripheralStateDisconnected  || bleController._peripheral.state==CBPeripheralStateConnecting)
        {
            //NSLog(@"蓝牙没有连接上");
        }

    }
    [[NSNotificationCenter defaultCenter]postNotificationName:notifictionStr object:nil];
}
-(void)linkLostSwitchChangeState
{
    if (_switchThree.status==CustomSwitchStatusOn) {
        //此时接收到报警信号时需要报警
        if (bleController._peripheral.state==CBPeripheralStateConnected) {
            for (int i=0; i<bleController._peripheral.services.count; i++) {
                CBService *cbp=[bleController._peripheral.services objectAtIndex:i];
                if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFD0"]]) {
                    for (int j=0; j<cbp.characteristics.count; j++) {
                        CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                        if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFD6"]]) {
                            NSString *str=@"00";
                            NSData *PWMdata=[self NSStringToNSData:str];
                            [bleController._peripheral writeValue:PWMdata forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                        }
                    }
                }
            }
        }
        else if (bleController._peripheral.state==CBPeripheralStateDisconnected  || bleController._peripheral.state==CBPeripheralStateConnecting)
        {
            //NSLog(@"蓝牙没有连接上");
        }

    }
    else if (_switchThree.status==CustomSwitchStatusOff){
        //此时接收到报警信号也不用报警
        if (bleController._peripheral.state==CBPeripheralStateConnected) {
            for (int i=0; i<bleController._peripheral.services.count; i++) {
                CBService *cbp=[bleController._peripheral.services objectAtIndex:i];
                if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFD0"]]) {
                    for (int j=0; j<cbp.characteristics.count; j++) {
                        CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                        if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFD6"]]) {
                            NSString *str=@"01";
                            NSData *PWMdata=[self NSStringToNSData:str];
                            [bleController._peripheral writeValue:PWMdata forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                        }
                    }
                }
            }
        }
        else if (bleController._peripheral.state==CBPeripheralStateDisconnected  || bleController._peripheral.state==CBPeripheralStateConnecting)
        {
           // NSLog(@"蓝牙没有连接上");
        }

    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:notifictionStr object:nil];
}
/*
bool  findKeyIsTouchDown=YES;
-(void)findKeyTouchDown
{
    //发送一个值让外设报警
    
    if (bleController._peripheral.state==CBPeripheralStateConnected) {
        for (int i=0; i<bleController._peripheral.services.count; i++) {
            CBService *cbp=[bleController._peripheral.services objectAtIndex:i];
            if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFD0"]]) {
                for (int j=0; j<cbp.characteristics.count; j++) {
                    CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                    if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFD1"]]) {
                        
                        [bleController._peripheral setNotifyValue:YES forCharacteristic:cbc];
                        NSString *str;
                        if (findKeyIsTouchDown==YES) {
                            str=@"01";
                            findKeyIsTouchDown=NO;
                            [findKeyFinderBtn setImage:[UIImage imageNamed:@"BTN.png"] forState:UIControlStateNormal];
                        }
                        else{
                            str=@"00";
                            findKeyIsTouchDown=YES;
                            [findKeyFinderBtn setImage:[UIImage imageNamed:@"BTNNot.png"] forState:UIControlStateNormal];
                        }
                        NSData *PWMdata=[self NSStringToNSData:str];
                        [bleController._peripheral writeValue:PWMdata forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                    }
                }
            }
        }
    }
    else if (bleController._peripheral.state==CBPeripheralStateDisconnected  || bleController._peripheral.state==CBPeripheralStateConnecting)
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Bluetooth peripherals are not connected!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
    }
}
*/
-(void)mapLocationChangeState
{
    if (_switchFour.status==CustomSwitchStatusOn) {
        //代表地图定位可以使用
        NSString *mapLocationEnable=@"1";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mapLocationEnable" object:mapLocationEnable];
    }else if (_switchFour.status==CustomSwitchStatusOff){
        //代表地图定位不可以使用
        NSString *mapLocationEnable=@"0";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mapLocationEnable" object:mapLocationEnable];
    }
}
-(void)showMapView
{
    mapVC=[[MapViewController alloc]init];
    [self presentViewController:mapVC animated:YES completion:^{}];
}

#pragma mark-
#pragma mark-切换主题按钮的方法
-(void)changeThemToDefault
{
    [orangeBtn setImage:[UIImage imageNamed:@"橙色图标.png"] forState:UIControlStateNormal];
    [greenBtn setImage:[UIImage imageNamed:@"绿色图标.png"] forState:UIControlStateNormal];
    [purpleBtn setImage:[UIImage imageNamed:@"紫色图标.png"] forState:UIControlStateNormal];
    
    
    [defaultThemBtn setImage:[UIImage imageNamed:@"蓝绿色图标按下.png"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]postNotificationName:themChangeToDefault object:nil];
    
//    
//    labaView.image=[UIImage imageNamed:@"喇叭蓝绿.png"];
//    //左右轨的图片
//    UIImage *stetchLeftTrack= [UIImage imageNamed:@"音量条蓝.png"];
//    [sliderVolume setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    
    
    //保存起来当前的主题设置
    NSUserDefaults *defaultThem=[NSUserDefaults standardUserDefaults];
    NSString *them=@"default";
    [defaultThem setObject:them forKey:@"e2Them"];
    [defaultThem synchronize];
    
    
    
}
-(void)changThemToOrange
{
    [defaultThemBtn setImage:[UIImage imageNamed:@"蓝绿色图标.png"] forState:UIControlStateNormal];
    [greenBtn setImage:[UIImage imageNamed:@"绿色图标.png"] forState:UIControlStateNormal];
    [purpleBtn setImage:[UIImage imageNamed:@"紫色图标.png"] forState:UIControlStateNormal];
    
    [orangeBtn setImage:[UIImage imageNamed:@"橙色图标按下.png"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]postNotificationName:themChangeToOrange object:nil];
//    
//    labaView.image=[UIImage imageNamed:@"喇叭橙色.png"];
//    //左右轨的图片
//    UIImage *stetchLeftTrack= [UIImage imageNamed:@"音量条橙色.png"];
//    [sliderVolume setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    
    //保存起来当前的主题设置
    NSUserDefaults *defaultThem=[NSUserDefaults standardUserDefaults];
    NSString *them=@"orange";
    [defaultThem setObject:them forKey:@"e2Them"];
    [defaultThem synchronize];
    
}
-(void)changThemToGreen
{
    
    [defaultThemBtn setImage:[UIImage imageNamed:@"蓝绿色图标.png"] forState:UIControlStateNormal];
    [orangeBtn setImage:[UIImage imageNamed:@"橙色图标.png"] forState:UIControlStateNormal];
    [purpleBtn setImage:[UIImage imageNamed:@"紫色图标.png"] forState:UIControlStateNormal];
    
    [greenBtn setImage:[UIImage imageNamed:@"绿色图标按下.png"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]postNotificationName:themChangeToGreen object:nil];
//    
//    labaView.image=[UIImage imageNamed:@"喇叭绿色.png"];
//    //左右轨的图片
//    UIImage *stetchLeftTrack= [UIImage imageNamed:@"音量条绿色.png"];
//    [sliderVolume setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    
    //保存起来当前的主题设置
    NSUserDefaults *defaultThem=[NSUserDefaults standardUserDefaults];
    NSString *them=@"green";
    [defaultThem setObject:them forKey:@"e2Them"];
    [defaultThem synchronize];
    
}
-(void)changThemToPurple
{
    
    [defaultThemBtn setImage:[UIImage imageNamed:@"蓝绿色图标.png"] forState:UIControlStateNormal];
    [orangeBtn setImage:[UIImage imageNamed:@"橙色图标.png"] forState:UIControlStateNormal];
    [greenBtn setImage:[UIImage imageNamed:@"绿色图标.png"] forState:UIControlStateNormal];
    
    [purpleBtn setImage:[UIImage imageNamed:@"紫色图标按下.png"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]postNotificationName:themChangeToPurple object:nil];
    
//    labaView.image=[UIImage imageNamed:@"喇叭紫色.png"];
//    //左右轨的图片
//    UIImage *stetchLeftTrack= [UIImage imageNamed:@"音量条紫色.png"];
//    [sliderVolume setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    //保存起来当前的主题设置
    NSUserDefaults *defaultThem=[NSUserDefaults standardUserDefaults];
    NSString *them=@"purple";
    [defaultThem setObject:them forKey:@"e2Them"];
    [defaultThem synchronize];
}

#pragma mark-
#pragma mark-切换主题的方法
-(void)changeThemToDefaultSetVC
{
    _switchOne.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchOne.offImage = [UIImage imageNamed:@"OFF灰.png"];
    _switchOne.onImage = [UIImage imageNamed:@"ON蓝绿.png"];
    [_switchOne setNeedsDisplay];
    
    
    _switchTwo.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchTwo.onImage = [UIImage imageNamed:@"NEAR蓝绿条80.png"];
    _switchTwo.offImage = [UIImage imageNamed:@"蓝绿FAR.png"];
    [_switchTwo setNeedsDisplay];
    
    //关闭断线报警
    _switchThree.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchThree.offImage = [UIImage imageNamed:@"OFF灰.png"];
    _switchThree.onImage = [UIImage imageNamed:@"ON蓝绿.png"];
    
    [_switchThree setNeedsDisplay];
    //地图定位按钮
    
    _switchFour.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchFour.onImage = [UIImage imageNamed:@"ON蓝绿.png"];
    _switchFour.offImage = [UIImage imageNamed:@"OFF灰.png"];
    [_switchFour setNeedsDisplay];
}
-(void)changeThemToOrangeSetVC
{
/*
    if (_switchOne.status==CustomSwitchStatusOn) {
        _switchOne.arrange = CustomSwitchArrangeONLeftOFFRight;
        _switchOne.onImage = [UIImage imageNamed:@"On橙色.png"];
        _switchOne.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
        _switchOne.status = CustomSwitchStatusOn;
    }
    else{
        _switchOne.arrange = CustomSwitchArrangeONLeftOFFRight;
        _switchOne.onImage = [UIImage imageNamed:@"On橙色.png"];
        _switchOne.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
        _switchOne.status = CustomSwitchStatusOff;
    }
    
  
    //距离调节按钮
    
    if (_switchTwo.state==CustomSwitchStatusOn) {
        _switchTwo.onImage = [UIImage imageNamed:@"Near橙色.png"];
    }
    _switchTwo.offImage = [UIImage imageNamed:@"Far橙色.png"];
    
    //关闭断线报警
    _switchThree.onImage = [UIImage imageNamed:@"On橙色.png"];
    _switchThree.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
    
    //地图定位按钮
    _switchFour.onImage = [UIImage imageNamed:@"On橙色.png"];
    _switchFour.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
       
    */
    if (_switchOne.status==CustomSwitchStatusOn) {
       
    }else if (_switchOne.status==CustomSwitchStatusOff){
       
    }
    _switchOne.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchOne.offImage = nil;
    _switchOne.onImage = nil;
    _switchOne.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
    _switchOne.onImage = [UIImage imageNamed:@"On橙色.png"];
    [_switchOne setNeedsDisplay];
    
    
    
    _switchTwo.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchTwo.offImage = [UIImage imageNamed:@"Far橙色.png"];
    _switchTwo.onImage = [UIImage imageNamed:@"Near橙色.png"];
    [_switchTwo setNeedsDisplay];
    
    //关闭断线报警
    _switchThree.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchThree.offImage = nil;
    _switchThree.onImage = nil;
    _switchThree.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
    _switchThree.onImage = [UIImage imageNamed:@"On橙色.png"];
    [_switchThree setNeedsDisplay];
    //地图定位按钮
    
    _switchFour.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchFour.offImage = [UIImage imageNamed:@"OFF灰橙色.png"];
    _switchFour.onImage = [UIImage imageNamed:@"On橙色.png"];
    [_switchFour setNeedsDisplay];
    
}

-(void)changeThemToGreenSetVC
{
    
    _switchOne.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchOne.offImage = [UIImage imageNamed:@"OFF灰绿色.png"];
    _switchOne.onImage = [UIImage imageNamed:@"On绿色.png"];
    [_switchOne setNeedsDisplay];
    
    _switchTwo.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchTwo.offImage = [UIImage imageNamed:@"Far绿色.png"];
    _switchTwo.onImage = [UIImage imageNamed:@"Near绿色.png"];
    [_switchTwo setNeedsDisplay];
    
    //关闭断线报警
    _switchThree.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchThree.offImage = [UIImage imageNamed:@"OFF灰绿色.png"];
    _switchThree.onImage = [UIImage imageNamed:@"On绿色.png"];
    
    [_switchThree setNeedsDisplay];
    //地图定位按钮
    
    _switchFour.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchFour.onImage = [UIImage imageNamed:@"On绿色.png"];
    _switchFour.offImage = [UIImage imageNamed:@"OFF灰绿色.png"];
    [_switchFour setNeedsDisplay];
}

-(void)changeThemToPurpleSetVC
{
    _switchOne.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchOne.offImage = [UIImage imageNamed:@"OFF灰紫色.png"];
    _switchOne.onImage = [UIImage imageNamed:@"On紫色.png"];
    [_switchOne setNeedsDisplay];
    
    _switchTwo.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchTwo.offImage = [UIImage imageNamed:@"Far紫色.png"];
    _switchTwo.onImage = [UIImage imageNamed:@"Near紫色.png"];
    [_switchTwo setNeedsDisplay];
    
    //关闭断线报警
    _switchThree.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchThree.offImage = [UIImage imageNamed:@"OFF灰紫色.png"];
    _switchThree.onImage = [UIImage imageNamed:@"On紫色.png"];
    
    [_switchThree setNeedsDisplay];
    //地图定位按钮
    
    _switchFour.arrange = CustomSwitchArrangeONLeftOFFRight;
    _switchFour.onImage = [UIImage imageNamed:@"On紫色.png"];
    _switchFour.offImage = [UIImage imageNamed:@"OFF灰紫色.png"];
    [_switchFour setNeedsDisplay];
   
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

-(void)judeLocationIsOn
{
    //取出来定位过的经纬度
    NSUserDefaults *userdefau=[NSUserDefaults standardUserDefaults];
//    [userdefau removeObjectForKey:@"compxLongitude"];
//    [userdefau removeObjectForKey:@"compxLatitude"];
    double mapLongitude=[userdefau doubleForKey:@"compxLongitude"];
    double mapLatitude=[userdefau doubleForKey:@"compxLatitude"];
    if (mapLongitude!=0 && mapLatitude!=0) {
        //有定位
        [mapBtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
    }
    else if (mapLongitude==0 && mapLatitude==0){
        //无定位
        [mapBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//封装播放函数
-(void)loadMusic:(NSString*)name type:(NSString*)type
{
    NSString* path= [[NSBundle mainBundle] pathForResource: name ofType:type];
    NSURL* url = [NSURL fileURLWithPath:path];

    audioPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.volume=sliderVolume.value;
    //NSLog(@"setVC.sliderVolume.value==%f",sliderVolume.value);
  

}


@end
