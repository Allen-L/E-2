//
//  BLEController.m
//  BLEofMy
//
//  Created by Compx on 13-11-5.
//  Copyright (c) 2013年 Compx.com.cn. All rights reserved.
//
#import "BLEController.h"

@implementation BLEController
@synthesize delegate;
@synthesize _centralMan;
@synthesize _peripheral;

#define checkPeripheralData1  @"56a90003"
#define checkPeripheralData2  @"56A90003"
static BLEController *sharedController=nil;
- (id)init {
    self = [super init];
    if (self) {
        _centralMan=[[CBCentralManager alloc]initWithDelegate:self queue:nil];//初始化CBCentralManager
        peripheralArr=[[NSMutableArray alloc]init];
    }
    return self;
}

//使用单列模式更节省
+(BLEController *) getInstance{
    @synchronized(self){
        if (sharedController == nil) {
            sharedController = [[self alloc] init];
        }
    }
    return  sharedController;
}

#pragma mark
#pragma CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //判断一下手机蓝牙的状态，以便做出相应的动作
    if (central.state==CBCentralManagerStatePoweredOn) {
        _centralMan=central;
        [_centralMan scanForPeripheralsWithServices:Nil options:Nil]; //手机的蓝牙处于打开状态，开始扫描外设
    }
    else if (central.state==CBCentralManagerStateUnsupported){
        //你的设备不支持蓝牙4.0
    }
    else if(central.state==CBCentralManagerStatePoweredOff )
    {
        [delegate systemCloseblue]; //系统的蓝牙处于关闭状态
    }
}

//此方法为发现外围设备时回调的方法，可以在这里向发现的设备请求连接
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    /*
    //将cfuuidref 类型装换为NSString*类型,获取设备标识符
    devicePeripheralUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef)([peripheral identifier])));
    NSLog(@"devicePeripheralUUID=%@",devicePeripheralUUID);
  */
    
    /*根据我们公司的自定义规则，会把自己产品相关的信息放到广播包里进行广播，如果扫描外设时没有相关的信息，那就认为不是我们公司的产品，不进行连接*/
    
    NSData *manufacturerData=[advertisementData valueForKey:CBAdvertisementDataManufacturerDataKey];
    
    NSString *ManufacturerString=[self receiveDataToString:manufacturerData];
    
    if (ManufacturerString.length==0 ||ManufacturerString ==NULL) {
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"广播包里面没有相关的ManufacturerData数据,不能建立连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
        return;
    }
    else if(ManufacturerString.length>=8)
    {
        /* 转换高低位*/
        NSString *check1=[ManufacturerString substringWithRange:NSMakeRange(0, 2)];
        NSString *check2=[ManufacturerString substringWithRange:NSMakeRange(2, 2)];
        NSString *check3=[ManufacturerString substringWithRange:NSMakeRange(4, 2)];
        NSString *check4=[ManufacturerString substringWithRange:NSMakeRange(6, 2)];
        
        NSString *checkStr=[check2 stringByAppendingString:check1];
        checkStr=[checkStr stringByAppendingString:check4];
        checkStr=[checkStr stringByAppendingString:check3];
        
        if ([checkStr isEqualToString:checkPeripheralData1] ||[checkStr isEqualToString:checkPeripheralData2]) {
            _peripheral=peripheral;
            [delegate getCheckInfo:ManufacturerString];
            [_centralMan connectPeripheral:_peripheral options:Nil];
            if (_peripheral.state==CBPeripheralStateConnecting) {
                [_centralMan stopScan];
            }
        }
    }
    else{
    }
    /*
    NSString *localName=[advertisementData valueForKey:CBAdvertisementDataLocalNameKey];
    
    NSLog(@"localName=%@",localName);

    if ([localName isEqualToString:@"compx"]) {
    }
    */
}

/*
-(void)connectDeviceOrNo
{
    if (peripheralArr.count==1) {
        CBPeripheral *per=[peripheralArr objectAtIndex:0];
        [_centralMan connectPeripheral:per options:Nil];
        if (per.state==CBPeripheralStateConnecting) {
            [_centralMan stopScan];
        }
    }
    else if (peripheralArr.count>1)
    {
        [delegate peripheralUpdateNumbers:peripheralArr];
    }
}
*/
/*
//定期读取外设的RSSI，由于该项目修改为外设来主动读取手机的RSSI，所以暂时不用执行
- (void)noticeToReadRSSI{
    [_peripheral readRSSI];
    
    [self performSelector:@selector(noticeToReadRSSI) withObject:nil afterDelay:0.2];
}
bool readRssiFlag=NO;
*/

//这里连接上设备以后需要调用[_peripheral discoverServices:nil];这个方法！这个方法不能少
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    /*
     //定期读取外设的RSSI
    if (readRssiFlag==NO) {
        [self noticeToReadRSSI];
        readRssiFlag=YES;
    }
     */
    _peripheral = peripheral;
    _peripheral.delegate = self;
    [_peripheral discoverServices:nil];//读取外设的服务信息
}

 //下面的回调方法是当中心设备central调用方法 [_centralMan connectPeripheral:_peripheral options:Nil];之后，如果连接失败了，自动回调的函数
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
{
    NSLog(@"Error Reason=%@",error);
}


/*成功连接上外设之后自动回调*/
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //设备意外的断开后，需要我们进行重连，除非是用户主动调用cancleconnection方法，则可以不调用重连方法
    if (error.code ==CBErrorConnectionTimeout) {
        [_centralMan connectPeripheral:_peripheral options:nil];
        [delegate breakConnect];
    }
    if (error.code==CBErrorOperationCancelled) {
        //NSLog(@"用户主动取消蓝牙连接，不用回连");
    }
    if (error.code==CBErrorUnknown) {
        // NSLog(@"已经和这台设备断开了连接：%@,原因是未知=%@",peripheral.name,error);
    }
    
    if (error.code==CBErrorPeripheralDisconnected) {
        //NSLog(@"外设主动跟我断开了");
    }
    [_centralMan connectPeripheral:_peripheral options:nil];
}


#pragma mark-
#pragma mark-CBPeripheralDelegate
/*发现外设服务之后自动回调的函数*/
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (int i=0; i < peripheral.services.count; i++) {
        CBService *s = [peripheral.services objectAtIndex:i];
        [peripheral discoverCharacteristics:nil forService:s]; //一次性读取外设的所有特征值
    } 
}
/*当外设的RSSI有更新时自动回调的函数*/
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error;
{
    /* 获取外设更新的RSSI，该项目里面没有用*/
     NSNumber *number=peripheral.RSSI;
    [delegate getRSSIforDevice:number];
}
/*当发现外设特征值之后自动回调的函数*/
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    /*当扫描到外设的characteristic时，该项目里需要向外设发送一个确认的消息，以便外设确认该App是我公司的App*/
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        [peripheral setNotifyValue:YES forCharacteristic:c];
        
        if ([[c UUID] isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
            
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//            [userDefaultes removeObjectForKey:@"checkData"];
            NSData *checkData=[userDefaultes dataForKey:@"checkDataCompxLostFind"];
            
            if (checkData.length==0 || checkData==NULL) {
                checkData=[self dataUesCheck];
                
                [userDefaultes setObject:checkData forKey:@"checkDataCompxLostFind"];
                [userDefaultes synchronize];
            }
 
            [_peripheral writeValue:checkData forCharacteristic:c type:CBCharacteristicWriteWithResponse];
            
            sendCheckDataTimer=[NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(sendCheckDataRepeats) userInfo:nil repeats:YES];
            
        }
        
        //禁用外设给手机主动发送RSSI的功能
        if ([[c UUID] isEqual:[CBUUID UUIDWithString:@"FFD2"]]) {
            [peripheral setNotifyValue:NO forCharacteristic:c];
        }
    }
    [delegate getNameAndUUID];
}
//当外设有值更新的时候，接收回调的方法，这这个函数里面接收外设发送的新数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [delegate getCharAndUUID:characteristic];//用于接收外围设备发送过来的数据的方法，将该值传到UI去处理
}

#pragma mark
#pragma mark-func
//将设备的UUID号转换为字符串类型，现在基本不用了
-(NSString*)UUIDToString:(CBUUID *)_uuid
{
    const unsigned char *serBytes = [_uuid.data bytes];
    return [NSString stringWithFormat:@"%02x%02x", serBytes[0], serBytes[1]];
}
//重复几次给外设发确认数据
int  sendCheckDataCounter=0;
-(void)sendCheckDataRepeats
{
    sendCheckDataCounter++;
    for (int i=0; i<_peripheral.services.count; i++) {
        CBService *cbp=[_peripheral.services objectAtIndex:i];
        if ([[cbp UUID] isEqual:[CBUUID UUIDWithString:@"FFF0"]]) {
            for (int j=0; j<cbp.characteristics.count; j++) {
                CBCharacteristic *cbc=[cbp.characteristics objectAtIndex:j];
                if ([[cbc UUID] isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
                    [_peripheral setNotifyValue:YES forCharacteristic:cbc];
                    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                    NSData *checkData=[userDefaultes dataForKey:@"checkDataCompxLostFind"];
                    
                    [_peripheral writeValue:checkData forCharacteristic:cbc type:CBCharacteristicWriteWithResponse];
                }
            }
        }
    }
    //发送次数达到了四次，停止发送
    if (sendCheckDataCounter>4) {
        if ([sendCheckDataTimer isValid]==TRUE) {
            [sendCheckDataTimer invalidate];
        }
    }
}
//转换接收的数据
-(NSString *)receiveDataToString:(NSData *)data{
    
    int dataLength =(int) data.length;
    const unsigned char *hexBytesLight = [data bytes];
    NSString *receivedataStr=@"";
    for (int i=0; i<dataLength; i++) {
        NSString *dataLengthStr=[NSString stringWithFormat:@"%02x",hexBytesLight[i]];
        receivedataStr=[receivedataStr stringByAppendingString:dataLengthStr];
    }
    return receivedataStr;
}
//用于发送的确认数据
-(NSData *)dataUesCheck
{
    Byte dataArr[11];
    dataArr[0]=0xa9;//公司ID，两个字节
    dataArr[1]=0x56;
    dataArr[2]=0x03;
    dataArr[3]=0x00;//应用ID，一个字节
    for (int i=4; i<10; i++) {
        dataArr[i]=arc4random()%256;  //随机数，六个字节
    }
    char YH=0;//check，一个字节
    for (int i=0; i<10; i++) {
        YH=YH^dataArr[i];
    }
    dataArr[10]=YH;
    NSData *ddd = [NSData dataWithBytes:dataArr length:11];
    return ddd;
}
@end
