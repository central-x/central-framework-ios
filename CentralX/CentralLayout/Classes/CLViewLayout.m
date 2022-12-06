//
//  CLLayout.m
//  CLLayout
//
//  Created by Alan Yeh on 07/22/2016.
//  Copyright (c) 2015年 Alan Yeh. All rights reserved.
//

#import "CLViewLayout.h"

typedef NS_ENUM(NSInteger, CLViewLayoutMultiplyer) {
    CLViewLayoutMultiplyerNegative = -1, /**< 反向偏移 */
    CLViewLayoutMultiplyerPositive = 1   /**< 正向偏移 */
};

@interface CLResolveViewX ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CLViewLayoutMultiplyer multiplyer;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIView *relatedView;
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(CLViewLayoutMultiplyer)multiplyer;
@end

@interface CLResolveViewY ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CLViewLayoutMultiplyer multiplyer;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIView *relatedView;
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(CLViewLayoutMultiplyer)multiplyer;
@end

@interface CLResolveViewComplete ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CLViewLayoutMultiplyer multiplyer;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIView *relatedView;
@property (nonatomic, strong) id owner;
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location owner:(id)owner multiplyer:(CLViewLayoutMultiplyer)multiplyer;
@end

@implementation CLViewLayout{
    CGPoint _location;
    CGSize _size;
    UIView *_view;
    UIView *_relatedView;
}
#pragma mark - 初始化
+ (instancetype)layoutForView:(UIView *)view{
    return [[self alloc] initWithView:view];
}

- (instancetype)initWithView:(UIView *)view{
    if (self = [super init]) {
        _view = view ?: [[self class] ay_nil_view_for_layout];
        _size = _view.ay_size;
        _location = _view.ay_location;
    }
    return self;
}

+ (UIView *)ay_nil_view_for_layout{
    static UIView *ay_nil_view_instance;
    static UIView *ay_nil_view_superview_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ay_nil_view_instance = [UIView new];
        ay_nil_view_superview_instance = [UIView new];
        [ay_nil_view_superview_instance addSubview:ay_nil_view_instance];
    });
    
    return ay_nil_view_instance;
}

- (instancetype)init{
    return [self initWithView:[CLViewLayout ay_nil_view_for_layout]];
}
#pragma mark - 设置大小
- (CLViewLayout * _Nonnull (^)(CGFloat, CGFloat))withSize{
    return ^(CGFloat width, CGFloat height){
        self->_size = CGSizeMake(width, height);
        return self;
    };
}

- (CLViewLayout * _Nonnull (^)(CGSize))withSizeS{
    return ^(CGSize size){
        self->_size = size;
        return self;
    };
}

#pragma mark - 决定X的属性
- (CLResolveViewY * _Nonnull (^)(UIView * _Nonnull))toLeft{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self->_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self->_location = CGPointMake(view.ay_x - self->_size.width, self->_location.y);
        return [[CLResolveViewY alloc] initWithView:self->_view size:self->_size location:self->_location relatedView:view multiplyer:CLViewLayoutMultiplyerNegative];
    };
}

- (CLResolveViewY * _Nonnull (^)(UIView * _Nonnull))alignLeft{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self->_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self->_location = CGPointMake(view.ay_x, self->_location.y);
        return [[CLResolveViewY alloc] initWithView:self->_view size:self->_size location:self->_location relatedView:view multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewY * _Nonnull (^)(UIView * _Nonnull))toRight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self->_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self->_location = CGPointMake(view.ay_x + view.ay_width, self->_location.y);
        return [[CLResolveViewY alloc] initWithView:self->_view size:self->_size location:self->_location relatedView:view multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewY * _Nonnull (^)(UIView * _Nonnull))alignRight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self->_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self->_location = CGPointMake(view.ay_x + view.ay_width - self->_size.width, self->_location.y);
        return [[CLResolveViewY alloc] initWithView:self->_view size:self->_size location:self->_location relatedView:view multiplyer:CLViewLayoutMultiplyerNegative];
    };
}

- (CLResolveViewY * _Nonnull (^)(UIView * _Nonnull))alignCenterWidth{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self->_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self->_location = CGPointMake(view.ay_x + (view.ay_width - self->_size.width) / 2, self->_location.y);
        return [[CLResolveViewY alloc] initWithView:self->_view size:self->_size location:self->_location relatedView:view multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewY *)alignParentLeft{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(0, _location.y);
    return [[CLResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewY *)toParentLeft{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(-_size.width, _location.y);
    return [[CLResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewY *)alignParentRight{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_view.superview.ay_width - _size.width, _location.y);
    return [[CLResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewY *)toParentRight{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_view.superview.ay_width, _location.y);
    return [[CLResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewY *)alignParentCenterWidth{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake((_view.superview.ay_width - _size.width) / 2, _location.y);
    return [[CLResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:CLViewLayoutMultiplyerPositive];
}

#pragma mark - 决定Y的属性
- (CLResolveViewX * _Nonnull (^)(UIView * _Nonnull))toTop{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self->_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self->_location = CGPointMake(self->_location.x, view.ay_y - self->_size.height);
        return [[CLResolveViewX alloc] initWithView:self->_view size:self->_size location:self->_location relatedView:view multiplyer:CLViewLayoutMultiplyerNegative];
    };
}

- (CLResolveViewX * _Nonnull (^)(UIView * _Nonnull))alignTop{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self->_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self->_location = CGPointMake(self->_location.x, view.ay_y);
        return [[CLResolveViewX alloc] initWithView:self->_view size:self->_size location:self->_location relatedView:view multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewX * _Nonnull (^)(UIView * _Nonnull))toBottom{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self->_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self->_location = CGPointMake(self->_location.x, view.ay_y + view.ay_height);
        return [[CLResolveViewX alloc] initWithView:self->_view size:self->_size location:self->_location relatedView:view multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewX * _Nonnull (^)(UIView * _Nonnull))alignBottom{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self->_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self->_location = CGPointMake(self->_location.x, view.ay_y + view.ay_height - self->_size.height);
        return [[CLResolveViewX alloc] initWithView:self->_view size:self->_size location:self->_location relatedView:view multiplyer:CLViewLayoutMultiplyerNegative];
    };
}

- (CLResolveViewX * _Nonnull (^)(UIView * _Nonnull))alignCenterHeight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self->_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self->_location = CGPointMake(self->_location.x, view.ay_y + (view.ay_height - self->_size.height) / 2);
        return [[CLResolveViewX alloc] initWithView:self->_view size:self->_size location:self->_location relatedView:view multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewX *)alignParentTop{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, 0);
    return [[CLResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewX *)toParentTop{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, - _size.height);
    return [[CLResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewX *)alignParentBottom{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, _view.superview.ay_height - _size.height);
    return [[CLResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewX *)toParentBottom{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, _view.superview.ay_height + _size.height);
    return [[CLResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewX *)alignParentCenterHeight{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, (_view.superview.ay_height - _size.height) / 2);
    return [[CLResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:CLViewLayoutMultiplyerPositive];
}

- (void)apply{
    _view.frame = (CGRect){_location, _size};
}

@end

@implementation CLResolveViewX
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(CLViewLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.view = view;
        self.size = size;
        self.location = location;
        self.relatedView = relatedView;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (CLResolveViewX *)and{
    return self;
}

- (CLResolveViewX * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        return self;
    };
}

- (CLResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignLeft{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(view.ay_x, self.location.y);
        return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewComplete *)alignLeftV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ay_x, self.location.y);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignRight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(view.ay_x + view.ay_width - self.size.width, self.location.y);
        return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
    };
}

- (CLResolveViewComplete *)alignRightV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ay_x + self.relatedView.ay_width - self.size.width, self.location.y);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toLeft{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(view.ay_x - self.size.width, self.location.y);
        return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
    };
}

- (CLResolveViewComplete *)toLeftV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ay_x - self.size.width, self.location.y);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toRight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(view.ay_x + view.ay_width, self.location.y);
        return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewComplete *)toRightV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ay_x + self.relatedView.ay_width, self.location.y);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignCenterWidth{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(view.ay_x + (view.ay_width - self.size.width) / 2, self.location.y);
        return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewComplete *)alignCenterWidthV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ay_x + (self.relatedView.ay_width - self.size.width) / 2, self.location.y);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewComplete *)alignParentLeft{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(0, self.location.y);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewComplete *)toParentLeft{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(-self.size.width, self.location.y);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewComplete *)alignParentRight{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.view.superview.ay_width - self.size.width, self.location.y);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewComplete *)toParentRight{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.view.superview.ay_width + self.size.width, self.location.y);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewComplete *)alignParentCenterWidth{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake((self.view.superview.ay_width - self.size.width) / 2, self.location.y);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (void)apply{
    self.view.frame = (CGRect){self.location, self.size};
}
@end

@implementation CLResolveViewY
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(CLViewLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.view = view;
        self.size = size;
        self.location = location;
        self.relatedView = relatedView;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (CLResolveViewY *)and{
    return self;
}

- (CLResolveViewY * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        return self;
    };
}

- (CLResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignTop{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(self.location.x, view.ay_y);
        return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewComplete *)alignTopV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ay_y);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignBottom{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(self.location.x, view.ay_y + view.ay_height - self.size.height);
        return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
    };
}

- (CLResolveViewComplete *)alignBottomV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ay_y + self.relatedView.ay_height - self.size.height);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toTop{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(self.location.x, view.ay_y - self.size.height);
        return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
    };
}

- (CLResolveViewComplete *)toTopV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ay_y - self.size.height);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toBottom{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(self.location.x, view.ay_y + view.ay_height);
        return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewComplete *)toBottomV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ay_y + self.relatedView.ay_height);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignCenterHeight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(self.location.x, view.ay_y + (view.ay_height - self.size.height) / 2);
        return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
    };
}

- (CLResolveViewComplete *)alignCenterHeightV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ay_y + (self.relatedView.ay_height - self.size.height) / 2);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewComplete *)alignParentTop{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, 0);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewComplete *)toParentTop{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, -self.size.height);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewComplete *)alignParentBottom{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, self.view.superview.ay_height - self.size.height);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerNegative];
}

- (CLResolveViewComplete *)toParentBottom{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, self.view.superview.ay_height + self.size.height);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (CLResolveViewComplete *)alignParentCenterHeight{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, (self.view.superview.ay_height - self.size.height) / 2);
    return [[CLResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:CLViewLayoutMultiplyerPositive];
}

- (void)apply{
    self.view.frame = (CGRect){self.location, self.size};
}
@end

@implementation CLResolveViewComplete
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location owner:(NSObject *)owner multiplyer:(CLViewLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.view = view;
        self.size = size;
        self.location = location;
        self.owner = owner;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (CLResolveViewComplete * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        if ([self.owner isKindOfClass:[CLResolveViewY class]]) {
            self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        }else{
            self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        }
        return self;
    };
}

- (void)apply{
    self.view.frame = (CGRect){self.location, self.size};
}

@end

@implementation UIView(CentralLayout)

- (CGFloat)ay_x{
    return self.frame.origin.x;
}

- (void)setAy_x:(CGFloat)ay_x{
    self.frame = (CGRect){CGPointMake(ay_x, self.ay_y), self.ay_size};
}

- (CGFloat)ay_y{
    return self.frame.origin.y;
}

- (void)setAy_y:(CGFloat)ay_y{
    self.frame = (CGRect){CGPointMake(self.ay_x, ay_y), self.ay_size};
}

- (CGFloat)ay_width{
    return self.frame.size.width;
}

- (void)setAy_width:(CGFloat)ay_width{
    self.frame = (CGRect){self.ay_location, CGSizeMake(ay_width, self.ay_height)};
}

- (CGFloat)ay_height{
    return self.frame.size.height;
}

- (void)setAy_height:(CGFloat)ay_height{
    self.frame = (CGRect){self.ay_location, CGSizeMake(self.ay_width, ay_height)};
}

- (CGSize)ay_size{
    return self.frame.size;
}

- (void)setAy_size:(CGSize)ay_size{
    self.frame = (CGRect){self.ay_location, ay_size};
}

- (CGPoint)ay_location{
    return self.frame.origin;
}

- (void)setAy_location:(CGPoint)ay_location{
    self.frame = (CGRect){ay_location, self.ay_size};
}
@end
