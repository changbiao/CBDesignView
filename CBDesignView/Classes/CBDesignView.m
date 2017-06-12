//
//  CBDesignView.m
//  Pods
//
//  Created by 0xcb on 17/3/14.
//  Copyright © 2017年 0xcb. All rights reserved.
//

#import "CBDesignView.h"
#import "Masonry.h"


@implementation CBDesignView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self _cb_setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _cb_setup];
    }
    return self;
}

- (void)_cb_setup
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
    _cb_nibView = [nib instantiateWithOwner:self options:nil].firstObject;
    _cb_nibView.frame = self.bounds;
    [self addSubview:_cb_nibView];
    
    [_cb_nibView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
#if DEBUG
    NSLog(@"[i] DEBUG: %@ %s ", NSStringFromClass([self class]), __func__);
#endif
    
    [self cb_customView];
}

- (void)cb_customView {}

- (void)prepareForInterfaceBuilder
{
#if DEBUG
    //self.backgroundColor = [UIColor colorWithRed:0.416 green:0.906 blue:1.000 alpha:1.000];
#endif
}



- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.cb_nibView.backgroundColor = backgroundColor;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
