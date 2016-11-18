//
//  QWeChatLogin.m
//  CWechatLoginDemo
//
//  Created by 高超 on 2016/11/18.
//  Copyright © 2016年 ChaoGao. All rights reserved.
//

#import "QWeChatLogin.h"
#import "AFHTTPSessionManager.h"

@implementation QWeChatLogin


#pragma mark - Public Method
+ (instancetype)defaultManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark -check 本地是否有 授权 ，以及授权是否过期。有且没过期的话直接登录 否则 请求授权
-(void)checkWxTockenSuccess:(RequestWxUserInfoSuccessBlock)success Fail:(RequestWxUserInfoFailBlock)fail{
    self.wxUsrInfoBlocak = success;
    self.wxFailInfoBlocak = fail;
    [self sendAuthRequest];
}

-(void)checkLocalToken{
    
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kWeiXinAccessToken];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:kWeiXinOpenId];
    // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    if (accessToken && openID) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:kWeiXinRefreshToken];
        NSString *refreshUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWeiXinAppId,refreshToken];
        /*
         "access_token" = “Oez****5tXA";
         "expires_in" = 7200;
         openid = ooV****p5cI;
         "refresh_token" = “Oez****QNFLcA";
         scope = "snsapi_userinfo,";
         */
        
        [manager GET:refreshUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求reAccess的response = %@", responseObject);
            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *reAccessToken = [refreshDict objectForKey:@"access_token"];
            // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
            if (reAccessToken) {
                // 更新access_token、refresh_token、open_id
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:@"access_token"] forKey:kWeiXinAccessToken];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:@"openid"] forKey:kWeiXinOpenId];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:@"refresh_token"] forKey:kWeiXinRefreshToken];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                [self wechatLoginByRequestForUserInfo];
            }
            else {
                [self sendAuthRequest];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
        }];
        
    }
    else {
        [self sendAuthRequest];
    }
}

#pragma mark -发起授权请求
-(void)sendAuthRequest{
    
    //判断是否安装了 微信
    /*
     在“Info.plist”里增加如下代码：
     <key>LSApplicationQueriesSchemes</key>
     <array>
     <string>weixin</string>
     </array>
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     
     */
    if ([WXApi isWXAppInstalled]) {
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
        //        [WXApi sendReq:req];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QWechatLoginThereIsNoWechat" object:nil];
        
        
    }
    
}
#pragma makr - 根据code  获取token
-(void)requestFor:(BaseResp *)resp{
    SendAuthResp *temp = (SendAuthResp *)resp;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    NSString *accessUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWeiXinAppId,kWeiXinAppSecret,temp.code];
    
    [manager GET:accessUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求access的response = %@", responseObject);
        NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *accessToken = [accessDict objectForKey:@"access_token"];
        NSString *openID = [accessDict objectForKey:@"openid"];
        NSString *refreshToken = [accessDict objectForKey:@"refresh_token"];
        // 本地持久化，以便access_token的使用、刷新或者持续
        if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kWeiXinAccessToken];
            [[NSUserDefaults standardUserDefaults] setObject:openID forKey:kWeiXinOpenId];
            [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:kWeiXinRefreshToken];
            [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
        }
        [self wechatLoginByRequestForUserInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取access_token时出错 = %@", error);
    }];
}


#pragma mark -获取用户个人信息（UnionID机制）
- (void)wechatLoginByRequestForUserInfo {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kWeiXinAccessToken];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:kWeiXinOpenId];
    NSString *userUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openID];
    
    __weak typeof(self) weakSelf = self;
    
    // 请求用户数据
    [manager GET:userUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#pragma mark - 获取的个人信息在这里
        NSLog(@"请求用户信息的response = %@", responseObject);
        NSDictionary *userDict = [NSDictionary dictionaryWithDictionary:responseObject];
        if (userDict[@"errcode"]) {
            weakSelf.wxFailInfoBlocak(userDict);
            return;
        }
        if (weakSelf.wxUsrInfoBlocak) {
            weakSelf.wxUsrInfoBlocak(userDict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取用户信息时出错 = %@", error);
    }];
    
}
@end
