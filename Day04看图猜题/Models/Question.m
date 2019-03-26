//
//  Question.m
//  Day04看图猜题
//
//  Created by xxg415 on 2018/11/12.
//  Copyright © 2018 xxg415. All rights reserved.
//

#import "Question.h"

@implementation Question
-(instancetype)initwithDict:(NSDictionary *)dict{
    if(self==[super init]){
        self.answer=dict[@"answer"];
        self.tittle=dict[@"tittle"];
        self.icon=dict[@"icon"];
        self.options=dict[@"options"];
    }
    return self;
}
+(instancetype)questionWithDict:(NSDictionary *)dict{
    return [[self alloc]initwithDict:dict];
}

@end
