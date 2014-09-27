//
//  BLEController.h
//  BLEofMy
//
//  Created by Compx on 13-11-5.
//  Copyright (c) 2013年 Compx.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>


/*一下的协议部分主要是用于把蓝牙4.0接收到的数据（如RSSI，电池电量，接收的外设发送的数据等）传给UI界面*/
@protocol BLEControllerDelegate <NSObject>
-(void) getCheckInfo:(NSString *)manuFaCtureInfo;//用于获取外设广播包里面的相关数据
-(void) peripheralUpdateNumbers:(NSMutableArray *)peripheralArray;//用于当手机扫描到新的外部设备，针对一对多
-(void) getNameAndUUID;//主要用于获取外设的设备名称
-(void) breakConnect;//当外设连接成功后，断开连接时调用，以便给UI通知
-(void) getCharAndUUID:(CBCharacteristic *)characteristic;//该方法主要用于当外设主动给手机发送某个数据时会调用，我们根据发送过来的characteristic判断是哪个UUID发送过来的值，以便做出相关的处理
-(void) getRSSIforDevice: (NSNumber *) DeviceRSSI;//该方法用于获取外设的RSSI
-(void) systemCloseblue;//该方法用于当用户在正常使用App时，突然自己关掉手机的蓝牙的回调
@end


@interface BLEController : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate> {
    id<BLEControllerDelegate> _delegate;
    
    NSString *devicePeripheralUUID;//设备的UUID
    NSMutableArray *peripheralArr;
    CBPeripheral *currentPeripheral;
    NSTimer *sendCheckDataTimer;
    
}
+(BLEController *) getInstance;
@property(assign, nonatomic) id<BLEControllerDelegate> delegate;
@property(strong, nonatomic) CBCentralManager *_centralMan;
@property(strong, nonatomic) CBPeripheral *_peripheral;

@end
