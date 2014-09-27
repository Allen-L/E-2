//
//  MusicViewController.h
//  compxLostFind
//
//  Created by Compx on 14-6-17.
//  Copyright (c) 2014年 compx.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#define notiMusicVcClose @"MusicVCClose"
@interface MusicViewController : UIViewController<MPMediaPickerControllerDelegate,AVAudioSessionDelegate,UIAlertViewDelegate>
{
    
    UIBarButtonItem *play;
    UIBarButtonItem *pause;
    UIBarButtonItem *preItem;
    UIBarButtonItem *nextItem;
    UIBarButtonItem *btnPlace;
    
    
    UISlider *volumeSlider;
    MPMusicPlayerController *player;
    MPMediaItemCollection *collection;
    
    BOOL MusicVCisPlaying;
    
    NSArray *tbaItemsArray;//底部的菜单栏
    
    
    UIView *playView;//底部的播放暂停部分
    UIButton *preItems;
    UIButton *nextItems;
    UIButton *playItems;
    
    
    //监听电话
    CTCallCenter *callCenterState;
    BOOL isCallComing;
    
}
@property (retain, nonatomic) UILabel *songLab;
@property (retain, nonatomic)  UILabel *artistLab;
@property (retain, nonatomic)  UIToolbar *toolbar;
@property (weak, nonatomic)  UILabel *status;
@property (retain, nonatomic)  UIImageView *imageView;
@property (retain, nonatomic)  UISlider *volumeSlider;
@property (retain, nonatomic) UIBarButtonItem *play;
@property (retain, nonatomic) UIBarButtonItem *pause;
@property (retain, nonatomic) MPMusicPlayerController *player;
@property (strong, nonatomic) MPMediaItemCollection *collection;
@property (nonatomic)  BOOL MusicVCisPlaying;

- (void)rewindPressed;
- (void)fastForwardPressed;
- (void)playPausePressed;
- (void)addPressed;
- (void)nowPlayingItemChanged;
- (void)backToMainView;
- (void)addVolume;
- (void)subVolume;

@end
