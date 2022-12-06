//
//  CRInvocation.h
//  AYAspect
//
//  Created by Alan Yeh on 16/8/1.
//
//

#import <Foundation/Foundation.h>

@class CRInvocationDetails;
@protocol CRInterceptor;

extern BOOL central_runtime_aspect_is_show_log;/**< whether show logs */

@interface CRInvocationProxy: NSProxy
@property (nonatomic, strong) NSInvocation *invocation;
@property (nonatomic, strong) NSArray<id<CRInterceptor>> *interceptors;
@property (nonatomic, assign) NSInteger index;
- (instancetype)initWithInvocation:(NSInvocation *)inovcation andInterceptors:(NSArray<id<CRInterceptor>> *)interceptors;
- (void)invoke;
@end

@interface NSObject (AY_INVOCATION_TARGET_INTERCEPTORS)
#pragma mark - for interceptor
- (Class)_ay_aspect_target;
- (void)_ay_set_aspect_target:(Class)target;
@end
