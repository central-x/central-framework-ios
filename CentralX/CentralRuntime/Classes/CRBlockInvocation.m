#import "CRBlockInvocation.h"
#import "CRBlockSignature.h"

/**
 * Block Invocation
 *
 * @author Alan yeh
 * @since 2022/05/20
 */
@implementation CRBlockInvocation {
    NSInvocation *_invocation;
}

+ (instancetype)invocationWithBlock:(id)block {
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id)block {
    if (self = [super init]){
        _blockSignature = [CRBlockSignature signatureWithBlock:block];
        _invocation = [NSInvocation invocationWithMethodSignature:_blockSignature.signature];
        [_invocation setTarget:[block copy]];
    }
    return self;;
}

- (NSMethodSignature *)signature{
    return self.blockSignature.signature;
}

- (void)retainArguments{
    [_invocation retainArguments];
}

- (BOOL)argumentsRetained{
    return [_invocation argumentsRetained];
}

- (void)getReturnValue:(void *)retLoc{
    [_invocation getReturnValue:retLoc];
}

- (void)setArgument:(void *)argLoc atIndex:(NSInteger)idx{
    [_invocation setArgument:argLoc atIndex:idx];
}

- (void)invoke{
    [_invocation invoke];
}

@end
