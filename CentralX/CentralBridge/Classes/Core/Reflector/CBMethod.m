#import "CBMethod.h"

/**
 * Component Method
 *
 * @author Alan Yeh
 * @since 2022/05/19
 */
@implementation CBMethod
- (instancetype)initWithClass:(Class)clazz selector:(SEL)selector property:(NSString *)property type:(CBMethodType)type{
    if (self = [super init]) {
        _clazz = clazz;
        _selector = selector;
        _method = [NSStringFromSelector(selector) stringByReplacingOccurrencesOfString:@":" withString:@""];
        _property = property;
        _type = type;
    }
    return self;
}


@end
