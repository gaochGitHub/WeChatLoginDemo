//
//  QWeChatLoginSuccess.m
//  CWechatLoginDemo
//
//  Created by 高超 on 2016/11/18.
//  Copyright © 2016年 ChaoGao. All rights reserved.
//

#import "QWeChatLoginSuccess.h"

#import "QWeChatLogin.h"

@implementation QWeChatLoginSuccess


+(void)loginOnViewController:(UIViewController *)viewController success:(WxLoginSuccessBlock)successBlock failed:(WxLoginFailedBlock)failedBlock{
    
    [[QWeChatLogin defaultManager] checkWxTockenSuccess:^(NSDictionary *success) {
        /*
         参数：success    NSDictionary  --用户信息的字典
         示例：
         {
         city = ****;
         country = CN;
         headimgurl = "http://wx.qlogo.cn/mmopen/q9UTH59ty0K1PRvIQkyydYMia4xN3gib2m2FGh0tiaMZrPS9t4yPJFKedOt5gDFUvM6GusdNGWOJVEqGcSsZjdQGKYm9gr60hibd/0";
         language = "zh_CN";
         nickname = “****";
         openid = oo*********;
         privilege =     (
         );
         province = *****;
         sex = 1;
         unionid = “o7VbZjg***JrExs";
         }
         */
        //微信授权登录成功  要做的事情 写在这里
        NSLog(@"Success-UsrInfo:%@",success);
    
        
    } Fail:^(NSDictionary *fail) {
        /*
         授权失败的信息返回，可以读取信息debug
         示例：
         {
         errcode = 40001;
         errmsg = "invalid credential, access_token is invalid or not latest, hints: [ req_id: xwXvDa0754ns52 ]";
         }
         */
        NSLog(@"Fail-FailInfo:%@",fail);
        
    }];
    
}

@end
