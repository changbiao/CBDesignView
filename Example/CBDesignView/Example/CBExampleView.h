//
//  CBExampleView.h
//  CBDesignView
//
//  Created by 0xcb on 2017/6/12.
//  Copyright © 2017年 changbiao. All rights reserved.
//

#import <CBDesignView/CBDesignView.h>


typedef void (^CBNumClickEventListener)(int num);


@interface CBExampleView : CBDesignView
@property (nonatomic, copy) CBNumClickEventListener onClick;
@end
