#import <Foundation/Foundation.h>
#import <CentralX/CBApplicationDelegate.h>
#import <CentralX/CBComponent.h>
#import <CentralX/CBDefine.h>
#import <CentralX/CBDescriber.h>
#import <CentralX/CBException.h>
#import <CentralX/CBWebView.h>
#import <CentralX/CBWebViewController.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Central Bridge
 *
 * @author Alan Yeh
 * @since 2022/05/19
 */
@interface CentralBridge : NSObject
+ (instancetype)bridge; /**< Singleton */

+ (instancetype)new CB_METHOD_UNAVAILABLE("Use CentralBridge.bridge");
- (instancetype)init CB_METHOD_UNAVAILABLE("Use CentralBridge.bridge");
@end

NS_ASSUME_NONNULL_END
