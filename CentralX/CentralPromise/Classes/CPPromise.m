#import "CPPromise.h"
#import <libkern/OSAtomic.h>
#import <CentralX/CentralRuntime.h>

#define isError(obj) [obj isKindOfClass:[NSError class]]
#define isPromise(obj) [obj isKindOfClass:[CPPromise class]]
#define isInvocation(obj) [obj isKindOfClass:[NSInvocation class]]
#define isBlock(obj) [obj isKindOfClass:NSClassFromString(@"NSBlock")]
#define isArray(obj) [obj isKindOfClass:[NSArray class]]

NSString * const CPPromiseInternalErrorsKey = @"com.central-x.promise.internalErrorKey";

NSError *NSErrorMake(id _Nullable internalErrors, NSString *localizedDescription, ...){
    static NSString *domain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        domain = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
        domain = domain ?: @"none domain";
    });
    
    va_list desc_args;
    va_start(desc_args, localizedDescription);
    NSString *desc = [[NSString alloc] initWithFormat:localizedDescription arguments:desc_args];
    va_end(desc_args);
    
    return [NSError errorWithDomain:domain code:-1000 userInfo:@{
                                                                 NSLocalizedDescriptionKey: desc,
                                                                 CPPromiseInternalErrorsKey: internalErrors ?: [NSNull null]
                                                                 }];
}

NSError *NSErrorWithUserInfo(NSDictionary *userInfo, NSString *localizedDescription, ...){
    static NSString *domain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        domain = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
        domain = domain ?: @"none domain";
    });
    
    va_list desc_args;
    va_start(desc_args, localizedDescription);
    NSString *desc = [[NSString alloc] initWithFormat:localizedDescription arguments:desc_args];
    va_end(desc_args);
    
    NSMutableDictionary *userinfo = userInfo.mutableCopy;
    userinfo[NSLocalizedDescriptionKey] = desc;
    
    return [NSError errorWithDomain:domain code:-1000 userInfo:userinfo];
}

NSInvocation *NSInvocationMake(id target, SEL action){
    NSCParameterAssert([target respondsToSelector:action]);
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:action]];
    invocation.target = target;
    invocation.selector = action;
    return invocation;
}

static id __execute__(id target, id args){
    NSCParameterAssert(isBlock(target) || isInvocation(target));
    
    NSMethodSignature *signature;
    id invocation;
    
    if (isBlock(target)) {
        invocation = [CRBlockInvocation invocationWithBlock:target];
        signature = [invocation blockSignature].signature;
        if (args && signature.numberOfArguments > 1) {
            [invocation setArgument:&args atIndex:1];
        }
    }else{
        //target is NSInvocation object
        invocation = target;
        signature = [target methodSignature];
        if (args && signature.numberOfArguments > 2) {
            [invocation setArgument:&args atIndex:2];
        }
    }
    
    const char returnType = signature.methodReturnType[0];
    NSCAssert(returnType == '@' || returnType == 'v', @"CPPromise无法处理非对象返回值，返回值必须是OC对象");
    
    @try {
        [invocation invoke];
        
        if (returnType == 'v') { return nil; }
        __unsafe_unretained id result;
        [invocation getReturnValue:&result];
        return result;
    }
    @catch (NSError *error) {// just catch NSError
        return error;
    }
}

@interface CPPromise ()
//@property (nonatomic) dispatch_queue_t barrier;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) NSMutableArray<CPResolve> *handlers;
@property (nonatomic, assign) CPPromiseState state;
@end

/**
 * Central Promise
 *
 * @author Alan Yeh
 * @since 2022/05/19
 */
@implementation CPPromise
static dispatch_queue_t _barrier = nil;
- (dispatch_queue_t)barrier{
    return _barrier ?: (_barrier = dispatch_queue_create("com.central-x.promise.barrier", DISPATCH_QUEUE_CONCURRENT));
}

- (NSMutableArray *)handlers{
    return _handlers ?: (_handlers = [NSMutableArray new]);
}


/**
 *  创建一个未执行的Promise
 */
- (instancetype)initWithResolver:(void (^)(CPResolve))resolver andExecuteQueue:(dispatch_queue_t)queue{
    if (self = [super init]) {
        self.state = CPPromiseStatePending;
        
        CPResolve __presolve = ^(id result){
            __block NSMutableArray *handlers;
            //保证执行链的顺序执行
            dispatch_barrier_sync(self.barrier, ^{
                //race
                if (self.state == CPPromiseStatePending) {
                    handlers = self.handlers;
                    
                    if (isError(result)) {
                        self.state = CPPromiseStateRejected;
                    }else{
                        self.state = CPPromiseStateFulfilled;
                    }
                    self.value = result;
                }
            });
            for (CPResolve handler in handlers) {
                handler(result);
            }
        };
        
        CPResolve __resolve = ^(id result){
            if (self.state & CPPromiseStatePending) {
                if (isPromise(result)) {
                    [result pipe:__presolve];
                }else{
                    __presolve(result);
                }
            }
        };
        //创建好之后，直接开始执行任务
        dispatch_async(queue, ^{
            @try {
                resolver(__resolve);
            }
            @catch (NSError *error) {
                __resolve(error);
            }
        });
    }
    return self;
}

- (instancetype)initWithResolver:(void (^)(CPResolve))resolver{
    return [self initWithResolver:resolver andExecuteQueue:dispatch_get_main_queue()];
}

/**
 *  创建一个已完成的Promise
 *  如果Value是Promise对象，则直接返回
 *  如果Value是NSError对象，则返回一个Rejected状态的Promise
 *  如果Vlaue是其它对象，则返回一个Fulfilled状态的Promise
 */
- (instancetype)initWithValue:(id)value{
    if (isPromise(value)) {
        return value;
    }
    if (self = [super init]) {
        if (isError(value)) {
            _state = CPPromiseStateRejected;
            self.value = value;
        }else{
            _state = CPPromiseStateFulfilled;
            self.value = value;
        }
    }
    return self;
}
/**
 *  拼接Promise
 *  如果当前Promise还没有被执行，则接接在当前Promise的执行栈中
 *  如果当前Promise已经执行了，则直接将当前Promise的值传给下一个执行者
 */
- (void)pipe:(CPResolve)resolve{
    if (self.state == CPPromiseStatePending) {
        [self.handlers addObject:resolve];
    }else{
        resolve(self.value);
    }
}

/**
 *  创建一个Promise,并拼接在Promise(self)的执行链中
 *
 */
static inline CPPromise *__pipe(CPPromise *self, void(^then)(id, CPResolve)){
    return [[CPPromise alloc] initWithResolver:^(CPResolve resolver) {
        [self pipe:^(id result) {
            then(result, resolver);//handle resule of previous promise
        }];
    }];
}

/**
 *  将Promise拼接在self之后,仅处理正确的逻辑
 */
static inline CPPromise *__then(CPPromise *self, dispatch_queue_t queue, id block){
    return __pipe(self, ^(id result, CPResolve resolver) {
        if (isError(result)) {
            resolver(result);
        }else{
            dispatch_async(queue, ^{
                resolver(__execute__(block, result));
            });
        }
    });
}
/**
 *  将Promise接接在self之后,仅处理错误的逻辑
 */
static inline CPPromise *__catch(CPPromise *self, dispatch_queue_t queue, id block){
    return __pipe(self, ^(id result, CPResolve resolver) {
        if (isError(result)) {
            dispatch_async(queue, ^{
                resolver(__execute__(block, result));
            });
        }else{
            resolver(result);
        }
    });
}

@end

@implementation CPPromise (CommonJS)
+ (CPPromise *(^)(id))resolve{
    return ^(id value){
        return [[self alloc] initWithValue:value];
    };
}

+ (CPPromise *(^)(NSArray<CPPromise *> *))all{
    return ^(NSArray<CPPromise *> *promises){
        return [[CPPromise alloc] initWithResolver:^(CPResolve resolve) {
            NSAssert(isArray(promises), @"all can only hand array");
            
            __block int64_t totalCount = [promises count];
            NSMutableArray *holders = [NSMutableArray arrayWithArray:promises];
            
            for (__strong id promise in promises) {
                
                if (!isPromise(promise)) {
                    promise = CPPromise.resolve(promise);
                }
                [promise pipe:^(id result) {
                    if (isError(result)) {
                        resolve([NSError errorWithDomain:@"cn.yerl.promise"
                                                    code:-1000
                                                userInfo:@{NSLocalizedDescriptionKey: [result localizedDescription],
                                                           CPPromiseInternalErrorsKey: result}]);
                    }else if (OSAtomicDecrement64(&totalCount) == 0){
                        NSMutableArray *results = [NSMutableArray new];
                        for (CPPromise *promise in holders) {
                            id value = isPromise(promise) ? [promise value] : promise;
                            [results addObject:value ?: [NSNull null]];
                        }
                        [holders removeAllObjects];
                        resolve(results);
                    }
                }];
            }
        }];
    };
}

+ (CPPromise *(^)(NSArray<CPPromise *> *))race{
    return ^(NSArray<CPPromise *> *promises){
        NSAssert(isArray(promises), @"race can only hand array");
        
        return [[CPPromise alloc] initWithResolver:^(CPResolve resolve) {
            __block int64_t totalCount = [promises count];
            NSMutableArray *holders = [NSMutableArray arrayWithArray:promises];
            
            for (__strong id promise in promises) {
                if (!isPromise(promise)) {
                    promise = [[CPPromise alloc] initWithValue:promise];
                }
                
                [promise pipe:^(id result) {
                    if (!isError(result)) {
                        [holders removeAllObjects];
                        resolve(result);
                    } else if (OSAtomicDecrement64(&totalCount) == 0){
                        NSMutableArray *errors = [NSMutableArray new];
                        for (CPPromise *promise in holders) {
                            [errors addObject:isPromise(promise) ? [promise value] : promise];
                        }
                        [holders removeAllObjects];
                        resolve([NSError errorWithDomain:@"cn.yerl.promise"
                                                    code:-1000
                                                userInfo:@{NSLocalizedDescriptionKey: @"all promise were rejected",
                                                           CPPromiseInternalErrorsKey: errors}]);
                    }
                }];
            }
        }];
    };
}

- (CPPromise *(^)(id))then{
    return ^id(id value){
        if (isBlock(value) || isInvocation(value)) {
            return __then(self, dispatch_get_main_queue(), value);
        }else if (isPromise(value)){
            return __then(self, dispatch_get_main_queue(), ^{
                return value;
            });
        }else{
            NSAssert(NO, @"[then] can only handle block/invocation/promise");
            return nil;
        }
    };
}

- (CPPromise *(^)(id))catch{
    return ^(id value){
        NSAssert(isBlock(value) || isInvocation(value), @"[catch] can only handle block/invocation.");
        return __catch(self, dispatch_get_main_queue(), value);
    };
}
@end

@implementation CPPromise (Extension)
- (CPPromise *(^)(id))thenAsync{
    return ^(id value){
        NSAssert(isBlock(value) || isInvocation(value), @"[thenAsync] can only handle block/invocation.");
        return __then(self, dispatch_get_global_queue(0, 0), value);
    };
}

- (CPPromise *(^)(NSTimeInterval, id))thenDelay{
    return ^(NSTimeInterval delaySecond, id value){
        NSAssert(isBlock(value) || isInvocation(value), @"[thenDelay] can only handle block/invocation.");
        return __pipe(self, ^(id result, CPResolve resolver) {
            if (isError(result)) {
                resolver(result);
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        resolver(__execute__(value, result));
                    });
                });
            }
        });
    };
}

- (CPPromise *(^)(dispatch_queue_t, id))thenOn{
    return ^(dispatch_queue_t queue, id value){
        NSAssert(isBlock(value) || isInvocation(value), @"[thenOn] can only handle block/invocation.");
        return __then(self, queue, value);
    };
}

- (CPPromise * (^)(void (^)(id, CPResolve)))thenPromise{
    return ^(void (^resolver)(id, CPResolve)){
        return __pipe(self, ^(id result, CPResolve resolve) {
            if (!isError(result)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    @try {
                        resolver(result, resolve);
                    }
                    @catch (NSError *error) {
                        resolve(error);
                    }
                });
            }else{
                resolve(result);
            }
        });
    };
}

- (CPPromise * (^)(void (^)(id, CPResolve)))thenAsyncPromise{
    return ^(void (^resolver)(id, CPResolve)){
        return __pipe(self, ^(id result, CPResolve resolve) {
            if (!isError(result)) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    @try {
                        resolver(result, resolve);
                    }
                    @catch (NSError *error) {
                        resolve(error);
                    }
                });
            }else{
                resolve(result);
            }
        });
    };
}

- (CPPromise *(^)(id))catchAsync{
    return ^(id value){
        NSAssert(isBlock(value) || isInvocation(value), @"[catchAsync] can only handle block/invocation.");
        return __catch(self, dispatch_get_global_queue(0, 0), value);
    };
}

- (CPPromise *(^)(dispatch_queue_t, id))catchOn{
    return ^(dispatch_queue_t queue, id value){
        NSAssert(isBlock(value) || isInvocation(value), @"[catchOn] can only handle block/invocation.");
        return __catch(self, queue, value);
    };
}

- (CPPromise *(^)(id))always{
    return ^(id value){
        NSAssert(isBlock(value) || isInvocation(value), @"[always] can only handle block/invocation.");
        return __pipe(self, ^(id result, CPResolve resolver) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @try {
                    resolver(__execute__(value, result));
                }
                @catch (NSError *error) {
                    resolver(error);
                }
            });
        });
    };
}
@end


CPPromise *CPPromiseWith(id value){
    if (isBlock(value) || isInvocation(value)) {
        return CPPromise.resolve(nil).then(value);
    }else if (isArray(value) && [value count] > 0){
        return CPPromise.all(value);
    }else {
        return [[CPPromise alloc] initWithValue:value];
    }
}

CPPromise *CPPromiseAsyncWith(id value){
    if (isBlock(value) || isInvocation(value)) {
        return CPPromise.resolve(nil).thenAsync(value);
    }else{
        return CPPromiseWith(value);
    }
}

CPPromise *CPPromiseWithResolve(void (^resolver)(CPResolve)){
    return [[CPPromise alloc] initWithResolver:resolver];
}

CPPromise *CPPromiseAsyncWithResolve(void (^resolver)(CPResolve)){
    return [[CPPromise alloc] initWithResolver:resolver andExecuteQueue:dispatch_get_global_queue(0, 0)];
}
