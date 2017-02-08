//
//  TYHSocketManager.h
//  CocoaSyncSocket
//
//  Created by 涂耀辉 on 16/12/28.
//  Copyright © 2016年 涂耀辉. All rights reserved.
//




#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TYHSocketManager : NSObject

@property (nonatomic,weak)UIImageView *recvImg;

+ (instancetype)share;

- (BOOL)accept;


@end
