#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBComponent;
@class CBInvocation;

typedef NS_ENUM(NSInteger, CBMethodType) {
    CBMethodGetter = 0, /**< property getter */
    CBMethodSetter = 1, /**< property setter */
    CBMethodFunction = 2 /**< function*/
};

/**
 * Component Method
 *
 * @author Alan Yeh
 * @since 2022/05/19
 */
@interface CBMethod : NSObject
- (instancetype)initWithClass:(Class)clazz selector:(SEL)selector property:(NSString *)property type:(CBMethodType)type;

@property (nonatomic, readonly) Class clazz;                     /**< Component class */
@property (nonatomic, readonly) NSString *method;                /**< Component method*/
@property (nonatomic, readonly) NSString *property;              /**< Component property */
@property (nonatomic, readonly) SEL selector;                    /**< Component method selector */
@property (nonatomic, readonly) CBMethodType type;               /**< Method type */
@property (nonatomic, copy) NSArray<NSString *> *permissions;    /**< Required permisstions */

@property (nonatomic, readonly) void(^invoke)(CBInvocation *, CBComponent *); /**< Method execution */
@end

NS_ASSUME_NONNULL_END
