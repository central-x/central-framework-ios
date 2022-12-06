//
//  CLLayerLayout.m
//  AYLayout
//
//  Created by Alan Yeh on 07/22/2016.
//  Copyright © 2015年 Alan Yeh. All rights reserved.
//

#import "CLLayerLayout.h"

typedef NS_ENUM(NSInteger, CLLayerLayoutMultiplyer) {
    CLLayerLayoutMultiplyerNegative = -1,  /**< 反向偏移 */
    CLLayerLayoutMultiplyerPositive = 1    /**< 正向偏移 */
};

@interface CALayer (AY_SUPER_SIZE)
@property (nonatomic, readonly) CGSize _superlayer_or_superview_size;/**< 父view或父layer的大小 */
@end

@interface CLResolveLayerX ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CLLayerLayoutMultiplyer multiplyer;
@property (nonatomic, weak) CALayer *layer;
@property (nonatomic, weak) CALayer *relatedLayer;
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(CLLayerLayoutMultiplyer)multiplyer;
@end

@interface CLResolveLayerY ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CLLayerLayoutMultiplyer multiplyer;
@property (nonatomic, weak) CALayer *layer;
@property (nonatomic, weak) CALayer *relatedLayer;
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(CLLayerLayoutMultiplyer)multiplyer;
@end

@interface CLResolveLayerCompleted ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CLLayerLayoutMultiplyer multiplyer;
@property (nonatomic, weak) CALayer *layer;
@property (nonatomic, weak) CALayer *relatedLayer;
@property (nonatomic, strong) id owner;
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location owner:(id)owner multiplyer:(CLLayerLayoutMultiplyer)multiplyer;
@end

@implementation CLLayerLayout{
    CGPoint _location;
    CGSize _size;
    CALayer *_layer;
    CALayer *_relatedLayer;
}
#pragma mark - 初始化
- (instancetype)initWithLayer:(CALayer *)layer{
    if (self = [super init]) {
        _layer = layer ?: [[self class] ay_nil_layer_for_layout];
        _size = _layer.ay_size;
        _location = _layer.ay_location;
    }
    return self;
}

+ (instancetype)layoutForLayer:(CALayer *)layer{
    return [[self alloc] initWithLayer:layer];
}

+ (CALayer *)ay_nil_layer_for_layout{
    static CALayer *ay_nil_layer_instance;
    static CALayer *ay_nil_layer_superlayer_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ay_nil_layer_instance = [CALayer layer];
        ay_nil_layer_superlayer_instance = [CALayer layer];
        [ay_nil_layer_superlayer_instance addSublayer:ay_nil_layer_instance];
    });
    return ay_nil_layer_instance;
}
#pragma mark - 设置大小
- (CLLayerLayout * _Nonnull (^)(CGFloat, CGFloat))withSize{
    return ^(CGFloat width, CGFloat height){
        self->_size = CGSizeMake(width, height);
        return self;
    };
}

- (CLLayerLayout * _Nonnull (^)(CGSize))withSizeS{
    return ^(CGSize size){
        self->_size = size;
        return self;
    };
}

#pragma mark - 决定X的属性
- (CLResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))toLeft{
    return ^(CALayer *_Nonnull layer){
        self->_location = CGPointMake(layer.ay_x - self->_size.width, self->_location.y);
        return [[CLResolveLayerY alloc] initWithLayer:self->_layer size:self->_size location:self->_location relatedLayer:layer multiplyer:CLLayerLayoutMultiplyerNegative];
    };
}

- (CLResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))alignLeft{
    return ^(CALayer *_Nonnull layer){
        self->_location = CGPointMake(layer.ay_x, self->_location.y);
        return [[CLResolveLayerY alloc] initWithLayer:self->_layer size:self->_size location:self->_location relatedLayer:layer multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))toRight{
    return ^(CALayer *_Nonnull layer){
        self->_location = CGPointMake(layer.ay_x + layer.ay_width, self->_location.y);
        return [[CLResolveLayerY alloc] initWithLayer:self->_layer size:self->_size location:self->_location relatedLayer:layer multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))alignRight{
    return ^(CALayer *_Nonnull layer){
        self->_location = CGPointMake(layer.ay_x + layer.ay_width - self->_size.width, self->_location.y);
        return [[CLResolveLayerY alloc] initWithLayer:self->_layer size:self->_size location:self->_location relatedLayer:layer multiplyer:CLLayerLayoutMultiplyerNegative];
    };
}

- (CLResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))alignCenterWidth{
    return ^(CALayer *_Nonnull layer){
        self->_location = CGPointMake(layer.ay_x + (layer.ay_width - self->_size.width) / 2, self->_location.y);
        return [[CLResolveLayerY alloc] initWithLayer:self->_layer size:self->_size location:self->_location relatedLayer:layer multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerY *)alignParentLeft{
    _location = CGPointMake(0, _location.y);
    return [[CLResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerY *)toParentLeft{
    _location = CGPointMake(-_size.width, _location.y);
    return [[CLResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerY *)alignParentRight{
    _location = CGPointMake(_layer._superlayer_or_superview_size.width - _size.width, _location.y);
    return [[CLResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerY *)toParentRight{
    _location = CGPointMake(_layer._superlayer_or_superview_size.width, _location.y);
    return [[CLResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerY *)alignParentCenterWidth{
    _location = CGPointMake((_layer._superlayer_or_superview_size.width - _size.width)/ 2, _location.y);
    return [[CLResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:CLLayerLayoutMultiplyerPositive];
}

#pragma mark - 决定Y的属性
- (CLResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))toTop{
    return ^(CALayer * _Nonnull layer){
        self->_location = CGPointMake(self->_location.x, layer.ay_y - self->_size.height);
        return [[CLResolveLayerX alloc] initWithLayer:self->_layer size:self->_size location:self->_location relatedLayer:layer multiplyer:CLLayerLayoutMultiplyerNegative];
    };
}

- (CLResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))alignTop{
    return ^(CALayer * _Nonnull layer){
        self->_location = CGPointMake(self->_location.x, layer.ay_y);
        return [[CLResolveLayerX alloc] initWithLayer:self->_layer size:self->_size location:self->_location relatedLayer:layer multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))toBottom{
    return ^(CALayer * _Nonnull layer){
        self->_location = CGPointMake(self->_location.x, layer.ay_y + layer.ay_height);
        return [[CLResolveLayerX alloc] initWithLayer:self->_layer size:self->_size location:self->_location relatedLayer:layer multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))alignBottom{
    return ^(CALayer * _Nonnull layer){
        self->_location = CGPointMake(self->_location.x, layer.ay_y + layer.ay_height - self->_size.height);
        return [[CLResolveLayerX alloc] initWithLayer:self->_layer size:self->_size location:self->_location relatedLayer:layer multiplyer:CLLayerLayoutMultiplyerNegative];
    };
}

- (CLResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))alignCenterHeight{
    return ^(CALayer * _Nonnull layer){
        self->_location = CGPointMake(self->_location.x, layer.ay_y + (layer.ay_height - self->_size.height) / 2);
        return [[CLResolveLayerX alloc] initWithLayer:self->_layer size:self->_size location:self->_location relatedLayer:layer multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerX *)alignParentTop{
    _location = CGPointMake(_location.x, 0);
    return [[CLResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerX *)toParentTop{
    _location = CGPointMake(_location.x, - _size.height);
    return [[CLResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerX *)alignParentBottom{
    _location = CGPointMake(_location.x, _layer._superlayer_or_superview_size.height - _size.height);
    return [[CLResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerX *)toParentBottom{
    _location = CGPointMake(_location.x, _layer._superlayer_or_superview_size.height + _size.height);
    return [[CLResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerX *)alignParentCenterHeight{
    _location = CGPointMake(_location.x, (_layer._superlayer_or_superview_size.height - _size.height) / 2);
    return [[CLResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (void)apply{
    _layer.ay_size = _size;
    _layer.ay_location = _location;
}
@end

@implementation CLResolveLayerX
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(CLLayerLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.layer = layer;
        self.size = size;
        self.location = location;
        self.relatedLayer = relatedLayer;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (CLResolveLayerX *)and{
    return self;
}

- (CLResolveLayerX * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        return self;
    };
}

- (CLResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignLeft{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ay_x, self.location.y);
        return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerCompleted *)alignLeftL{
    self.location = CGPointMake(self.relatedLayer.ay_x, self.location.y);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignRight{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ay_x + layer.ay_width - self.size.width, self.location.y);
        return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
    };
}

- (CLResolveLayerCompleted *)alignRightL{
    self.location = CGPointMake(self.relatedLayer.ay_x + self.relatedLayer.ay_width - self.size.width, self.location.y);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toLeft{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ay_x - self.size.width, self.location.y);
        return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
    };
}

- (CLResolveLayerCompleted *)toLeftL{
    self.location = CGPointMake(self.relatedLayer.ay_x - self.size.width, self.location.y);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toRight{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ay_x + layer.ay_width, self.location.y);
        return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerCompleted *)toRightL{
    self.location = CGPointMake(self.relatedLayer.ay_x + self.relatedLayer.ay_width, self.location.y);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignCenterWidth{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ay_x + (layer.ay_width - self.size.width) / 2, self.location.y);
        return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerCompleted *)alignCenterWidthL{
    self.location = CGPointMake(self.relatedLayer.ay_x + (self.relatedLayer.ay_width - self.size.width) / 2, self.location.y);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerCompleted *)alignParentLeft{
    self.location = CGPointMake(0, self.location.y);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerCompleted *)toParentLeft{
    self.location = CGPointMake(-self.size.width, self.location.y);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerCompleted *)alignParentRight{
    self.location = CGPointMake(self.layer._superlayer_or_superview_size.width - self.size.width, self.location.y);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerCompleted *)toParentRight{
    self.location = CGPointMake(self.layer._superlayer_or_superview_size.width + self.size.width, self.location.y);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerCompleted *)alignParentCenterWidth{
    self.location = CGPointMake((self.layer._superlayer_or_superview_size.width - self.size.width) / 2, self.location.y);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (void)apply{
    self.layer.ay_size = self.size;
    self.layer.ay_location = self.location;
}
@end

@implementation CLResolveLayerY
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(CLLayerLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.layer = layer;
        self.size = size;
        self.location = location;
        self.relatedLayer = relatedLayer;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (CLResolveLayerY *)and{
    return self;
}

- (CLResolveLayerY * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        return self;
    };
}

- (CLResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignTop{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ay_y);
        return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerCompleted *)alignTopL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ay_y);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignBottom{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ay_y + layer.ay_height - self.size.height);
        return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
    };
}

- (CLResolveLayerCompleted *)alignBottomL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ay_y + self.relatedLayer.ay_height - self.size.height);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toTop{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ay_y - self.size.height);
        return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
    };
}

- (CLResolveLayerCompleted *)toTopL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ay_y - self.size.height);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toBottom{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ay_y + layer.ay_height);
        return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerCompleted *)toBottomL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ay_y + self.relatedLayer.ay_height);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignCenterHeight{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ay_y + (layer.ay_height - self.size.height) / 2);
        return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
    };
}

- (CLResolveLayerCompleted *)alignCenterHeightL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ay_y + (self.relatedLayer.ay_height - self.size.height) / 2);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerCompleted *)alignParentTop{
    self.location = CGPointMake(self.location.x, 0);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerCompleted *)toParentTop{
    self.location = CGPointMake(self.location.x, -self.size.height);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerCompleted *)alignParentBottom{
    self.location = CGPointMake(self.location.x, self.layer._superlayer_or_superview_size.height - self.size.height);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerNegative];
}

- (CLResolveLayerCompleted *)toParentBottom{
    self.location = CGPointMake(self.location.x, self.layer._superlayer_or_superview_size.height + self.size.height);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (CLResolveLayerCompleted *)alignParentCenterHeight{
    self.location = CGPointMake(self.location.x, (self.layer._superlayer_or_superview_size.height - self.size.height) / 2);
    return [[CLResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:CLLayerLayoutMultiplyerPositive];
}

- (void)apply{
    self.layer.ay_size = self.size;
    self.layer.ay_location = self.location;
}
@end
@implementation CLResolveLayerCompleted
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location owner:(id)owner multiplyer:(CLLayerLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.layer = layer;
        self.size = size;
        self.location = location;
        self.owner = owner;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (CLResolveLayerCompleted * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        if ([self.owner isKindOfClass:[CLResolveLayerY class]]) {
            self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        }else{
            self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        }
        return self;
    };
}

- (void)apply{
    self.layer.ay_size = self.size;
    self.layer.ay_location = self.location;
}

@end


@implementation CALayer (CentralLayout)

- (CGFloat)ay_x{
    return self.position.x - self.anchorPoint.x * self.ay_width;
}

- (void)setAy_x:(CGFloat)ay_x{
    self.position = CGPointMake(ay_x + self.anchorPoint.x * self.ay_width, self.position.y);
}

- (CGFloat)ay_y{
    return self.position.y - self.anchorPoint.y * self.ay_height;
}

- (void)setAy_y:(CGFloat)ay_y{
    self.position = CGPointMake(self.position.x, ay_y + self.anchorPoint.y * self.ay_height);
}

- (CGFloat)ay_width{
    return self.bounds.size.width;
}

- (void)setAy_width:(CGFloat)ay_width{
    self.bounds = (CGRect){CGPointZero, CGSizeMake(ay_width, self.ay_height)};
}

- (CGFloat)ay_height{
    return self.bounds.size.height;
}

- (void)setAy_height:(CGFloat)ay_height{
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.ay_width, ay_height)};
}

- (CGSize)ay_size{
    return self.bounds.size;
}

- (void)setAy_size:(CGSize)ay_size{
    self.bounds = (CGRect){CGPointZero, ay_size};
}

- (CGPoint)ay_location{
    return CGPointMake(self.ay_x, self.ay_y);
}

- (void)setAy_location:(CGPoint)ay_location{
    self.position = CGPointMake(ay_location.x + self.anchorPoint.x * self.ay_width, ay_location.y + self.anchorPoint.y * self.ay_height);
}
@end

@implementation CALayer (AY_SUPER_SIZE)
- (CGSize)_superlayer_or_superview_size{
    NSAssert(self.superlayer, @"can't find superlayer in layer:%@", self);
    return self.superlayer.ay_size;
}
@end
