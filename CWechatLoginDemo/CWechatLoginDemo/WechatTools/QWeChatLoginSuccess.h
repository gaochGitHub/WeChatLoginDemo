//
//  QWeChatLoginSuccess.h
//  CWechatLoginDemo
//
//  Created by 高超 on 2016/11/18.
//  Copyright © 2016年 ChaoGao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "WXApi.h"
typedef void(^WxLoginSuccessBlock)();
typedef void(^WxLoginFailedBlock) (NSString *err);

@interface QWeChatLoginSuccess : NSObject

+(void)loginOnViewController:(UIViewController *)viewController success:(WxLoginSuccessBlock)successBlock failed:(WxLoginFailedBlock)failedBlock;
@end
