//
//  ViewController.m
//  CocoaSyncSocket
//
//  Created by 涂耀辉 on 16/12/26.
//  Copyright © 2016年 涂耀辉. All rights reserved.
//

#import "ViewController.h"
#import "TYHSocketManager.h"

#define KScreenWidth     [UIScreen mainScreen].bounds.size.width


@interface ViewController ()
{
    UIImageView *image;
}



@property (weak, nonatomic) IBOutlet UIButton *connectBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [_connectBtn addTarget:self action:@selector(connectAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, KScreenWidth, KScreenWidth)];
    image.backgroundColor = [UIColor redColor];
    [self.view addSubview:image];
    
    [TYHSocketManager share].recvImg = image;
    
}

//连接
- (void)connectAction
{
    [[TYHSocketManager share] accept];
    
}



@end
