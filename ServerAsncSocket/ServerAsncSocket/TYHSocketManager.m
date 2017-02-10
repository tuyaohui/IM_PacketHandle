//
//  TYHSocketManager.m
//  CocoaSyncSocket
//
//  Created by 涂耀辉 on 16/12/28.
//  Copyright © 2016年 涂耀辉. All rights reserved.
//

#import "TYHSocketManager.h"
#import "GCDAsyncSocket.h" // for TCP


static const uint16_t Kport = 6969;


@interface TYHSocketManager()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *gcdSocket;
    
    NSDictionary *currentPacketHead;
    
}

@property (nonatomic,strong)NSMutableArray *sockets;

@end

@implementation TYHSocketManager

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    static TYHSocketManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        [instance initSocket];
    });
    return instance;
}

- (void)initSocket
{
    gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    _sockets = [NSMutableArray array];
}


#pragma mark - 对外的一些接口

//等待连接
- (BOOL)accept
{
    NSError *error = nil;
    
    BOOL isSuccess =   [gcdSocket acceptOnPort:Kport error:&error];
    if (isSuccess) {
        NSLog(@"监听成功6969端口成功，等待连接");
        return YES;
    }else{
        NSLog(@"监听失败，原因：%@",error);
        return NO;
    }
}


#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"接受到客户端连接");
    
    [_sockets addObject:newSocket];
    [newSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:110];
}




- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //先读取到当前数据包头部信息
    if (!currentPacketHead) {
        currentPacketHead = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:NSJSONReadingMutableContainers
                             error:nil];
        
        
        if (!currentPacketHead) {
            NSLog(@"error：当前数据包的头为空");
            
            //断开这个socket连接或者丢弃这个包的数据进行下一个包的读取
            
            //....
            
            return;
        }
        
        NSUInteger packetLength = [currentPacketHead[@"size"] integerValue];
        
        //读到数据包的大小
        [sock readDataToLength:packetLength withTimeout:-1 tag:110];

        return;
    }

    
    //正式的包处理
    NSUInteger packetLength = [currentPacketHead[@"size"] integerValue];
    //说明数据有问题
    if (packetLength <= 0 || data.length != packetLength) {
        NSLog(@"error：当前数据包数据大小不正确");
        return;
    }
    
    NSString *type = currentPacketHead[@"type"];
    
    if ([type isEqualToString:@"img"]) {
        NSLog(@"图片设置成功");
        self.recvImg.image = [UIImage imageWithData:data];
    }else{
        
        NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"收到消息:%@",msg);
    }
    
    currentPacketHead = nil;
    
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:110];
}




@end
