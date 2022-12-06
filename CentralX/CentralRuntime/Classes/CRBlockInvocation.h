#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CRBlockSignature;
/**
 * Block Invocation
 *
 * @author Alan yeh
 * @since 2022/05/20
 */
@interface CRBlockInvocation : NSObject
@property (readonly) CRBlockSignature *blockSignature;
@property (readonly) NSMethodSignature *signature;

+ (instancetype)invocationWithBlock:(id)block;
- (instancetype)initWithBlock:(id)block;

- (void)retainArguments;
@property (readonly) BOOL argumentsRetained;

- (void)getReturnValue:(void *)retLoc;
- (void)setArgument:(void *)argLoc atIndex:(NSInteger)idx;/**< Index should start at 1. */

- (void)invoke;
@end

NS_ASSUME_NONNULL_END
