//
//  MusicViewController.m
//  compxLostFind
//
//  Created by Compx on 14-6-17.
//  Copyright (c) 2014年 compx.com.cn. All rights reserved.
//

#import "MusicViewController.h"

@interface MusicViewController ()

@end

@implementation MusicViewController
@synthesize imageView;
@synthesize play;
@synthesize pause;
@synthesize volumeSlider;
@synthesize player;
@synthesize songLab;
@synthesize artistLab;
@synthesize toolbar;
@synthesize collection;
@synthesize MusicVCisPlaying;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        MusicVCisPlaying=NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    // Do any additional setup after loading the view.
    self.view.frame=[UIScreen mainScreen].bounds;
    self.view.backgroundColor=[UIColor colorWithRed:(250/255.0) green:(240/255.0) blue:(230/255.0) alpha:1.0];
    
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 55)];
    [self.view addSubview:navView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isMusicPlayForStartVideo) name:@"willStartVideo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isMusicPlay) name:notiAudioWillPlay object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(audioEndPlay) name:notiAudioEndPlay object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callComing) name:@"CallComing" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callFinish) name:@"CallFinish" object:nil];
    
    
    if (iPhone5) {
        [self iPhone5View];
    }
    else{
        [self iPhone4View];
    }
    
     // 检测手机里面是否又 音乐歌曲存在
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    MPMediaPropertyPredicate *albumNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
    [everything addFilterPredicate:albumNamePredicate];
    NSArray *itemsFromGenericQuery = [everything items];
    
    if ([itemsFromGenericQuery count]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"MusicNoSong", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        alert.tag=100;
        [alert show];
        return;
    }
    else{
        // GotoPlay;
    }
    //使用系统的音乐播放器
    player = [MPMusicPlayerController iPodMusicPlayer];
    player.repeatMode=MPMusicShuffleModeOff;
    [player setQueueWithQuery:everything];
    
    [self nowPlayingItemChanged];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(nowPlayingItemChanged)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:player];
    [notificationCenter
     addObserver: self
     selector:    @selector (PlaybackStateChanged:)
     name:  MPMusicPlayerControllerPlaybackStateDidChangeNotification
     object: player];
    [player beginGeneratingPlaybackNotifications];
    //    [self mediaPicker:player didPickMediaItems:collection];

    /*
    //播放暂停按钮
    play=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(playPausePressed)];
    play.tintColor=[UIColor blackColor];
    
    pause =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playPausePressed)];
    pause.tintColor=[UIColor blackColor];
    
    
    //    [pause setStyle:UIBarButtonItemStyleBordered];
    btnPlace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    btnPlace.tintColor=[UIColor blackColor];
    
    preItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(rewindPressed)];
    preItem.tintColor=[UIColor blackColor];
    
    nextItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(fastForwardPressed)];
    nextItem.tintColor=[UIColor blackColor];
    
    tbaItemsArray = [NSArray arrayWithObjects:preItem,btnPlace,pause,btnPlace,nextItem, nil];
  
    
    
    //底部的条
    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].applicationFrame.size.height - 34.0, 320, 34.0)];
    //    toolBar.tintColor = [[UIColor blueColor] colorWithAlphaComponent:.65];
    toolbar.items = tbaItemsArray;
//    [self.view addSubview:toolbar];
    */
    
    //监听系统音量的变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    /*
        MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    //    // 读取条件
        MPMediaPropertyPredicate *albumNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
        [everything addFilterPredicate:albumNamePredicate];
        NSArray *itemsFromGenericQuery = [everything items];
    
    
    if (self.collection == nil) {
        self.collection = mediaItemCollection;
        [player setQueueWithItemCollection:self.collection];
        MPMediaItem *item = [[self.collection items] objectAtIndex:0];
        [player setNowPlayingItem:item];
        //        [self playPausePressed];
    } else {
        NSArray *oldItems = [self.collection items];
        NSArray *newItems = [oldItems arrayByAddingObjectsFromArray:[mediaItemCollection items]];
        self.collection = [[MPMediaItemCollection alloc] initWithItems:newItems];
    }
    */
    //检测有电话打进来
    callCenterState = [[CTCallCenter alloc] init];
    callCenterState.callEventHandler = ^(CTCall* call)
    {
        if (call.callState == CTCallStateDisconnected)
        {
            //电话挂断
            
            [[NSNotificationCenter defaultCenter ]postNotificationName:@"CallFinish" object:nil];
        }
        else if (call.callState == CTCallStateConnected)
        {
            //电话接通并挂电话后调用
            [[NSNotificationCenter defaultCenter ]postNotificationName:@"CallFinish" object:nil];
        }
        else if(call.callState == CTCallStateIncoming)
        {
            //有电话打进来
            
           [[NSNotificationCenter defaultCenter ]postNotificationName:@"CallComing" object:nil];
            
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            //主动打电话
            //判断一下当前音乐是否正在播放，在播放就得要先暂停播放
           [[NSNotificationCenter defaultCenter ]postNotificationName:@"CallComing" object:nil];
        }
        else
        {
           // NSLog(@"None of the conditions");
        }
    };
}

//根据屏幕的大小来进行页面布局
-(void)iPhone5View
{
    //返回按钮
    UIButton *BackBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 25, 55, 45)];
    [BackBtn setTitle:NSLocalizedString(@"MusicBack", nil) forState:UIControlStateNormal];
    [BackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [BackBtn addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BackBtn];
    
    //添加歌曲按钮
    UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width-60, 25, 55, 45)];
    [addBtn setTitle:NSLocalizedString(@"MusicAddSong", nil) forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    //专辑封面
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(40, 90, 240, 250)];
    imageView.layer.masksToBounds=YES;
    imageView.layer.cornerRadius=8.0;
    [self.view addSubview:imageView];
    
    //歌曲名
    songLab=[[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width/2-150, 370, 300, 23)];
    songLab.font=[UIFont boldSystemFontOfSize:20.0];
    songLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:songLab];
    
    
    //艺术家
    artistLab=[[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width/2-150, 403, 300, 20)];
    artistLab.font=[UIFont boldSystemFontOfSize:16.0];
    artistLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:artistLab];
    
    ///////
    MPMediaItem *currentItem = [player nowPlayingItem];
    NSString *artistStr = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    [artistLab setText:[NSString stringWithFormat:@"%@", artistStr]];
    [songLab setText:[currentItem valueForProperty:MPMediaItemPropertyTitle]];
    
    ///////
    [player setNowPlayingItem:currentItem];
    //    [player play];
    
    //喇叭
    UIImageView *labaImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 437, 30, 30)];
    labaImage.image=[UIImage imageNamed:@"喇叭黑灰色.png"];
    [self.view addSubview:labaImage];
    
    
    //添加音量控制条
    volumeSlider=[[UISlider alloc]initWithFrame:CGRectMake(50,440, 220, 20)];
    volumeSlider.minimumValue=0.0;
    volumeSlider.minimumTrackTintColor=[UIColor blackColor];
    volumeSlider.maximumValue=1.0;
    volumeSlider.value=1.0;
    [volumeSlider addTarget:self action:@selector(volumeChangeSetPlayerVolume) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:volumeSlider];
    
    
    playView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-100, 320, 100)];
    playView.userInteractionEnabled=YES;
    [self.view addSubview:playView];
    
    preItems=[UIButton buttonWithType:UIButtonTypeCustom];
    preItems.frame=CGRectMake(40, 30, 40, 40);
    [preItems setImage:[UIImage imageNamed:@"播放器上一首.png"] forState:UIControlStateNormal];
    [preItems setImage:[UIImage imageNamed:@"播放器上一首按下.png"] forState:UIControlStateHighlighted];
    [preItems addTarget:self action:@selector(rewindPressed) forControlEvents:UIControlEventTouchUpInside];
    preItems.showsTouchWhenHighlighted=YES;
    [playView addSubview:preItems];
    
    
    playItems=[UIButton buttonWithType:UIButtonTypeCustom];
    playItems.frame=CGRectMake(130, 20, 60, 60);
    [playItems setImage:[UIImage imageNamed:@"播放器播放.png"] forState:UIControlStateNormal];
    [playItems addTarget:self action:@selector(playPausePressed) forControlEvents:UIControlEventTouchUpInside];
    playItems.showsTouchWhenHighlighted=YES;
    [playView addSubview:playItems];
    
    
    nextItems=[UIButton buttonWithType:UIButtonTypeCustom];
    nextItems.frame=CGRectMake(240, 30, 40, 40);
    [nextItems addTarget:self action:@selector(fastForwardPressed) forControlEvents:UIControlEventTouchUpInside];
    [nextItems setImage:[UIImage imageNamed:@"播放器下一首.png"] forState:UIControlStateNormal];
    [nextItems setImage:[UIImage imageNamed:@"播放器下一首按下.png"] forState:UIControlStateHighlighted];
    
    
    nextItems.showsTouchWhenHighlighted=YES;
    [playView addSubview:nextItems];

    
}
-(void)iPhone4View
{
    //返回按钮
    UIButton *BackBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 25, 55, 45)];
    [BackBtn setTitle:NSLocalizedString(@"MusicBack", nil) forState:UIControlStateNormal];
    [BackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [BackBtn addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BackBtn];
    
    //添加歌曲按钮
    UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width-60, 25, 55, 45)];
    [addBtn setTitle:NSLocalizedString(@"MusicAddSong", nil) forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    //专辑封面
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 70, 220, 230)];
    imageView.layer.masksToBounds=YES;
    imageView.layer.cornerRadius=8.0;
    [self.view addSubview:imageView];
    
    //歌曲名
    songLab=[[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width/2-150, 315, 300, 23)];
    songLab.font=[UIFont boldSystemFontOfSize:20.0];
    songLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:songLab];
    
    
    //艺术家
    artistLab=[[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width/2-150, 348, 300, 20)];
    artistLab.font=[UIFont boldSystemFontOfSize:16.0];
    artistLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:artistLab];
    
    ///////
    MPMediaItem *currentItem = [player nowPlayingItem];
    NSString *artistStr = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    [artistLab setText:[NSString stringWithFormat:@"%@", artistStr]];
    [songLab setText:[currentItem valueForProperty:MPMediaItemPropertyTitle]];
    
    ///////
    [player setNowPlayingItem:currentItem];
    //    [player play];
    
    //喇叭
    UIImageView *labaImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 370, 30, 30)];
    labaImage.image=[UIImage imageNamed:@"喇叭黑灰色.png"];
    [self.view addSubview:labaImage];
    
    
    //添加音量控制条
    volumeSlider=[[UISlider alloc]initWithFrame:CGRectMake(50,375, 220, 20)];
    volumeSlider.minimumValue=0.0;
    volumeSlider.minimumTrackTintColor=[UIColor blackColor];
    volumeSlider.maximumValue=1.0;
    volumeSlider.value=1.0;
    [volumeSlider addTarget:self action:@selector(volumeChangeSetPlayerVolume) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:volumeSlider];
    
    
    playView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-80, 320, 100)];
    playView.userInteractionEnabled=YES;
    [self.view addSubview:playView];
    
    preItems=[UIButton buttonWithType:UIButtonTypeCustom];
    preItems.frame=CGRectMake(40, 20, 40, 40);
    [preItems setImage:[UIImage imageNamed:@"播放器上一首.png"] forState:UIControlStateNormal];
    [preItems setImage:[UIImage imageNamed:@"播放器上一首按下.png"] forState:UIControlStateHighlighted];
    [preItems addTarget:self action:@selector(rewindPressed) forControlEvents:UIControlEventTouchUpInside];
    preItems.showsTouchWhenHighlighted=YES;
    [playView addSubview:preItems];
    
    
    playItems=[UIButton buttonWithType:UIButtonTypeCustom];
    playItems.frame=CGRectMake(130, 10, 60, 60);
    [playItems setImage:[UIImage imageNamed:@"播放器播放.png"] forState:UIControlStateNormal];
    [playItems addTarget:self action:@selector(playPausePressed) forControlEvents:UIControlEventTouchUpInside];
    playItems.showsTouchWhenHighlighted=YES;
    [playView addSubview:playItems];
    
    
    nextItems=[UIButton buttonWithType:UIButtonTypeCustom];
    nextItems.frame=CGRectMake(240, 20, 40, 40);
    [nextItems addTarget:self action:@selector(fastForwardPressed) forControlEvents:UIControlEventTouchUpInside];
    [nextItems setImage:[UIImage imageNamed:@"播放器下一首.png"] forState:UIControlStateNormal];
    [nextItems setImage:[UIImage imageNamed:@"播放器下一首按下.png"] forState:UIControlStateHighlighted];
    nextItems.showsTouchWhenHighlighted=YES;
    [playView addSubview:nextItems];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag==100) {
        if (buttonIndex==0) {
            [self backToMainView];
        }
    }
    
}

-(void)addControlBar
{
    playView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-120, 320, 120)];
    [self.view addSubview:playView];
    
    
    preItems=[UIButton buttonWithType:UIButtonTypeCustom];
    preItems.frame=CGRectMake(40, 40, 40, 40);
    [preItems setImage:[UIImage imageNamed:@"播放器上一首.png"] forState:UIControlStateNormal];
    [playView addSubview:preItems];
    
    
    playItems=[UIButton buttonWithType:UIButtonTypeCustom];
    playItems.frame=CGRectMake(120, 20, 80, 80);
    [playItems setImage:[UIImage imageNamed:@"播放器播放.png"] forState:UIControlStateNormal];
    [playView addSubview:playItems];
    
    
    nextItems=[UIButton buttonWithType:UIButtonTypeCustom];
    nextItems.frame=CGRectMake(240, 40, 40, 40);
    [nextItems setImage:[UIImage imageNamed:@"播放器下一首.png"] forState:UIControlStateNormal];
    [playView addSubview:nextItems];

}

-(void)viewWillAppear:(BOOL)animated
{
    
    //获取当前系统的音量，并把播放器的音量设置成系统的音量

    float sysVolume = 0.0;
    UInt32 dataSize = sizeof(float);
    AudioSessionGetProperty (kAudioSessionProperty_CurrentHardwareOutputVolume,
                                               &dataSize,
                                               &sysVolume);
    volumeSlider.value=sysVolume;
    
    
    if ([toolbar isDescendantOfView:self.view]) {
        [toolbar removeFromSuperview];
    }
    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].applicationFrame.size.height - 34.0, 320, 34.0)];
    
    if (MusicVCisPlaying==YES) {
      tbaItemsArray = [NSArray arrayWithObjects:preItem,btnPlace,play,btnPlace,nextItem, nil];
    }
    else
    {
        tbaItemsArray = [NSArray arrayWithObjects:preItem,btnPlace,pause,btnPlace,nextItem, nil];
    }
    
    toolbar.items = tbaItemsArray;
//    [self.view addSubview:toolbar];
    
//    [self addControlBar];
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    //    // 读取条件
    MPMediaPropertyPredicate *albumNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
    [everything addFilterPredicate:albumNamePredicate];
    NSArray *itemsFromGenericQuery = [everything items];
    
    if ([itemsFromGenericQuery count]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"MusicNoSong", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        alert.tag=100;
        [alert show];
        return;
    }

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)testMu
{
    // 从ipod库中读出音乐文件
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
       // 读取条件
    MPMediaPropertyPredicate *albumNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
    [everything addFilterPredicate:albumNamePredicate];
   
    NSArray *itemsFromGenericQuery = [everything items];
    for (MPMediaItem *song in itemsFromGenericQuery) {
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
    }
}

//当有电话打进来的时候或主动打电话的时候被调用
-(void)callComing
{
    if (MusicVCisPlaying==YES) {
        isCallComing=TRUE;
        [player pause];
        [playItems setImage:[UIImage imageNamed:@"播放器播放.png"] forState:UIControlStateNormal];
    }
}
-(void)callFinish
{
    if (isCallComing==TRUE) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(audioEndPlay) userInfo:nil repeats:NO];
        isCallComing=FALSE;
    }
}

//接受通知判断当前是否正在播放音乐，如果正在播放，就暂停
-(void)isMusicPlay
{
    if (MusicVCisPlaying==YES) {
        [player pause];
        MusicVCisPlaying=NO;
        NSArray *itemsArrays = [NSArray arrayWithObjects:preItem,btnPlace,pause,btnPlace,nextItem, nil];
        [toolbar setItems:itemsArrays animated:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(continuePlay) userInfo:nil repeats:NO];
    }
    //NSLog(@"播放暂停");
}
-(void)isMusicPlayForStartVideo
{
    if (MusicVCisPlaying==YES) {
        [player pause];
//        MusicVCisPlaying=NO;
        NSArray *itemsArrays = [NSArray arrayWithObjects:preItem,btnPlace,pause,btnPlace,nextItem, nil];
        [toolbar setItems:itemsArrays animated:NO];
    }
   // NSLog(@"播放暂停");
}
-(void)audioEndPlay
{
    //NSLog(@"播放继续");
    if (!player) {
        player = [MPMusicPlayerController iPodMusicPlayer];
        player.repeatMode=MPMusicShuffleModeOff;
        
        //获取歌曲
        MPMediaQuery *everything = [[MPMediaQuery alloc] init];
        MPMediaPropertyPredicate *albumNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
        [everything addFilterPredicate:albumNamePredicate];
        [player setQueueWithQuery:everything];
        
        //        [self nowPlayingItemChanged];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self
                               selector:@selector(nowPlayingItemChanged)
                                   name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:player];
//        [notificationCenter
//         addObserver: self
//         selector:    @selector (PlaybackStateChanged:)
//         name:  MPMusicPlayerControllerPlaybackStateDidChangeNotification
//         object: player];
        [player beginGeneratingPlaybackNotifications];
    }
    MPMediaItem *currentItem = [player nowPlayingItem];
    [player setNowPlayingItem:currentItem];
    [player play];
    tbaItemsArray = [NSArray arrayWithObjects:preItem,btnPlace,play,btnPlace,nextItem, nil];
    toolbar.items = tbaItemsArray;
    
    MusicVCisPlaying=YES;
    
}


- (void)volumeChanged:(NSNotification *)notification
{
    float volume =
    [[[notification userInfo]
      objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
     floatValue];
    volumeSlider.value=volume;
}
-(void)backToMainView
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    //关闭了音乐播放页面时，同时给首页发送一个通知，以便其将打开的标志位置0
    [[NSNotificationCenter defaultCenter]postNotificationName:notiMusicVcClose object:self userInfo:nil];

}
- (void)addVolume;
{
    if (!volumeSlider) {
        if ([volumeSlider isDescendantOfView:self.view]) {
            [volumeSlider removeFromSuperview];
        }
        //添加音量控制条
        volumeSlider=[[UISlider alloc]initWithFrame:CGRectMake(40,430, 240, 40)];
        volumeSlider.minimumValue=0.0;
        volumeSlider.minimumTrackTintColor=[UIColor blackColor];
        volumeSlider.maximumValue=1.0;
        [volumeSlider addTarget:self action:@selector(volumeChangeSetPlayerVolume) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:volumeSlider];
        
        float sysVolume = 0.0;
        UInt32 dataSize = sizeof(float);
        AudioSessionGetProperty (kAudioSessionProperty_CurrentHardwareOutputVolume,
                                 &dataSize,
                                 &sysVolume);
        volumeSlider.value=sysVolume;
    }
    volumeSlider.value=volumeSlider.value+0.1;
    [self volumeChangeSetPlayerVolume];
}
- (void)subVolume;
{
    if (!volumeSlider) {
        if ([volumeSlider isDescendantOfView:self.view]) {
            [volumeSlider removeFromSuperview];
        }
        //添加音量控制条
        volumeSlider=[[UISlider alloc]initWithFrame:CGRectMake(40,430, 240, 40)];
        volumeSlider.minimumValue=0.0;
        volumeSlider.minimumTrackTintColor=[UIColor blackColor];
        volumeSlider.maximumValue=1.0;
        [volumeSlider addTarget:self action:@selector(volumeChangeSetPlayerVolume) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:volumeSlider];
        
        float sysVolume = 0.0;
        UInt32 dataSize = sizeof(float);
        AudioSessionGetProperty (kAudioSessionProperty_CurrentHardwareOutputVolume,
                                 &dataSize,
                                 &sysVolume);
        volumeSlider.value=sysVolume;
    }
    volumeSlider.value=volumeSlider.value-0.1;
    [self volumeChangeSetPlayerVolume];
}
-(void)volumeChangeSetPlayerVolume
{
    player.volume=volumeSlider.value;
}

- (void)rewindPressed {
    if ([player indexOfNowPlayingItem] == 0) {
        [player skipToBeginning];
    } else {
        [player endSeeking];
        [player skipToPreviousItem];
    }
}

- (void)playPausePressed{

    MPMusicPlaybackState playbackState = [player playbackState];
//    NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
    NSArray *itemsArray;
    if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
        
        [playItems setImage:[UIImage imageNamed:@"播放器暂停.png"] forState:UIControlStateNormal];
        
        if (!player) {
            player = [MPMusicPlayerController iPodMusicPlayer];
            player.repeatMode=MPMusicShuffleModeOff;
            MPMediaQuery *everything = [[MPMediaQuery alloc] init];
            MPMediaPropertyPredicate *albumNamePredicate =
            [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
            [everything addFilterPredicate:albumNamePredicate];
            [player setQueueWithQuery:everything];
        }
        
        [player play];
        MusicVCisPlaying=YES;
       itemsArray = [NSArray arrayWithObjects:preItem,btnPlace,play,btnPlace,nextItem, nil];
        
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        
        [playItems setImage:[UIImage imageNamed:@"播放器播放.png"] forState:UIControlStateNormal];
        
        if (!player) {
            player = [MPMusicPlayerController iPodMusicPlayer];
            player.repeatMode=MPMusicShuffleModeOff;
            MPMediaQuery *everything = [[MPMediaQuery alloc] init];
            MPMediaPropertyPredicate *albumNamePredicate =
            [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
            [everything addFilterPredicate:albumNamePredicate];
            [player setQueueWithQuery:everything];
        }
        [player pause];
        MusicVCisPlaying=NO;
//        [items replaceObjectAtIndex:3 withObject:self.play];
        itemsArray = [NSArray arrayWithObjects:preItem,btnPlace,pause,btnPlace,nextItem, nil];
        
    }
    [toolbar setItems:itemsArray animated:NO];
//    [self.view setNeedsDisplay];
}

- (void)fastForwardPressed{
    NSUInteger nowPlayingIndex = [player indexOfNowPlayingItem];
    [player endSeeking];
    [player skipToNextItem];
    if ([player nowPlayingItem] == nil) {
        if ([self.collection count] > nowPlayingIndex+1) {
            // added more songs while playing
            [player setQueueWithItemCollection:self.collection];
            MPMediaItem *item = [[self.collection items] objectAtIndex:nowPlayingIndex+1];
            [player setNowPlayingItem:item];
            [player play];
            MusicVCisPlaying=YES;
        }
        else {
            // no more songs
            [player stop];
            MusicVCisPlaying=NO;
            NSArray *itemsArray = [NSArray arrayWithObjects:preItem,btnPlace,play,btnPlace,nextItem, nil];
            [toolbar setItems:itemsArray];
            
            [playItems setImage:[UIImage imageNamed:@"播放器播放.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)addPressed {
    MPMediaType mediaType = MPMediaTypeMusic;
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:mediaType];
    picker.delegate = self;
    [picker setAllowsPickingMultipleItems:YES];
    picker.prompt = NSLocalizedString(@"Select items to play", @"Select items to play");
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Media Picker Delegate Methods

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
//    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.collection == nil) {
        self.collection = mediaItemCollection;
        [player setQueueWithItemCollection:self.collection];
        MPMediaItem *item = [[self.collection items] objectAtIndex:0];
        [player setNowPlayingItem:item];
//        [self playPausePressed];
    } else {
        NSArray *oldItems = [self.collection items];
        NSArray *newItems = [oldItems arrayByAddingObjectsFromArray:[mediaItemCollection items]];
        self.collection = [[MPMediaItemCollection alloc] initWithItems:newItems];
    }
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification Methods
- (void)nowPlayingItemChanged
{
	MPMediaItem *currentItem = [player nowPlayingItem];
    if (nil == currentItem) {
//        [self.imageView setImage:nil];
//        [self.imageView setHidden:YES];
//        [artistLab setText:nil];
//        [songLab setText:nil];
        [self mediaPicker:nil didPickMediaItems:nil];
        //NSLog(@"当前播放的歌曲是空的");
    }
    else {
        MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
        if (artwork) {
            UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(320, 320)];
            if (artworkImage==NULL) {
               // NSLog(@"没有封面可以显示");
                [self.imageView setImage:[UIImage imageNamed:@"默认图片.jpg"]];
            }
            else{
                [self.imageView setImage:artworkImage];
            }
            
//            NSString *MusicTime=[currentItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
//            NSLog(@"MusicTime==%@",MusicTime);
            
            [self.imageView setHidden:NO];
        }
        // Display the artist and song name for the now-playing media item
        NSString *artistStr = [currentItem valueForProperty:MPMediaItemPropertyArtist];
      
        [artistLab setText:[NSString stringWithFormat:@"%@", artistStr]];
        [songLab setText:[currentItem valueForProperty:MPMediaItemPropertyTitle]];
    }
}

-(void)PlaybackStateChanged:(NSNotification *)notification
{
    
    if (player.playbackState==MPMusicPlaybackStateInterrupted) {
        //判断是不是被来电打断的
        if (isCallComing==TRUE) {
            return;
        }
        else
        {
            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(continuePlay) userInfo:nil repeats:NO];
            MusicVCisPlaying=YES;
            
            
            [playItems setImage:[UIImage imageNamed:@"播放器播放.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)continuePlay
{
    if (!player) {
        player = [MPMusicPlayerController iPodMusicPlayer];
        player.repeatMode=MPMusicShuffleModeOff;
        MPMediaQuery *everything = [[MPMediaQuery alloc] init];
        MPMediaPropertyPredicate *albumNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
        [everything addFilterPredicate:albumNamePredicate];
        [player setQueueWithQuery:everything];
        
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self
                               selector:@selector(nowPlayingItemChanged)
                                   name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:player];
        [notificationCenter
         addObserver: self
         selector:    @selector (PlaybackStateChanged:)
         name:  MPMusicPlayerControllerPlaybackStateDidChangeNotification
         object: player];
        [player beginGeneratingPlaybackNotifications];
    }
    MPMediaItem *currentItem = [player nowPlayingItem];
    [player setNowPlayingItem:currentItem];
    [player play];
//    tbaItemsArray = [NSArray arrayWithObjects:preItem,btnPlace,play,btnPlace,nextItem, nil];
//    toolbar.items = tbaItemsArray;
    
    [playItems setImage:[UIImage imageNamed:@"播放器暂停.png"] forState:UIControlStateNormal];
    MusicVCisPlaying=YES;
}

/*
-(IBAction)playORpause
{
    if ([playButton.title isEqualToString:@"Play"]){
        [musicPlayerController play];
        playButton.title = @"Pause";
        MPMediaItem *nowPlayItem = [musicPlayerController nowPlayingItem];
    //获取当前播放的歌曲
    if (nowPlayItem) {
        MPMediaItemArtwork *artwork = [nowPlayItem valueForProperty:MPMediaItemPropertyArtwork];
    //获取artwork，这里是为获取专辑封面做铺垫
        NSString *songtitle = [nowPlayItem valueForProperty:MPMediaItemPropertyTitle];
    //获取歌曲标题
        NSString *albumTitle = [nowPlayItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    //获取专辑标题
        NSString *artist = [nowPlayItem valueForProperty:MPMediaItemPropertyArtist];
    //获取歌手姓名
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        songtitle = [songtitle stringByAppendingString:@"/n"];
        songtitle = [songtitle stringByAppendingString:albumTitle];
        songtitle = [songtitle stringByAppendingString:@"/n"];
        songtitle = [songtitle stringByAppendingString:artist];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setNumberOfLines:3];
        [titleLabel setHighlighted:YES];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [titleLabel setText:songtitle];
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];UIImage *image = [artwork imageWithSize:CGSizeMake(300, 200)];
        imageView.image = image;self.view.backgroundColor = [UIColor blackColor];
    }
    return;
}
    if ([playButton.title isEqualToString:@"Pause"])
    {
        [musicPlayerController pause];
        playButton.title = @"Play";
        MPMediaItem *nowPlayItem = [musicPlayerController nowPlayingItem];
        if (nowPlayItem)
        {
            MPMediaItemArtwork *artwork = [nowPlayItem valueForProperty:MPMediaItemPropertyArtwork];
            NSString *songtitle = [nowPlayItem valueForProperty:MPMediaItemPropertyTitle];
            NSString *albumTitle = [nowPlayItem valueForProperty:MPMediaItemPropertyAlbumTitle];
            NSString *artist = [nowPlayItem valueForProperty:MPMediaItemPropertyArtist];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
            songtitle = [songtitle stringByAppendingString:@"/n"];songtitle = [songtitle stringByAppendingString:albumTitle];
            songtitle = [songtitle stringByAppendingString:@"/n"];
            songtitle = [songtitle stringByAppendingString:artist];
            titleLabel.backgroundColor = [UIColor clearColor];
            [titleLabel setNumberOfLines:3];
            [titleLabel setHighlighted:YES];
            [titleLabel setTextAlignment:UITextAlignmentCenter];
            [titleLabel setTextColor:[UIColor whiteColor]];
            [titleLabel setFont:[UIFont systemFontOfSize:12.0]];
            [titleLabel setText:songtitle];
            self.navigationItem.titleView = titleLabel;[titleLabel release];
            UIImage *image = [artwork imageWithSize:CGSizeMake(300, 200)];
            imageView.image = image;
            self.view.backgroundColor = [UIColor blackColor];
        }
        return;
    }
}
*/

@end
