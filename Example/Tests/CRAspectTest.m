//
//  CRAspectTest.m
//  CentralX_Tests
//
//  Created by alan on 2022/5/20.
//  Copyright © 2022 yerl. All rights reserved.
//

#import <XCTest/XCTest.h>
@import CentralX;

@interface CRAspectTestClass : NSObject
- (NSString *)hello:(NSString *)str;
- (CGPoint)pointByAddingPoint:(CGPoint)point;

- (NSString *)orginalString;
- (NSString *)orginalString2;
@end

@interface CRAspectTest : XCTestCase

@end

@implementation CRAspectTest

- (void)testAspectInstanceMethod{
    CRAspectTestClass *aspectedObject = [CRAspectTestClass new];
    CRAspectTestClass *unaspectedObject = [CRAspectTestClass new];
    
    NSString *originalString = [aspectedObject orginalString];
    XCTAssertEqualObjects(originalString, @"foo");
    
    NSString *originalString2 = [unaspectedObject orginalString];
    XCTAssertEqualObjects(originalString2, @"foo");
    
    [aspectedObject ay_interceptSelector:@selector(orginalString) withInterceptor:CRInterceptorMake(^(NSInvocation *invocation) {
        [invocation invoke];
        __unsafe_unretained NSString *result;
        [invocation getReturnValue:&result];
        XCTAssertEqualObjects(result, @"foo");
        NSString *newResult = [result stringByAppendingString:@"bar"];
        [invocation setReturnValue:&newResult];
        [invocation retainArguments];
    })];
    
    NSString *newString = [aspectedObject orginalString];
    XCTAssertEqualObjects(newString, @"foobar");
    
    //测试只拦截一个实例
    NSString *newString2 = [unaspectedObject orginalString];
    XCTAssertEqualObjects(newString2, @"foo");
}

- (void)testAspectClassMethod{
    CRAspectTestClass *aspectedObject = [CRAspectTestClass new];
    CRAspectTestClass *unaspectedObject = [CRAspectTestClass new];
    
    NSString *originalString = [aspectedObject orginalString2];
    XCTAssertEqualObjects(originalString, @"foo");
    
    NSString *originalString2 = [unaspectedObject orginalString2];
    XCTAssertEqualObjects(originalString2, @"foo");
    
    [CRAspectTestClass ay_interceptSelector:@selector(orginalString2) withInterceptor:CRInterceptorMake(^(NSInvocation *invocation) {
        [invocation invoke];
        __unsafe_unretained NSString *result;
        [invocation getReturnValue:&result];
        XCTAssertEqualObjects(result, @"foo");
        NSString *newResult = [result stringByAppendingString:@"bar"];
        [invocation setReturnValue:&newResult];
        [invocation retainArguments];
    })];
    
    NSString *newString = [aspectedObject orginalString2];
    XCTAssertEqualObjects(newString, @"foobar");
    
    //测试拦截所有实例
    NSString *newString2 = [unaspectedObject orginalString2];
    XCTAssertEqualObjects(newString2, @"foobar");
}

- (void)testStruct{
    CRAspectTestClass *aspectedObject = [CRAspectTestClass new];
    [aspectedObject ay_interceptSelector:@selector(pointByAddingPoint:) withInterceptor:CRInterceptorMake(^(NSInvocation *invocation) {
        CGPoint param;
        [invocation getArgument:&param atIndex:2];
        XCTAssert(CGPointEqualToPoint(param, CGPointMake(1.0, 1.0)));
        
        CGPoint newParam = CGPointMake(2.0, 2.0);
        [invocation setArgument:&newParam atIndex:2];
        
        [invocation invoke];
        
        CGPoint result;
        [invocation getReturnValue:&result];
        XCTAssert(CGPointEqualToPoint(result, CGPointMake(3.0, 3.0)));
        
        CGPoint newResult = CGPointMake(4.0, 4.0);
        [invocation setReturnValue:&newResult];
    })];
    
    CGPoint result = [aspectedObject pointByAddingPoint:CGPointMake(1.0, 1.0)];
    XCTAssert(CGPointEqualToPoint(result, CGPointMake(4.0, 4.0)));
}

@end


@implementation CRAspectTestClass
- (NSString *)hello:(NSString *)str{
    return [@"From instance: Hello " stringByAppendingString:str];
}

- (CGPoint)pointByAddingPoint:(CGPoint)point{
    return CGPointMake(point.x + 1.0f, point.y + 1.0f);
}

- (NSString *)orginalString{
    return @"foo";
}

- (NSString *)orginalString2{
    return @"foo";
}
@end
