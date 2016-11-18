//
//  QWeChatLogin.h
//  CWechatLoginDemo
//
//  Created by 高超 on 2016/11/18.
//  Copyright © 2016年 ChaoGao. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "WXApi.h"
#import "QWeChatUserInfoModel.h"
#import "AFHTTPSessionManager.h"

//授权结束的回调
typedef void(^RequestWxUserInfoSuccessBlock)(NSDictionary *success);
typedef void(^RequestWxUserInfoFailBlock)(NSDictionary *fail);

@interface QWeChatLogin : NSObject
@property (nonatomic,copy) RequestWxUserInfoSuccessBlock wxUsrInfoBlocak;
@property (nonatomic,copy) RequestWxUserInfoFailBlock wxFailInfoBlocak;

+ (instancetype)defaultManager;

-(void)requestFor:(BaseResp *)resp;

- (void)wechatLoginByRequestForUserInfo;

-(void)checkWxTockenSuccess:(RequestWxUserInfoSuccessBlock)success Fail:(RequestWxUserInfoFailBlock)fail;

@end
