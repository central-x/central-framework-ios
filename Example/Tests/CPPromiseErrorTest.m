//
//  CPPromiseErrorTest.m
//  CentralX_Tests
//
//  Created by alan on 2022/5/20.
//  Copyright © 2022 yerl. All rights reserved.
//

#import <XCTest/XCTest.h>
@import CentralX;


#define TIME_OUT 1

@interface CPPromiseErrorTest : XCTestCase

@end

@implementation CPPromiseErrorTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testThen1 {
    id ex = [self expectationWithDescription:@""];
    
    CPPromiseWith(^{
        @throw NSErrorMake(nil, @"Error");
    }).then(^{
        XCTAssert(NO, @"这里不应该执行:%@", @"123");
    }).catch(^(NSError *error){
        XCTAssert([error.localizedDescription isEqualToString:@"Error"]);
    }).catch(^{
        XCTAssert(NO, @"这里不应该执行");
    }).always(^{
        [ex fulfill];
    });
    
    [self waitForExpectationsWithTimeout:TIME_OUT handler:nil];
}

- (void)testThen2{
    id ex = [self expectationWithDescription:@""];
    
    CPPromiseWith(^{
        return @"aaa";
    }).thenAsync(^{
        @throw NSErrorMake(nil, @"Error");
    }).then(^{
        XCTAssert(NO, @"这里不应该执行");
        return nil;
    }).catch(^(NSError *error) {
        XCTAssert([error.localizedDescription isEqualToString:@"Error"]);
    }).catch(^(NSError *error){
        XCTAssert(NO, @"这里不应该执行");
    }).always(^{
        [ex fulfill];
    });
    [self waitForExpectationsWithTimeout:TIME_OUT handler:nil];
}

- (void)testThen3{
    id ex = [self expectationWithDescription:@""];
    
    CPPromiseWith(^{
        return @"aaa";
    }).thenPromise(^(id result, CPResolve resolve){
        @throw NSErrorMake(nil, @"Error");
    }).then(^{
        XCTAssert(NO, @"这里不应该执行");
        return nil;
    }).catch(^(NSError *error) {
        XCTAssert([error.localizedDescription isEqualToString:@"Error"]);
    }).catch(^(NSError *error){
        XCTAssert(NO, @"这里不应该执行");
    }).always(^{
        [ex fulfill];
    });
    [self waitForExpectationsWithTimeout:TIME_OUT handler:nil];
}

- (void)testThen4{
    id ex = [self expectationWithDescription:@""];
    
    CPPromiseWith(^{
        return @"aaa";
    }).thenOn(dispatch_get_global_queue(0, 0), ^{
        @throw NSErrorMake(nil, @"Error");
    }).then(^{
        XCTAssert(NO, @"这里不应该执行");
        return nil;
    }).catch(^(NSError *error) {
        XCTAssert([error.localizedDescription isEqualToString:@"Error"]);
    }).catch(^(NSError *error){
        XCTAssert(NO, @"这里不应该执行");
    }).always(^{
        [ex fulfill];
    });
    [self waitForExpectationsWithTimeout:TIME_OUT handler:nil];
}

- (void)testCatch1{
    id ex = [self expectationWithDescription:@""];
    
    CPPromiseWith(^{
        @throw NSErrorMake(nil, @"abc");
    }).catch(^{
        @throw NSErrorMake(nil, @"Error");
    }).then(^{
        XCTAssert(NO, @"这里不应该执行");
        return nil;
    }).catch(^(NSError *error) {
        XCTAssert([error.localizedDescription isEqualToString:@"Error"]);
    }).catch(^(NSError *error){
        XCTAssert(NO, @"这里不应该执行");
    }).always(^{
        [ex fulfill];
    });
    [self waitForExpectationsWithTimeout:TIME_OUT handler:nil];
}

- (void)testCatch2{
    id ex = [self expectationWithDescription:@""];
    
    CPPromiseWith(^{
        @throw NSErrorMake(nil, @"abc");
    }).catchAsync(^{
        @throw NSErrorMake(nil, @"Error");
    }).then(^{
        XCTAssert(NO, @"这里不应该执行");
        return nil;
    }).catch(^(NSError *error) {
        XCTAssert([error.localizedDescription isEqualToString:@"Error"]);
    }).catch(^(NSError *error){
        XCTAssert(NO, @"这里不应该执行");
    }).always(^{
        [ex fulfill];
    });
    [self waitForExpectationsWithTimeout:TIME_OUT handler:nil];
}

- (void)testCatch3{
    id ex = [self expectationWithDescription:@""];
    
    CPPromiseWith(^{
        @throw NSErrorMake(nil, @"abc");
    }).catchOn(dispatch_get_global_queue(0, 0), ^{
        @throw NSErrorMake(nil, @"Error");
    }).then(^{
        XCTAssert(NO, @"这里不应该执行");
        return nil;
    }).catch(^(NSError *error) {
        XCTAssert([error.localizedDescription isEqualToString:@"Error"]);
    }).catch(^(NSError *error){
        XCTAssert(NO, @"这里不应该执行");
    }).always(^{
        [ex fulfill];
    });
    [self waitForExpectationsWithTimeout:TIME_OUT handler:nil];
}

- (void)testAlways{
    id ex = [self expectationWithDescription:@""];
    
    CPPromiseWith(^{
        @throw NSErrorMake(nil, @"abc");
    }).always(^{
        @throw NSErrorMake(nil, @"Error");
    }).then(^{
        XCTAssert(NO, @"这里不应该执行");
        return nil;
    }).catch(^(NSError *error) {
        XCTAssert([error.localizedDescription isEqualToString:@"Error"]);
    }).catch(^(NSError *error){
        XCTAssert(NO, @"这里不应该执行");
    }).always(^{
        [ex fulfill];
    });
    [self waitForExpectationsWithTimeout:TIME_OUT handler:nil];
}

@end
