//
//  NetUnity.m
//  MyNetworkWebview
//
//  Created by Compx-LK on 13-12-8.
//  631965569@qq.com
//

#import "NetUnity.h"

@implementation NetUnity
+(BOOL)networkreachable;
{
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    address.sin_family=AF_INET;
    address.sin_len=sizeof(address);
    SCNetworkReachabilityRef ref=SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault,(const struct sockaddr *)&address);
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(ref, &flag);
    BOOL reach=((flag & kSCNetworkReachabilityFlagsReachable)!=0);
    BOOL netreach=((flag&kSCNetworkReachabilityFlagsConnectionRequired)==0);
    return reach&&netreach?YES:NO;
    
}
@end
