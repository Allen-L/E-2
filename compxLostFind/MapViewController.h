//
//  MapViewController.h
//  compxLostFind
//
//  Created by Compx on 14-5-4.
//  Copyright (c) 2014年 compx.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView *mapLocationView;
    // 定位服务管理器
    CLLocationManager *locationManager; 
    // 使用地理编码器
    CLGeocoder          *_geocoder;
    
    //
    CLLocationCoordinate2D  clcoordinate;
    
    //大头针
    MKPlacemark *shang;
    
    MKCoordinateSpan theSpan;
    MKCoordinateRegion theRegion;
    
    
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
    
}
@end
