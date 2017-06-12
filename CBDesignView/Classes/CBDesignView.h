//
//  CBDesignView.h
//  Pods
//
//  Created by 0xcb on 17/3/14.
//  Copyright © 2017年 0xcb. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface CBDesignView : UIView
@property (nonatomic, retain, readonly) UIView *cb_nibView;
- (void)cb_customView;
@end
