//
//  YSSRequestManager.m
//  YodaSpeakShopkeep
//
//  Created by David Segal on 8/21/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//
//  Class to handle all api requests
//

#import "YSSRequestManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "YSSTranslatedTextModel.h"

@interface YSSRequestManager()

@end

@implementation YSSRequestManager


+ (id)sharedInstance {
    static YSSRequestManager *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    return sharedMyInstance;
}

// Translate yoda speak
-(void)getTranslationToYoda:(NSString *)message success:(void (^)(YSSTranslatedTextModel *))success failure:(void (^)(NSError *))failure
{
    NSLog(@"request : %@", message);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
    [manager.requestSerializer setValue:@"4Ko7AebC0Umshuyt6SgN7BEl6r09p1XXABajsnNSKMNXLw6KNW" forHTTPHeaderField:@"X-Mashape-Key"];
    manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    [manager GET:@"https://yoda.p.mashape.com/yoda" parameters:@{@"sentence": message} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (string)
        {
            NSLog(@"response : %@", string);
            YSSTranslatedTextModel *model = [[YSSTranslatedTextModel alloc] init];
            model.translatedText = string;
            success(model);
        }
        else
        {
            failure(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}


@end
