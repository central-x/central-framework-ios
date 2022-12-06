//
//  CRAspect.h
//  CRAspect
//
//  Created by Alan Yeh on 16/8/1.
//
//

#import <Foundation/Foundation.h>

@protocol CRInterceptor <NSObject>
@required
/**
 *  拦截器
 *
 *  @param invocation 被拦截的方法
 *  Note: 1.如果需要执行原来的方法，需要调用[invocation invoke]，否则被拦截的方法不执行
 *        2.CRAspect将会持有拦截器的实例
 *
 *  已知BUG: 当同时拦截父类与子类的同一个方法时, 父类被拦载的方法将无法再被调用
 *  如果真的需要同时拦截父类与子类同一个方法, 建议在父类直接使用method swizzling进行拦截
 */
- (void)intercept:(NSInvocation *)invocation;
@end

FOUNDATION_EXPORT id<CRInterceptor> CRInterceptorMake(void (^block)(NSInvocation *invocation));

/**
 *  CRAspect
 *  ========================================================
 *
 */
@interface CRAspect : NSObject
+ (void)showLog:(BOOL)isShow;/**< 是否打印调试信息 */
@end

/**
 *  对所有类的实例进行增强
 *  注意：同时会影响其继承体系
 */
@interface CRAspect (Class)
/**
 *  使用Interceptor拦截实例方法
 *
 *  @param aSelector    目标拦截方法
 *  @param aClass       方法所在类
 *  @param aInterceptor 拦截器
 */
+ (void)interceptSelector:(SEL)aSelector inClass:(Class)aClass withInterceptor:(id<CRInterceptor>)aInterceptor;

/**清除Class下所有拦截器.*/
+ (void)clearInterceptorsForClass:(Class)aClass;

/**清除aSelector的所有拦截器.*/
+ (void)clearInterceptsForSelector:(SEL)aSelector inClass:(Class)aClass;
@end

/**
 *  对单个实例进行增强，不会影响其继承体系
 */
@interface CRAspect(Instance)
/**
 *  为一个实例的某个方法添加拦截器
 */
+ (void)interceptSelector:(SEL)aSelector inInstance:(id)aInstance withInterceptor:(id<CRInterceptor>)aInterceptor;
@end

@interface NSObject (CRAspect)
+ (void)ay_interceptSelector:(SEL)aSelector withInterceptor:(id<CRInterceptor>)aInterceptor;
- (void)ay_interceptSelector:(SEL)aSelector withInterceptor:(id<CRInterceptor>)aInterceptor;
@end
