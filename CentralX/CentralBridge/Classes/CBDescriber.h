#import <Foundation/Foundation.h>

/**
 * Object Describer
 *
 * @author Alan Yeh
 * @since 2022/05/19
 */
@protocol CBDescriber <NSObject>
- (NSString *)toJsonString;
- (NSString *)toPrettyJsonString;
- (NSDictionary *)toJsonObject;
@end
