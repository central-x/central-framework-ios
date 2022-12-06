//
//  AYLayout.h
//  AYLayout
//
//  Created by Alan Yeh on 07/22/2016.
//  Copyright © 2015年 Alan Yeh. All rights reserved.
//

#import <CentralX/CLViewLayout.h>
#import <CentralX/CLLayerLayout.h>

/* How to use AYLayout.
 * eg.
 * [AYLayoutV(view).withSize(10, 10).toLeft(relatedView).distance(10).and.toBottomV.distance(30) apply];
 *          ┌───────┐
 *          │       │relatedView
 *          │       │
 *          │       │
 *   ─ ┬ ─ ─└───────┘
 *     │    │
 *   　30
 *     │    │
 *  ┬┌─┴─┐10
 * 10│   ├──┤
 *  ┴└───┘view
 * =================================================================================================
 * [AYLayoutV(view).withSize(10, 10).toRight(relatedView).distance(30).and.alignBottomV apply];
 *            ┌─────────┐
 * relatedView│         │
 *            │         │          ├10 ┤
 *            │         │          ┌───┐
 *            │         ├─── 30 ───┤   │
 *            └─────────┴─ ─ ─ ─ ─ ┴───┘view
 * =================================================================================================
 * [AYLayoutV(view).withSize(10, 10).alignParentLeft.distance(10).and.alignParentBottom.distance(30) apply];
 * ┌───────────────────────────┐
 * │              superview    │
 * │                           │
 * │                           │
 * │                           │
 * │  ├10 ┤view                │
 * │10┌───┐┬                   │
 * ├──┤   │10                  │
 * │  └─┬─┘┴                   │
 * │    │                      │
 * │  　30       　　           │
 * │    │                      │
 * └────┴──────────────────────┘
 * =================================================================================================
 * [AYLayoutV(view).withSize(10, 10).toParentBottom.and.alignParentCenterWidth apply];
 * ┌───────────────────────────┐
 * │              superview    │
 * │                           │
 * │                           │
 * │                           │
 * │                           │
 * │                           │
 * │                           │
 * │                           │
 * └───────────┬───┬───────────┘
 * ├ ─ ─ ─ ─ ─ ┤   ├ ─ ─ ─ ─ ─ ┤
 *             └───┘view
 * =================================================================================================
 * [AYLayoutV(view).withSize(10, 10).alignParentLeft.distance(50).and.toBottom(relatedView).distance(10) apply];
 * ┌───────────────────────────┐
 * ├───────┐relatedView        │
 * │       │                   │
 * │       │                   │
 * │       │                   │
 * ├───────┘─ ─ ─ ┬ ─          │
 * │        　    10   　　     │
 * │            ┌─┴─┐          │
 * ├──── 50 ────┤   │view      │
 * │            └───┘          │
 * │ superview                 │
 * └───────────────────────────┘
 */
