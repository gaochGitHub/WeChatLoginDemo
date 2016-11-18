//
//  QWeChatUserInfoModel.m
//  CWechatLoginDemo
//
//  Created by 高超 on 2016/11/18.
//  Copyright © 2016年 ChaoGao. All rights reserved.
//

#import "QWeChatUserInfoModel.h"

@implementation QWeChatUserInfoModel

+(QWeChatUserInfoModel *)initWithDict:(NSDictionary *)dict{
    
    QWeChatUserInfoModel *model = [[QWeChatUserInfoModel alloc] init];
    model.city = dict[@"city"];
    model.country = dict[@"country"];
    model.headimgurl = dict[@"headimgurl"];
    model.language = dict[@"language"];
    model.nickname = dict[@"nickname"];
    model.openid = dict[@"openid"];
    model.province = dict[@"province"];
    model.sex = dict[@"sex"];
    model.unionid = dict[@"unionid"];
    return model;
}
@end
