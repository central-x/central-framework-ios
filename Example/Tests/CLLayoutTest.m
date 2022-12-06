//
//  CLLayoutTest.m
//  CentralX_Tests
//
//  Created by alan on 2022/5/20.
//  Copyright © 2022 yerl. All rights reserved.
//

#import <XCTest/XCTest.h>
@import CentralX;

@interface CLLayoutTest : XCTestCase
@property(nonatomic, strong) UIView *targetView;
@property(nonatomic, strong) UIView *relateView;
@property(nonatomic, strong) UIView *parentView;

@property(nonatomic, strong) CALayer *targetLayer;
@property(nonatomic, strong) CALayer *relateLayer;
@end

@implementation CLLayoutTest

- (void)setUp {
    [super setUp];
    self.targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.relateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    self.targetLayer = [CALayer layer];
    self.targetLayer.ay_size = CGSizeMake(50, 50);
    self.relateLayer = [CALayer layer];
    self.relateLayer.ay_size = CGSizeMake(100, 100);
    self.relateLayer.ay_location = CGPointMake(0, 0);
    
    self.parentView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [view addSubview:self.targetView];
        [view addSubview:self.relateView];
        [view.layer addSublayer:self.targetLayer];
        [view.layer addSublayer:self.relateLayer];
        view;
    });
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/** 测试UIView Size */
- (void)testLayoutSize{
    [CLLayoutV(self.targetView).withSize(75, 75) apply];
    XCTAssert(CGSizeEqualToSize(self.targetView.frame.size, CGSizeMake(75, 75)));
    [CLLayoutV(self.targetView).withSizeS(CGSizeMake(175, 175)) apply];
    XCTAssert(CGSizeEqualToSize(self.targetView.frame.size, CGSizeMake(175, 175)));
    
    [CLLayoutL(self.targetLayer).withSize(75, 75) apply];
    XCTAssert(CGSizeEqualToSize(self.targetLayer.bounds.size, CGSizeMake(75, 75)));
    [CLLayoutL(self.targetLayer).withSizeS(CGSizeMake(175, 175)) apply];
    XCTAssert(CGSizeEqualToSize(self.targetLayer.bounds.size, CGSizeMake(175, 175)));
}
/** 测试布局UIView X轴 */
- (void)testViewLayoutX{
    self.targetView.ay_y = 10;
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_x == 10);
    
    [CLLayoutV(self.targetView).toLeft(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_x == -60);
    
    [CLLayoutV(self.targetView).alignRight(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_x == 40);
    
    [CLLayoutV(self.targetView).toRight(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_x == 110);
    
    [CLLayoutV(self.targetView).alignCenterWidth(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_x == 35);
    
    [CLLayoutV(self.targetView).alignParentLeft.distance(10) apply];
    XCTAssert(self.targetView.ay_x == 10);
    
    [CLLayoutV(self.targetView).alignParentRight.distance(10) apply];
    XCTAssert(self.targetView.ay_x == 140);
    
    [CLLayoutV(self.targetView).toParentLeft.distance(10) apply];
    XCTAssert(self.targetView.ay_x == -60);
    
    [CLLayoutV(self.targetView).toParentRight.distance(10) apply];
    XCTAssert(self.targetView.ay_x = 260);
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_x = 85);
    
    XCTAssert(self.targetView.ay_y == 10);
    //================================================================================
    //测试第二位布局X轴
    
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.alignLeft(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_x == 10);
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.alignLeftV.distance(10) apply];
    XCTAssert(self.targetView.ay_x == 10);
    
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.toLeft(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_x == -60);
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.toLeftV.distance(10) apply];
    XCTAssert(self.targetView.ay_x == -60);
    
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.alignRight(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_x == 40);
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.alignRightV.distance(10) apply];
    XCTAssert(self.targetView.ay_x == 40);
    
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.toRight(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_x == 110);
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.toRightV.distance(10) apply];
    XCTAssert(self.targetView.ay_x == 110);
    
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.alignCenterWidth(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_x == 35);
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.alignCenterWidthV.distance(10) apply];
    XCTAssert(self.targetView.ay_x == 35);
    
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.alignParentLeft.distance(10) apply];
    XCTAssert(self.targetView.ay_x == 10);
    
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.alignParentRight.distance(10) apply];
    XCTAssert(self.targetView.ay_x == 140);
    
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.toParentLeft.distance(10) apply];
    XCTAssert(self.targetView.ay_x == -60);
    
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.toParentRight.distance(10) apply];
    XCTAssert(self.targetView.ay_x == 260);
    
    [CLLayoutV(self.targetView).alignTop(self.relateView).and.alignParentCenterWidth.distance(10) apply];
    XCTAssert(self.targetView.ay_x == 85);
    
    XCTAssert(self.targetView.ay_y == 0);
}
/** 测试布局UIView Y轴 */
- (void)testViewLayoutY{
    self.targetView.ay_x = 10;
    
    [CLLayoutV(self.targetView).toTop(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_y == -60);
    
    [CLLayoutV(self.targetView).alignTop(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_y == 10);
    
    [CLLayoutV(self.targetView).toBottom(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_y == 110);
    
    [CLLayoutV(self.targetView).alignBottom(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_y == 40);
    
    [CLLayoutV(self.targetView).alignCenterHeight(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_y == 35);
    
    [CLLayoutV(self.targetView).alignParentTop.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 10);
    
    [CLLayoutV(self.targetView).toParentTop.distance(10) apply];
    XCTAssert(self.targetView.ay_y == -60);
    
    [CLLayoutV(self.targetView).alignParentBottom.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 140);
    
    [CLLayoutV(self.targetView).toParentBottom.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 260);
    
    [CLLayoutV(self.targetView).alignParentCenterHeight.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 85);
    
    XCTAssert(self.targetView.ay_x == 10);
    //================================================================================
    //测试第二位布局Y轴
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.toTop(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_y == -60);
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.toTopV.distance(10) apply];
    XCTAssert(self.targetView.ay_y == -60);
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.alignTop(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_y == 10);
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.alignTopV.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 10);
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.toBottom(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_y == 110);
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.toBottomV.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 110);
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.alignBottom(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_y == 40);
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.alignBottomV.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 40);
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.alignCenterHeight(self.relateView).distance(10) apply];
    XCTAssert(self.targetView.ay_y == 35);
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.alignCenterHeightV.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 35);
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.alignParentTop.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 10);
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.toParentTop.distance(10) apply];
    XCTAssert(self.targetView.ay_y == -60);
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.alignParentBottom.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 140);
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.toParentBottom.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 260);
    
    [CLLayoutV(self.targetView).alignLeft(self.relateView).and.alignParentCenterHeight.distance(10) apply];
    XCTAssert(self.targetView.ay_y == 85);
    
    XCTAssert(self.targetView.ay_x == 0);
    
}

- (void)testLayerLayoutX{
    self.targetLayer.ay_y = 10;
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 10, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).toLeft(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == -60, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignRight(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 40, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).toRight(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 110, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignCenterWidth(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 35, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignParentLeft.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 10, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignParentRight.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 140, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).toParentLeft.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == -60, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).toParentRight.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x = 260, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_x = 85, @"value = %@", @(self.targetLayer.ay_x));
    
    XCTAssert(self.targetLayer.ay_y == 10, @"value = %@", @(self.targetLayer.ay_x));
    //================================================================================
    //测试第二位布局X轴
    
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.alignLeft(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 10, @"value = %@", @(self.targetLayer.ay_x));
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.alignLeftL.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 10, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.toLeft(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == -60, @"value = %@", @(self.targetLayer.ay_x));
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.toLeftL.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == -60, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.alignRight(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 40, @"value = %@", @(self.targetLayer.ay_x));
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.alignRightL.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 40, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.toRight(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 110, @"value = %@", @(self.targetLayer.ay_x));
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.toRightL.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 110, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.alignCenterWidth(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 35, @"value = %@", @(self.targetLayer.ay_x));
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.alignCenterWidthL.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 35, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.alignParentLeft.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 10, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.alignParentRight.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 140, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.toParentLeft.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == -60, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.toParentRight.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 260, @"value = %@", @(self.targetLayer.ay_x));
    
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).and.alignParentCenterWidth.distance(10) apply];
    XCTAssert(self.targetLayer.ay_x == 85, @"value = %@", @(self.targetLayer.ay_x));
    
    XCTAssert(self.targetLayer.ay_y == 0, @"value = %@", @(self.targetLayer.ay_x));
}

- (void)testLayerLayoutY{
    self.targetLayer.ay_x = 10;
    
    [CLLayoutL(self.targetLayer).toTop(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == -60, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignTop(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 10, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).toBottom(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 110, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignBottom(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 40, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignCenterHeight(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 35, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignParentTop.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 10, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).toParentTop.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == -60, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignParentBottom.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 140, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).toParentBottom.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 260, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignParentCenterHeight.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 85, @"value = %@", @(self.targetLayer.ay_y));
    
    XCTAssert(self.targetLayer.ay_x == 10, @"value = %@", @(self.targetLayer.ay_y));
    //================================================================================
    //测试第二位布局Y轴
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.toTop(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == -60, @"value = %@", @(self.targetLayer.ay_y));
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.toTopL.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == -60, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.alignTop(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 10, @"value = %@", @(self.targetLayer.ay_y));
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.alignTopL.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 10, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.toBottom(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 110, @"value = %@", @(self.targetLayer.ay_y));
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.toBottomL.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 110, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.alignBottom(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 40, @"value = %@", @(self.targetLayer.ay_y));
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.alignBottomL.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 40, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.alignCenterHeight(self.relateLayer).distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 35, @"value = %@", @(self.targetLayer.ay_y));
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.alignCenterHeightL.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 35, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.alignParentTop.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 10, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.toParentTop.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == -60, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.alignParentBottom.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 140, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.toParentBottom.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 260, @"value = %@", @(self.targetLayer.ay_y));
    
    [CLLayoutL(self.targetLayer).alignLeft(self.relateLayer).and.alignParentCenterHeight.distance(10) apply];
    XCTAssert(self.targetLayer.ay_y == 85, @"value = %@", @(self.targetLayer.ay_y));
    
    XCTAssert(self.targetLayer.ay_x == 0, @"value = %@", @(self.targetLayer.ay_y));
    
}
@end
