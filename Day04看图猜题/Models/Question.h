//
//  Question.h
//  Day04看图猜题
//
//  Created by xxg415 on 2018/11/12.
//  Copyright © 2018 xxg415. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property(nonatomic,copy) NSString *answer;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *tittle;
@property(nonatomic,strong) NSArray *options;

-(instancetype)initwithDict:(NSDictionary *)dict;
+(instancetype)questionWithDict:(NSDictionary *)dict;

@end
