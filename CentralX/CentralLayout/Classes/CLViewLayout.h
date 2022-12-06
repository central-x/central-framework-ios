//
//  CLLayout.h
//  CLLayout
//
//  Created by Alan Yeh on 07/22/2016.
//  Copyright (c) 2015年 Alan Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CLResolveViewX;
@class CLResolveViewY;
@class CLResolveViewComplete;

#define CLLayoutV(view) [CLViewLayout layoutForView:view]

NS_ASSUME_NONNULL_BEGIN
/**
 *  根据frame设置View的位置, 此类不适用于AutoLayout
 */
@interface CLViewLayout : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

+ (instancetype)layoutForView:(UIView *)view;
- (instancetype)initWithView:(UIView *)view NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) CLViewLayout *(^withSize)(CGFloat width, CGFloat height);/**< 设置大小 */
@property (nonatomic, readonly) CLViewLayout *(^withSizeS)(CGSize size);/**< 设置大小 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) CLResolveViewY *(^alignLeft)(UIView *relatedView);/**< 左对齐 */
@property (nonatomic, readonly) CLResolveViewY *(^toLeft)(UIView *relatedView);/**< 在左侧 */
@property (nonatomic, readonly) CLResolveViewY *(^alignRight)(UIView *relatedView);/**< 右对齐 */
@property (nonatomic, readonly) CLResolveViewY *(^toRight)(UIView *relatedView);/**< 在右侧 */
@property (nonatomic, readonly) CLResolveViewY *(^alignCenterWidth)(UIView *relatedView);/**< 横向居中对齐 */

@property (nonatomic, readonly) CLResolveViewY *alignParentLeft;/**< 父View左侧(内侧, 可见) */
@property (nonatomic, readonly) CLResolveViewY *toParentLeft;/**< 父View左侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) CLResolveViewY *alignParentRight;/**< 父View右侧(内侧, 可见) */
@property (nonatomic, readonly) CLResolveViewY *toParentRight;/**< 父View右侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) CLResolveViewY *alignParentCenterWidth;/**< 父View横向居中 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) CLResolveViewX *(^alignTop)(UIView *relatedView);/**< 上对齐 */
@property (nonatomic, readonly) CLResolveViewX *(^toTop)(UIView *relatedView);/**< 在上侧 */
@property (nonatomic, readonly) CLResolveViewX *(^alignBottom)(UIView *relatedView);/**< 下对齐 */
@property (nonatomic, readonly) CLResolveViewX *(^toBottom)(UIView *relatedView);/**< 在下侧 */
@property (nonatomic, readonly) CLResolveViewX *(^alignCenterHeight)(UIView *relatedView);/**< 竖向居中对齐 */

@property (nonatomic, readonly) CLResolveViewX *alignParentTop;/**< 父View顶侧(内侧, 可见) */
@property (nonatomic, readonly) CLResolveViewX *toParentTop;/**< 父View顶侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) CLResolveViewX *alignParentBottom;/**< 父View底侧(内侧, 可见) */
@property (nonatomic, readonly) CLResolveViewX *toParentBottom;/**< 父View底侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) CLResolveViewX *alignParentCenterHeight;/**< 父View竖向居中 */

- (void)apply;
@end

@interface CLResolveViewX : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

@property (nonatomic, readonly) CLResolveViewX *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) CLResolveViewX *(^distance)(CGFloat distance);/**< 修改Y的偏差 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) CLResolveViewComplete *(^alignLeft)(UIView *relatedView);/**< 左对齐 */
@property (nonatomic, readonly) CLResolveViewComplete *alignLeftV;/**< 与上一个relatedView左对齐 */
@property (nonatomic, readonly) CLResolveViewComplete *(^alignRight)(UIView *relatedView);/**< 右对齐 */
@property (nonatomic, readonly) CLResolveViewComplete *alignRightV;/**< 与上一个relatedView右对齐 */
@property (nonatomic, readonly) CLResolveViewComplete *(^alignCenterWidth)(UIView *relatedView);/**< 横向居中对齐 */
@property (nonatomic, readonly) CLResolveViewComplete *alignCenterWidthV;/**< 与上一个relatedView横向居中对齐 */

@property (nonatomic, readonly) CLResolveViewComplete *(^toLeft)(UIView *relatedView);/**< 在左侧 */
@property (nonatomic, readonly) CLResolveViewComplete *toLeftV;/**< 在上一个relatedView左侧 */
@property (nonatomic, readonly) CLResolveViewComplete *(^toRight)(UIView *relatedView);/**< 在右侧 */
@property (nonatomic, readonly) CLResolveViewComplete *toRightV;/**< 在上一个relatedView右侧 */

@property (nonatomic, readonly) CLResolveViewComplete *alignParentLeft;/**< 父View左侧(内侧, 可见) */
@property (nonatomic, readonly) CLResolveViewComplete *toParentLeft;/**< 父View左侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) CLResolveViewComplete *alignParentRight;/**< 父View右侧(内侧, 可见) */
@property (nonatomic, readonly) CLResolveViewComplete *toParentRight;/**< 父View右侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) CLResolveViewComplete *alignParentCenterWidth;/**< 父View横向居中 */

- (void)apply;
@end

@interface CLResolveViewY : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

@property (nonatomic, readonly) CLResolveViewY *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) CLResolveViewY *(^distance)(CGFloat distance);/**< 修改X的偏差 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) CLResolveViewComplete *(^alignTop)(UIView *relatedView);/**< 上对齐 */
@property (nonatomic, readonly) CLResolveViewComplete *alignTopV;/**< 与上一个relatedView上对齐 */
@property (nonatomic, readonly) CLResolveViewComplete *(^alignBottom)(UIView *relatedView);/**< 下对齐 */
@property (nonatomic, readonly) CLResolveViewComplete *alignBottomV;/**< 与上一个relatedView上对齐 */
@property (nonatomic, readonly) CLResolveViewComplete *(^alignCenterHeight)(UIView *relatedView);/**< 居中对齐 */
@property (nonatomic, readonly) CLResolveViewComplete *alignCenterHeightV;/**< 与上一个relatedView居中对齐 */

@property (nonatomic, readonly) CLResolveViewComplete *(^toTop)(UIView *relatedView);/**< 在上侧 */
@property (nonatomic, readonly) CLResolveViewComplete *toTopV;/**< 在上一个relatedView上侧 */
@property (nonatomic, readonly) CLResolveViewComplete *(^toBottom)(UIView *relatedView);/**< 在下侧 */
@property (nonatomic, readonly) CLResolveViewComplete *toBottomV;/**< 在上一个relatedView下侧 */

@property (nonatomic, readonly) CLResolveViewComplete *alignParentTop;/**< 父View顶侧(内侧, 可见) */
@property (nonatomic, readonly) CLResolveViewComplete *toParentTop;/**< 父View顶侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) CLResolveViewComplete *alignParentBottom;/**< 父View底侧(内侧, 可见) */
@property (nonatomic, readonly) CLResolveViewComplete *toParentBottom;/**< 父View底侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) CLResolveViewComplete *alignParentCenterHeight;/**< 父View竖向居中 */

- (void)apply;
@end

@interface CLResolveViewComplete : NSObject
@property (nonatomic, readonly) CLResolveViewComplete *(^distance)(CGFloat distance);

- (void)apply;
@end


@interface UIView (CentralLayout)
@property (nonatomic, assign) CGFloat ay_x;/**< view.frame.origin.x */
@property (nonatomic, assign) CGFloat ay_y;/**< view.frame.origin.y */
@property (nonatomic, assign) CGFloat ay_width;/**< view.frame.size.width */
@property (nonatomic, assign) CGFloat ay_height;/**< view.frame.size.height */
@property (nonatomic, assign) CGSize ay_size;/**< view.frame.size */
@property (nonatomic, assign) CGPoint ay_location;/**< view.frame.origin */
@end
NS_ASSUME_NONNULL_END
