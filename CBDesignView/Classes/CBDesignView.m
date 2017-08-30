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
    //NSLog(@"[i] DEBUG: %@ %s ", NSStringFromClass([self class]), __func__);
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
    
    
    
    
    
// Taken from the commercial iOS PDF framework http://pspdfkit.com.
// Copyright (c) 2014 Peter Steinberger, PSPDFKit GmbH. All rights reserved.
// Licensed under MIT (http://opensource.org/licenses/MIT)
//
// You should only use this in debug builds. It doesn't use private API, but I wouldn't ship it.
 
// PLEASE DUPE rdar://27192338 (https://openradar.appspot.com/27192338) if you would like to see this in UIKit.
 
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>


#if DEBUG
#define CBPSPDFAssert(expression, ...) \
do { if(!(expression)) { \
NSLog(@"%@", [NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:@"" __VA_ARGS__]]); \
abort(); }} while(0)
 
// Compile-time selector checks.
//#if DEBUG
#define CB_PROPERTY(propName) NSStringFromSelector(@selector(propName))
//#else
//#define CB_PROPERTY(propName) @#propName
//#endif

// http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
BOOL CBPSPDFReplaceMethodWithBlock(Class c, SEL origSEL, SEL newSEL, id block) {
//    NSCParameterAssert(c);
//    NSCParameterAssert(origSEL);
//    NSCParameterAssert(newSEL);
//    NSCParameterAssert(block);
 
    if ([c instancesRespondToSelector:newSEL]) return YES; // Selector already implemented, skip silently.
 
    Method origMethod = class_getInstanceMethod(c, origSEL);
 
    // Add the new method.
    IMP impl = imp_implementationWithBlock(block);
    if (!class_addMethod(c, newSEL, impl, method_getTypeEncoding(origMethod))) {
//        CBPSPDFLogError(@"Failed to add method: %@ on %@", NSStringFromSelector(newSEL), c);
        return NO;
    }else {
        Method newMethod = class_getInstanceMethod(c, newSEL);
 
        // If original doesn't implement the method we want to swizzle, create it.
        if (class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(origMethod))) {
            class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(newMethod));
        }else {
            method_exchangeImplementations(origMethod, newMethod);
        }
    }
    return YES;
}
 
SEL _CBPSPDFPrefixedSelector(SEL selector) {
    return NSSelectorFromString([NSString stringWithFormat:@"cb_pspdf_%@", NSStringFromSelector(selector)]);
}
 
 
void CBPSPDFAssertIfNotMainThread(void) {
    //有疑问？问问我为啥断掉
    CBPSPDFAssert(NSThread.isMainThread, @"\nERROR: All calls to UIKit need to happen on the main thread. You have a bug in your code. Use dispatch_async(dispatch_get_main_queue(), ^{ ... }); if you're unsure what thread you're in.\n\nBreak on CBPSPDFAssertIfNotMainThread to find out where.\n\nStacktrace: %@", NSThread.callStackSymbols);
}
 
__attribute__((constructor)) static void CBPSPDFUIKitMainThreadGuard(void) {
    @autoreleasepool {
        for (NSString *selStr in @[CB_PROPERTY(setNeedsLayout), CB_PROPERTY(setNeedsDisplay), CB_PROPERTY(setNeedsDisplayInRect:)]) {
            SEL selector = NSSelectorFromString(selStr);
            SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"cb_pspdf_%@", selStr]);
            if ([selStr hasSuffix:@":"]) {
                CBPSPDFReplaceMethodWithBlock(UIView.class, selector, newSelector, ^(__unsafe_unretained UIView *_self, CGRect r) {
                    // Check for window, since *some* UIKit methods are indeed thread safe.
                    // https://developer.apple.com/library/ios/#releasenotes/General/WhatsNewIniPhoneOS/Articles/iPhoneOS4.html
                    /*
                     Drawing to a graphics context in UIKit is now thread-safe. Specifically:
                     The routines used to access and manipulate the graphics context can now correctly handle contexts residing on different threads.
                     String and image drawing is now thread-safe.
                     Using color and font objects in multiple threads is now safe to do.
                     */
                    if (_self.window) CBPSPDFAssertIfNotMainThread();
                    ((void ( *)(id, SEL, CGRect))objc_msgSend)(_self, newSelector, r);
                });
            }else {
                CBPSPDFReplaceMethodWithBlock(UIView.class, selector, newSelector, ^(__unsafe_unretained UIView *_self) {
                    if (_self.window) {
                        if (!NSThread.isMainThread) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                            dispatch_queue_t queue = dispatch_get_current_queue();
#pragma clang diagnostic pop
                            // iOS 8 layouts the MFMailComposeController in a background thread on an UIKit queue.
                            // https://github.com/CBPSPDFKit/CBPSPDFKit/issues/1423
                            if (!queue || !strstr(dispatch_queue_get_label(queue), "UIKit")) {
                                CBPSPDFAssertIfNotMainThread();
                            }
                        }
                    }
                    ((void ( *)(id, SEL))objc_msgSend)(_self, newSelector);
                });
            }
        }
    }
}
#endif


