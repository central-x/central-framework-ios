//
//  CLLayerLayout.h
//  CLLayout
//
//  Created by Alan Yeh on 07/22/2016.
//  Copyright © 2015年 Alan Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CLResolveLayerX;
@class CLResolveLayerY;
@class CLResolveLayerCompleted;

NS_ASSUME_NONNULL_BEGIN

#define CLLayoutL(layer) [CLLayerLayout layoutForLayer:layer]
/**
 *  Layer布局
 *  注: Parent系列布局函数, 在superlayer为空时, 则与layer所在的UIView中的位置进行布局
 */
@interface CLLayerLayout : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

+ (instancetype)layoutForLayer:(CALayer *)layer;
- (instancetype)initWithLayer:(CALayer *)layer NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) CLLayerLayout *(^withSize)(CGFloat width, CGFloat height);/**< 设置大小 */
@property (nonatomic, readonly) CLLayerLayout *(^withSizeS)(CGSize size);/**< 设置大小 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) CLResolveLayerY *(^alignLeft)(CALayer *relatedLayer);/**< 左对齐 */
@property (nonatomic, readonly) CLResolveLayerY *(^toLeft)(CALayer *relatedLayer);/**< 在左侧 */
@property (nonatomic, readonly) CLResolveLayerY *(^alignRight)(CALayer *relatedLayer);/**< 右对齐 */
@property (nonatomic, readonly) CLResolveLayerY *(^toRight)(CALayer *relatedLayer);/**< 在右侧 */
@property (nonatomic, readonly) CLResolveLayerY *(^alignCenterWidth)(CALayer *relatedLayer);/**< 横向居中对齐 */

@property (nonatomic, readonly) CLResolveLayerY *alignParentLeft;/**< 父Layer左对齐(内侧, 可见) */
@property (nonatomic, readonly) CLResolveLayerY *toParentLeft;/**< 父Layer左侧(外侧, 不可见) */
@property (nonatomic, readonly) CLResolveLayerY *alignParentRight;/**< 父Layer右对齐(内侧, 可见) */
@property (nonatomic, readonly) CLResolveLayerY *toParentRight;/**< 父Layer右侧(外侧, 不可见) */
@property (nonatomic, readonly) CLResolveLayerY *alignParentCenterWidth;/**< 父Layer横向居中 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) CLResolveLayerX *(^alignTop)(CALayer *relatedLayer);/**< 上对齐 */
@property (nonatomic, readonly) CLResolveLayerX *(^toTop)(CALayer *relatedLayer);/**< 在上侧 */
@property (nonatomic, readonly) CLResolveLayerX *(^alignBottom)(CALayer *relatedLayer);/**< 下对齐 */
@property (nonatomic, readonly) CLResolveLayerX *(^toBottom)(CALayer *relatedLayer);/**< 在下侧 */
@property (nonatomic, readonly) CLResolveLayerX *(^alignCenterHeight)(CALayer *relatedLayer);/**< 竖向居中对齐 */

@property (nonatomic, readonly) CLResolveLayerX *alignParentTop;/**< 父Layer上对齐(内侧, 可见) */
@property (nonatomic, readonly) CLResolveLayerX *toParentTop;/**< 父Layer顶侧(外侧, 不可见) */
@property (nonatomic, readonly) CLResolveLayerX *alignParentBottom;/**< 父Layer下对齐(内侧, 可见) */
@property (nonatomic, readonly) CLResolveLayerX *toParentBottom;/**< 父Layer底侧(外侧, 不可见) */
@property (nonatomic, readonly) CLResolveLayerX *alignParentCenterHeight;/**< 父Layer竖下居中 */

- (void)apply;
@end

@interface CLResolveLayerX : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

@property (nonatomic, readonly) CLResolveLayerX *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) CLResolveLayerX *(^distance)(CGFloat distance);/**< 修改Y的偏差 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) CLResolveLayerCompleted *(^alignLeft)(CALayer *relatedLayer);/**< 左对齐 */
@property (nonatomic, readonly) CLResolveLayerCompleted *alignLeftL;/**< 与上一个relatedLayer左对齐 */
@property (nonatomic, readonly) CLResolveLayerCompleted *(^alignRight)(CALayer *relatedLayer);/**< 右对齐 */
@property (nonatomic, readonly) CLResolveLayerCompleted *alignRightL;/**< 与上一个relatedLayer右对齐 */
@property (nonatomic, readonly) CLResolveLayerCompleted *(^alignCenterWidth)(CALayer *relatedLayer);/**< 横向居中对齐 */
@property (nonatomic, readonly) CLResolveLayerCompleted *alignCenterWidthL;/**< 与上一个related横向居中对齐 */

@property (nonatomic, readonly) CLResolveLayerCompleted *(^toLeft)(CALayer *relatedLayer);/**< 在左侧 */
@property (nonatomic, readonly) CLResolveLayerCompleted *toLeftL;/**< 在上一个relatedLayer左侧 */
@property (nonatomic, readonly) CLResolveLayerCompleted *(^toRight)(CALayer *relatedLayer);/**< 在右侧 */
@property (nonatomic, readonly) CLResolveLayerCompleted *toRightL;/**< 在上一个relatedLayer右侧 */

@property (nonatomic, readonly) CLResolveLayerCompleted *alignParentLeft;/**< 父Layer左对齐(内侧, 可见) */
@property (nonatomic, readonly) CLResolveLayerCompleted *toParentLeft;/**< 父Layer左侧(外侧, 不可见) */
@property (nonatomic, readonly) CLResolveLayerCompleted *alignParentRight;/**< 父Layer右对齐(内侧, 可见) */
@property (nonatomic, readonly) CLResolveLayerCompleted *toParentRight;/**< 父Layer右侧(外侧, 不可见) */
@property (nonatomic, readonly) CLResolveLayerCompleted *alignParentCenterWidth;/**< 父Layer横向居中 */

- (void)apply;
@end

@interface CLResolveLayerY : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

@property (nonatomic, readonly) CLResolveLayerY *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) CLResolveLayerY *(^distance)(CGFloat distance);/**< 修改X的偏差 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) CLResolveLayerCompleted *(^alignTop)(CALayer *relatedLayer);/**< 上对齐 */
@property (nonatomic, readonly) CLResolveLayerCompleted *alignTopL;/**< 与上一个relatedLayer上对齐 */
@property (nonatomic, readonly) CLResolveLayerCompleted *(^alignBottom)(CALayer *relatedLayer);/**< 下对齐 */
@property (nonatomic, readonly) CLResolveLayerCompleted *alignBottomL;/**< 与上一个relatedLayer下对齐 */
@property (nonatomic, readonly) CLResolveLayerCompleted *(^alignCenterHeight)(CALayer *relatedLayer);/**< 竖向居中对齐 */
@property (nonatomic, readonly) CLResolveLayerCompleted *alignCenterHeightL;/**< 与上一个relatedLayer竖向居中对齐 */

@property (nonatomic, readonly) CLResolveLayerCompleted *(^toTop)(CALayer *relatedLayer);/**< 上侧 */
@property (nonatomic, readonly) CLResolveLayerCompleted *toTopL;/**< 在上一个relatedLayer上侧 */
@property (nonatomic, readonly) CLResolveLayerCompleted *(^toBottom)(CALayer *relatedLayer);/**< 下侧 */
@property (nonatomic, readonly) CLResolveLayerCompleted *toBottomL;/**< 在上一个relatedLayer下侧 */

@property (nonatomic, readonly) CLResolveLayerCompleted *alignParentTop;/**< 父Layer上对齐(内侧, 可见) */
@property (nonatomic, readonly) CLResolveLayerCompleted *toParentTop;/**< 父Layer顶侧(外侧, 不可见) */
@property (nonatomic, readonly) CLResolveLayerCompleted *alignParentBottom;/**< 父Layer下对齐(内侧, 可见) */
@property (nonatomic, readonly) CLResolveLayerCompleted *toParentBottom;/**< 父Layer底侧(外侧, 不可见) */
@property (nonatomic, readonly) CLResolveLayerCompleted *alignParentCenterHeight;/**< 父Layer竖向居中 */

- (void)apply;
@end

@interface CLResolveLayerCompleted : NSObject
@property (nonatomic, readonly) CLResolveLayerCompleted *(^distance)(CGFloat distance);

- (void)apply;
@end

@interface CALayer (Layout)
@property (nonatomic, assign) CGFloat ay_x;
@property (nonatomic, assign) CGFloat ay_y;
@property (nonatomic, assign) CGFloat ay_width;
@property (nonatomic, assign) CGFloat ay_height;
@property (nonatomic, assign) CGSize ay_size;
@property (nonatomic, assign) CGPoint ay_location;
@end
NS_ASSUME_NONNULL_END
