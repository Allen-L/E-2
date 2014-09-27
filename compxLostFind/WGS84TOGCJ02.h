//
//  WGS84TOGCJ02.h
//  compxLostFind
//
//  Created by Compx on 14-5-19.
//  Copyright (c) 2014年 compx.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface WGS84TOGCJ02 : NSObject
//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;
@end
