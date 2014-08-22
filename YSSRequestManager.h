//
//  YSSRequestManager.h
//  YodaSpeakShopkeep
//
//  Created by David Segal on 8/21/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSSTranslatedTextModel;

@interface YSSRequestManager : NSObject

+(id)sharedInstance;

-(void)getTranslationToYoda:(NSString *)message
                    success:(void (^)(YSSTranslatedTextModel *translatedModel))success
                      failure:(void (^)(NSError *error))failure;


@end
