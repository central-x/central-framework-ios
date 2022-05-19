#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Central Bridge Application
 *
 * @author Alan Yeh
 * @since 2022/05/19
 */
@interface CBApplicationDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@end

API_AVAILABLE(ios(13.0))
@interface CBApplicationDelegate()<UISceneDelegate>

@end

NS_ASSUME_NONNULL_END
