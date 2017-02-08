//
//  ViewController.m
//  CocoaSyncSocket
//
//  Created by 涂耀辉 on 16/12/26.
//  Copyright © 2016年 涂耀辉. All rights reserved.
//

#import "ViewController.h"
#import "TYHSocketManager.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIButton *sendBtn;


@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@property (weak, nonatomic) IBOutlet UIButton *disConnectBtn;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    [_connectBtn addTarget:self action:@selector(connectAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_disConnectBtn addTarget:self action:@selector(disConnectAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];

}


//连接
- (void)connectAction
{
    BOOL isConnect = [[TYHSocketManager share] connect];
    if (isConnect ) {
        NSLog(@"开始连接...");
    }else{
        NSLog(@"连接失败");
    }

}
//断开连接
- (void)disConnectAction
{
    [[TYHSocketManager share] disConnect];
}

//发送消息
- (void)sendAction
{
   
    [[TYHSocketManager share]sendMsg];
}



@end
