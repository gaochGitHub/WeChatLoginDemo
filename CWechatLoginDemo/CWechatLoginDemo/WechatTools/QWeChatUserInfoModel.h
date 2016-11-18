//
//  QWeChatUserInfoModel.h
//  CWechatLoginDemo
//
//  Created by 高超 on 2016/11/18.
//  Copyright © 2016年 ChaoGao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QWeChatUserInfoModel : NSObject
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *headimgurl;
@property (nonatomic,strong) NSString *language;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *openid;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *unionid;

+(QWeChatUserInfoModel *)initWithDict:(NSDictionary *)dict;
@end
