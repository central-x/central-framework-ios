#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Central Bridge Component
 * 
 * Base class for all components.
 *
 * @author Alan Yeh
 * @since 2022/05/19
 */
@interface CBComponent : NSObject
/**
 * Called after component has been created.
 */
- (void)onCreate:(NSDictionary<NSString *, id> *)options;

/**
 * Called after component has been destoried.
 */
- (void)onDestroy;
@end

NS_ASSUME_NONNULL_END
