//
//  YodaSpeakShopkeepTests.m
//  YodaSpeakShopkeepTests
//
//  Created by David Segal on 8/19/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSSRequestManager.h"
#import "YSSTranslatedTextModel.h"

@interface YodaSpeakShopkeepTests : XCTestCase

@end

@implementation YodaSpeakShopkeepTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testYodaRequest
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    BOOL __block wait = YES;
    
    [[YSSRequestManager sharedInstance] getTranslationToYoda:@"Once upon a midnight dreary. While I pondered weak and weary. Over many a quaint and curious volume of forgotten lore." success:^(YSSTranslatedTextModel *translatedModel) {
        wait = NO;
        XCTAssertTrue(translatedModel.translatedText.length > 0, @"tranlated text empty");
    } failure:^(NSError *error) {
        wait = NO;
        XCTAssertNotNil(error, @"empty error received");
    }];
    while (wait)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)testYodaUrlCaching
{
    BOOL __block wait = YES;
    NSLog(@"First request start");
    [[YSSRequestManager sharedInstance] getTranslationToYoda:@"Once upon a midnight dreary. While I pondered weak and weary. Over many a quaint and curious volume of forgotten lore." success:^(YSSTranslatedTextModel *translatedModel) {
        NSLog(@"First request complete");
        wait = NO;
        //XCTAssertTrue(translatedModel.translatedText.length > 0, @"" );
    } failure:^(NSError *error) {
        wait = NO;
        XCTAssertNotNil(error, @"empty error received");
    }];
    while (wait)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    wait = YES;
    NSLog(@"Second request start");
    [[YSSRequestManager sharedInstance] getTranslationToYoda:@"Once upon a midnight dreary. While I pondered weak and weary. Over many a quaint and curious volume of forgotten lore." success:^(YSSTranslatedTextModel *translatedModel) {
        NSLog(@"Second request complete");
        wait = NO;
        XCTAssertTrue(translatedModel.translatedText.length > 0, @"tranlated text empty" );
    } failure:^(NSError *error) {
        wait = NO;
        XCTAssertNotNil(error, @"empty error received");
    }];
    while (wait)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

@end
