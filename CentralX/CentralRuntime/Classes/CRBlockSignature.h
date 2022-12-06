#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CRBlockSignatureFlags) {
    CRBlockSignatureFlagsHasCopyDispose = (1 << 25),
    CRBlockSignatureFlagsHasCtor = (1 << 26), // helpers have C++ code
    CRBlockSignatureFlagsIsGlobal = (1 << 28),
    CRBlockSignatureFlagsHasStret = (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    CRBlockSignatureFlagsHasSignature = (1 << 30)
};

/**
 * Block Signature
 *
 * @author Alan yeh
 * @since 2022/05/20
 */
@interface CRBlockSignature : NSObject
@property (nonatomic, readonly) CRBlockSignatureFlags flags;
@property (nonatomic, readonly) NSMethodSignature *signature;
@property (nonatomic, readonly) unsigned long int size;
@property (nonatomic, readonly) id block;

+ (instancetype)signatureWithBlock:(id)block;
- (instancetype)initWithBlock:(id)block;

- (BOOL)isCompatibleToMethodSignature:(NSMethodSignature *)methodSignature;
@end

NS_ASSUME_NONNULL_END
