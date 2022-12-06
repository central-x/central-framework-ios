//
//  CRBlockInvocationTest.m
//  CentralX_Tests
//
//  Created by alan on 2022/5/20.
//  Copyright © 2022 yerl. All rights reserved.
//

#import <XCTest/XCTest.h>
@import CentralX;

@interface CRTestSwizzleClass : NSObject

- (NSString *)hello:(NSString *)str;
+ (NSString *)hello:(NSString *)str;

- (CGPoint)pointByAddingPoint:(CGPoint)point;

- (NSString *)orginalString;
- (NSString *)__hookedOriginalString;
@end



@interface CRBlockInvocationTest : XCTestCase

@end

@implementation CRBlockInvocationTest

- (void)testBlockDescription{
    BOOL(^testBlock)(BOOL, id) = ^BOOL(BOOL animated, id object) {
        return YES;
    };
    
    CRBlockSignature *blockSignature = [[CRBlockSignature alloc] initWithBlock:testBlock];
    NSMethodSignature *methodSignature = blockSignature.signature;
    
    XCTAssertEqual(strcmp(methodSignature.methodReturnType, @encode(BOOL)), 0, @"return type wrong");
    
    const char *expectedArguments[] = {@encode(typeof(testBlock)), @encode(BOOL), @encode(id)};
    for (int i = 0; i < blockSignature.signature.numberOfArguments; i++) {
        XCTAssertEqual(strcmp([blockSignature.signature getArgumentTypeAtIndex:i], expectedArguments[i]), 0, @"Argument %d wrong", i);
    }
}

- (void)testBlockInvocation{
    CGPoint (^block)(CGPoint) = ^CGPoint(CGPoint point) {
        XCTAssert(CGPointEqualToPoint(CGPointMake(1.0, 1.0), point));
        return CGPointMake(point.x + 1.0f, point.y + 1.0f);
    };
    
    CRBlockInvocation *invocation = [CRBlockInvocation invocationWithBlock:block];
    CGPoint point = CGPointMake(1.0, 1.0);
    [invocation setArgument:&point atIndex:1];
    
    [invocation invoke];
    CGPoint result;
    [invocation getReturnValue:&result];
    XCTAssert(CGPointEqualToPoint(CGPointMake(2.0, 2.0), result));
}

- (void)testBlockInvocation2{
    BOOL(^testBlock)(BOOL, id) = ^BOOL(BOOL animated, id object) {
        XCTAssert(animated == YES);
        XCTAssert([object isEqualToString:@"object"]);
        return YES;
    };
    
    CRBlockInvocation *invocation = [[CRBlockInvocation alloc] initWithBlock:testBlock];
    
    BOOL result = NO;
    BOOL animated = YES;
    NSString *object = @"object";
    [invocation setArgument:&animated atIndex:1];
    [invocation setArgument:&object atIndex:2];
    [invocation invoke];
    [invocation getReturnValue:&result];
    XCTAssert(result == YES);
}

- (void)testMethodReplace{
    CRTestSwizzleClass *testObject = [[CRTestSwizzleClass alloc] init];
    
    NSString *originalClassString = [CRTestSwizzleClass hello:@"Alan"];
    XCTAssertEqualObjects(originalClassString, @"From class: Hello Alan");
    
    NSString *originalInstanceString = [testObject hello:@"Alan"];
    XCTAssertEqualObjects(originalInstanceString, @"From instance: Hello Alan");
    
    __block IMP classImp = class_replaceClassMethodWithBlock([CRTestSwizzleClass class], @selector(hello:), ^NSString *(CRTestSwizzleClass *blockSelf, NSString *str){
        XCTAssertEqualObjects(blockSelf, [CRTestSwizzleClass class], @"blockSelf is wrong");
        return [@"Hooked: " stringByAppendingString:classImp(blockSelf, @selector(hello:), str)];
    });
    
    XCTAssertEqualObjects([CRTestSwizzleClass hello:@"Alan"], @"Hooked: From class: Hello Alan");
    XCTAssertEqualObjects([testObject hello:@"Alan"], @"From instance: Hello Alan");
    
    __block IMP instanceImp = class_replaceInstanceMethodWithBlock([CRTestSwizzleClass class], @selector(hello:), ^NSString *(CRTestSwizzleClass *blockSelf, NSString *str){
        XCTAssertEqualObjects(blockSelf, testObject, @"blockSelf is wrong");
        return [@"Hooked: " stringByAppendingString:instanceImp(blockSelf, @selector(hello:), str)];
    });
    
    XCTAssertEqualObjects([CRTestSwizzleClass hello:@"Alan"], @"Hooked: From class: Hello Alan");
    XCTAssertEqualObjects([testObject hello:@"Alan"], @"Hooked: From instance: Hello Alan");
    
    
    XCTAssert(CGPointEqualToPoint(CGPointMake(2.0f, 2.0f), [testObject pointByAddingPoint:CGPointMake(1.0f, 1.0f)]), @"initial point wrong");
    
    typedef CGPoint(*pointImplementation)(id self, SEL _cmd, CGPoint point);
    
    __block pointImplementation implementation3 = (pointImplementation)class_replaceInstanceMethodWithBlock([CRTestSwizzleClass class], @selector(pointByAddingPoint:), ^CGPoint(CRTestSwizzleClass *blockSelf, CGPoint point) {
        XCTAssertEqualObjects(blockSelf, testObject, @"blockSelf is wrong");
        
        CGPoint originalPoint = implementation3(blockSelf, @selector(pointByAddingPoint:), point);
        return CGPointMake(originalPoint.x + 1.0f, originalPoint.y + 1.0f);
    });
    
    XCTAssert(CGPointEqualToPoint(CGPointMake(3.0f, 3.0f), [testObject pointByAddingPoint:CGPointMake(1.0f, 1.0f)]), @"initial point wrong");
    
}

- (void)testMethodSwizzling{
    CRTestSwizzleClass *testObject = [[CRTestSwizzleClass alloc] init];
    NSString *originalString = testObject.orginalString;
    
    class_swizzleSelector(CRTestSwizzleClass.class, @selector(orginalString), @selector(__hookedOriginalString));
    
    NSString *hookedString = testObject.orginalString;
    
    XCTAssertFalse([originalString isEqualToString:hookedString], @"originalDescription cannot be equal to hookedDescription.");
    XCTAssertEqualObjects(originalString, @"foo", @"originalString wrong.");
    XCTAssertTrue([hookedString isEqualToString:@"foobar"], @"hookedDescription should have suffix 'bar'.");
}



- (void)testGetClassMethod{
    //Method forwarding = class_getInstanceMethod([CRTestSwizzleClass class], @selector(forwardingTargetForSelector:));
    //XCTAssert(forwarding == NULL);
    
    Method hello = class_getClassMethod([CRTestSwizzleClass class], @selector(hello:));
    XCTAssert(hello != NULL && method_getName(hello) == @selector(hello:));
}

- (void)testAssociatedObject{
    CRTestSwizzleClass *testObject = [[CRTestSwizzleClass alloc] init];
    objc_AssociationKey(AY_TEST_SWIZZLE_ASSOCIATION_KEY);
    NSString *str = objc_getAssociatedDefaultObject(testObject, AY_TEST_SWIZZLE_ASSOCIATION_KEY, @"abc", OBJC_ASSOCIATION_COPY);
    XCTAssert([str isEqualToString:@"abc"]);
    
    NSString *str2 = objc_getAssociatedObject(testObject, AY_TEST_SWIZZLE_ASSOCIATION_KEY);
    XCTAssert([str2 isEqualToString:@"abc"]);
    
    objc_AssociationKey(AY_TEST_SWIZZLE_ASSOCIATION_KEY2);
    NSString *str3 = objc_getAssociatedDefaultObjectBlock(testObject, AY_TEST_SWIZZLE_ASSOCIATION_KEY2, OBJC_ASSOCIATION_COPY, ^id{
        return @"aaa";
    });
    XCTAssert([str3 isEqualToString:@"aaa"]);
    
    NSString *str4 = objc_getAssociatedObject(testObject, AY_TEST_SWIZZLE_ASSOCIATION_KEY2);
    XCTAssert([str4 isEqualToString:@"aaa"]);
}

@end


@implementation CRTestSwizzleClass

- (NSString *)hello:(NSString *)str{
    return [@"From instance: Hello " stringByAppendingString:str];
}

+ (NSString *)hello:(NSString *)str{
    return [@"From class: Hello " stringByAppendingString:str];
}

- (CGPoint)pointByAddingPoint:(CGPoint)point{
    return CGPointMake(point.x + 1.0f, point.y + 1.0f);
}

- (NSString *)orginalString{
    return @"foo";
}

- (NSString *)__hookedOriginalString{
    NSString *original = [self __hookedOriginalString];
    return [original stringByAppendingString:@"bar"];
}
@end
