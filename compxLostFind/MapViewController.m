//
//  MapViewController.m
//  compxLostFind
//
//  Created by Compx on 14-5-4.
//  Copyright (c) 2014年 compx.com.cn. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame=[UIScreen mainScreen].bounds;
    
    
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    navigationBar.alpha=1.0;
    navigationBar.tintColor=[UIColor blackColor];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    //创建一个左边按钮
    leftButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"地图返回.png"] style:UIBarButtonItemStyleDone target:self action:@selector(gobackVC)];
    [navigationItem setTitle:@"Map Location"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    
    //取出来定位过的经纬度
    NSUserDefaults *userdefau=[NSUserDefaults standardUserDefaults];
    //[userdefau removeObjectForKey:@"compxLongitude"];
   // [userdefau removeObjectForKey:@"compxLatitude"];
    double mapLongitude=[userdefau doubleForKey:@"compxLongitude"];
    double mapLatitude=[userdefau doubleForKey:@"compxLatitude"];

    //2.地图
    mapLocationView=[[MKMapView alloc]init];
    mapLocationView.frame=CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height-64);
//    mapLocationView.delegate=self;
    
    CLLocationCoordinate2D Coordinate;
    
    if (mapLongitude==0 || mapLatitude==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"No-Location", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        Coordinate.longitude=114.038977;
        Coordinate.latitude=22.544279;
        
    }
    else
    {
        Coordinate.longitude=mapLongitude;
        Coordinate.latitude=mapLatitude;;
    }
    
    [self.view addSubview:mapLocationView];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(Coordinate, 350, 350);
    [mapLocationView setRegion:region animated:YES];
    mapLocationView.showsUserLocation=NO;
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Your-position-location", nil),@"Country",@"shenzhen",@"Locality", nil];
    shang=[[MKPlacemark alloc]initWithCoordinate:Coordinate addressDictionary:dic];
    [mapLocationView addAnnotation:shang];

    
    
    UIButton *showUserLocationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    showUserLocationBtn.frame=CGRectMake(15, 15, 35, 35);
    [showUserLocationBtn setImage:[UIImage imageNamed:@"mapLoc.png"] forState:UIControlStateNormal];
    [showUserLocationBtn addTarget:self action:@selector(showUserRecordLocation) forControlEvents:UIControlEventTouchUpInside];
    [mapLocationView addSubview:showUserLocationBtn];
    
}

-(void)gobackVC
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


-(void)showUserRecordLocation
{
    //先移除已经存在的大头针
    [mapLocationView removeAnnotation:shang];
    
    mapLocationView.delegate=self;
    mapLocationView.showsUserLocation=YES;
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(10_9, 4_0);
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 350, 350);
    [mapView setRegion:region animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
