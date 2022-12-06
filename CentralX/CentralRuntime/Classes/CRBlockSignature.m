#import "CRBlockSignature.h"

struct CRBlockLiteral {
    void *isa; // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct block_descriptor {
        unsigned long int reserved;    // NULL
        unsigned long int size;         // sizeof(struct Block_literal_1)
        // optional helper functions
        void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
        void (*dispose_helper)(void *src);             // IFF (1<<25)
        // required ABI.2010.3.16
        const char *signature;                         // IFF (1<<30)
    } *descriptor;
    // imported variables
};

/**
 * Block Signature
 *
 * @author Alan yeh
 * @since 2022/05/20
 */
@implementation CRBlockSignature

+ (instancetype)signatureWithBlock:(id)block{
    return [[self alloc] initWithBlock:block];
}

- (id)initWithBlock:(id)block{
    if (self = [super init]) {
        _block = [block copy];
        
        struct CRBlockLiteral *blockRef = (__bridge struct CRBlockLiteral *)block;
        _flags = blockRef->flags;
        _size = blockRef->descriptor->size;
        
        if (_flags & CRBlockSignatureFlagsHasSignature) {
            void *signatureLocation = blockRef->descriptor;
            signatureLocation += sizeof(unsigned long int);
            signatureLocation += sizeof(unsigned long int);
            
            if (_flags & CRBlockSignatureFlagsHasCopyDispose) {
                signatureLocation += sizeof(void(*)(void *dst, void *src));
                signatureLocation += sizeof(void (*)(void *src));
            }
            
            const char *signature = (*(const char **)signatureLocation);
            _signature = [NSMethodSignature signatureWithObjCTypes:signature];
        }
    }
    return self;
}

- (BOOL)isCompatibleToMethodSignature:(NSMethodSignature *)methodSignature{
    if (_signature.numberOfArguments != methodSignature.numberOfArguments + 1) {
        return NO;
    }
    
    if (strcmp(_signature.methodReturnType, methodSignature.methodReturnType) != 0) {
        return NO;
    }
    
    for (int i = 0; i < methodSignature.numberOfArguments; i++) {
        if (i == 1) {
            // SEL in method, IMP in block
            if (strcmp([methodSignature getArgumentTypeAtIndex:i], ":") != 0) {
                return NO;
            }
            
            if (strcmp([_signature getArgumentTypeAtIndex:i + 1], "^?") != 0) {
                return NO;
            }
        } else {
            if (strcmp([methodSignature getArgumentTypeAtIndex:i], [_signature getArgumentTypeAtIndex:i + 1]) != 0) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@: %@", [super description], _signature.description];
}

@end
