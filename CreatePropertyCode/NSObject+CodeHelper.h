//
//  NSObject+CodeHelper.h
//  CreatePropertyCode
//
//  Created by 贺瑞 on 2017/5/18.
//  Copyright © 2017年 ifensi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CodeHelper)

@property NSString *baseClasName;

- (void)createPropertyCode;
- (NSString *)filePathWithExt:(NSString *)ext;

- (void)clear;
@end
