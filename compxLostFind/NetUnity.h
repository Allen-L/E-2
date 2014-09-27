//
//  NetUnity.h
//  MyNetworkWebview
//
//  Created by Compx-LK on 13-12-8.
//  631965569@qq.com
//  网络可达性检测


#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
@interface NetUnity : NSObject
+(BOOL)networkreachable;
@end
