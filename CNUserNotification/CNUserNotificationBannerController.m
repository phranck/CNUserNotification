//
//  CNUserNotificationBannerController.m
//
//  Created by Frank Gregor on 16.05.13.
//  Copyright (c) 2013 cocoa:naut. All rights reserved.
//

/*
 The MIT License (MIT)
 Copyright © 2013 Frank Gregor, <phranck@cocoanaut.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the “Software”), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <QuartzCore/QuartzCore.h>
#import "CNUserNotificationBannerController.h"


static NSTimeInterval slideInAnimationDuration = 0.42;
static NSTimeInterval slideOutAnimationDuration = 0.56;
static NSDictionary *titleAttributes, *subtitleAttributes, *informativeTextAttributes;
static NSRect presentationBeginRect, presentationRect, presentationEndRect;
static CGFloat topAndTrailingMargin = 15;

@interface CNUserNotificationBannerController () {
    NSString *_cn_title;
    NSString *_cn_subtitle;
    NSString *_cn_informativeText;
    NSDictionary *_cn_userInfo;
    CNUserNotification *_cn_currentUserNotification;
}
@property (assign) BOOL animationIsRunning;
@property (strong) NSTimer *dismissTimer;
@end

@implementation CNUserNotificationBannerController

+ (void)initialize {
    NSShadow *textShadow = [[NSShadow alloc] init];
    [textShadow setShadowColor:[[NSColor whiteColor] colorWithAlphaComponent:0.5]];
    [textShadow setShadowOffset:NSMakeSize(0, -1)];

    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [textStyle setAlignment:NSLeftTextAlignment];

    titleAttributes = @{
        NSShadowAttributeName:          textShadow,
        NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:0.200 alpha:1.000],
        NSParagraphStyleAttributeName:  textStyle,
        NSFontAttributeName:            [NSFont fontWithName:@"LucidaGrande-Bold" size:12]
    };

    subtitleAttributes = @{
        NSShadowAttributeName:          textShadow,
        NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:0.200 alpha:1.000],
        NSParagraphStyleAttributeName:  textStyle,
        NSFontAttributeName:            [NSFont fontWithName:@"LucidaGrande-Bold" size:11]
    };

    informativeTextAttributes = @{
        NSShadowAttributeName:          textShadow,
        NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:0.496 alpha:1.000],
        NSParagraphStyleAttributeName:  textStyle,
        NSFontAttributeName:            [NSFont fontWithName:@"LucidaGrande" size:11]
    };
}

- (instancetype)initWithNotification:(CNUserNotification *)theNotification delegate:(id<CNUserNotificationCenterDelegate>)theDelegate {
    self = [super initWithWindowNibName:NSStringFromClass([self class])];
    if (self) {
        _animationIsRunning = NO;
        _cn_title = theNotification.title;
        _cn_subtitle = theNotification.subtitle;
        _cn_informativeText = theNotification.informativeText;
        _cn_userInfo = theNotification.userInfo;
        _delegate = theDelegate;
        _cn_currentUserNotification = theNotification;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self calculateBannerPositions];

    self.title.attributedStringValue = [[NSAttributedString alloc] initWithString:_cn_title attributes:titleAttributes];
    self.subtitle.attributedStringValue = [[NSAttributedString alloc] initWithString:_cn_subtitle attributes:subtitleAttributes];
    self.informativeText.attributedStringValue = [[NSAttributedString alloc] initWithString:_cn_informativeText attributes:informativeTextAttributes];
    self.bannerImageView.image = [NSApp applicationIconImage];

    [[self window] setAlphaValue:0.0];
    [[self window] setLevel:NSScreenSaverWindowLevel];
    [[self window] setStyleMask:NSBorderlessWindowMask];
    [[self window] setOpaque:NO];
    [[self window] setBackgroundColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.0]];
}

- (void)calculateBannerPositions {
    NSRect mainScreenFrame = [[NSScreen mainScreen] frame];
    CGFloat statusBarThickness = [[NSStatusBar systemStatusBar] thickness];

    CGFloat bannerWidth = NSWidth([[self window] frame]);
    CGFloat bannerHeight = NSHeight([[self window] frame]);

    /// window position before slide in animation
    presentationBeginRect = NSMakeRect(NSMaxX(mainScreenFrame) - bannerWidth - topAndTrailingMargin,
                                       NSMaxY(mainScreenFrame) - bannerHeight - topAndTrailingMargin,
                                       bannerWidth,
                                       bannerHeight);

    /// window position after slide in animation
    presentationRect = NSMakeRect(NSMaxX(mainScreenFrame) - bannerWidth - topAndTrailingMargin,
                                  NSMaxY(mainScreenFrame) - statusBarThickness - bannerHeight - topAndTrailingMargin,
                                  bannerWidth,
                                  bannerHeight);

    /// window position after slide out animation
    presentationEndRect = NSMakeRect(NSMaxX(mainScreenFrame) - bannerWidth,
                                     NSMaxY(mainScreenFrame) - statusBarThickness - bannerHeight - topAndTrailingMargin,
                                     bannerWidth,
                                     bannerHeight);
}

- (void)presentBanner {
    if (self.animationIsRunning) return;

    self.animationIsRunning = YES;
    [NSApp activateIgnoringOtherApps:YES];
    [[self window] setFrame:presentationBeginRect display:NO];
    [[self window] orderFront:self];

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = slideInAnimationDuration;
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [[[self window] animator] setAlphaValue:1.0];
        [[[self window] animator] setFrame:presentationRect display:YES];
        
    } completionHandler:^{
        self.animationIsRunning = NO;
        [[self window] makeKeyAndOrderFront:self];

        [[NSNotificationCenter defaultCenter] postNotificationName:CNUserNotificationPresentedNotification object:nil];
    }];
}

- (void)presentBannerDismissAfter:(NSTimeInterval)dismissTimerInterval {
    [self presentBanner];
    self.dismissTimer = [NSTimer timerWithTimeInterval:dismissTimerInterval target:self selector:@selector(timedBannerDismiss:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.dismissTimer forMode:NSDefaultRunLoopMode];
}

- (void)timedBannerDismiss:(NSTimer *)theTimer {
    [self dismissBanner];
}

- (void)dismissBanner {
    if (self.animationIsRunning) return;

    self.animationIsRunning = YES;

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = slideOutAnimationDuration;
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [[[self window] animator] setAlphaValue:0.0];
        [[[self window] animator] setFrame:presentationEndRect display:YES];
        
    } completionHandler:^{
        self.animationIsRunning = NO;
        [self.window close];
    }];
}

- (void)mouseUp:(NSEvent *)theEvent {
    CNUserNotificationCenter *center = [CNUserNotificationCenter defaultUserNotificationCenter];
    if ([self userNotificationCenter:center shouldPresentNotification:_cn_currentUserNotification]) {
        [self userNotificationCenter:center didActivateNotification:_cn_currentUserNotification];
    }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CNUserNotificationCenter Delegate

- (void)userNotificationCenter:(CNUserNotificationCenter *)center didActivateNotification:(CNUserNotification *)notification {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate userNotificationCenter:center didActivateNotification:notification];
        [self dismissBanner];
    }
}

- (void)userNotificationCenter:(CNUserNotificationCenter *)center didDeliverNotification:(CNUserNotification *)notification
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate userNotificationCenter:center didDeliverNotification:notification];
    }
}

- (BOOL)userNotificationCenter:(CNUserNotificationCenter *)center shouldPresentNotification:(CNUserNotification *)notification {
    BOOL shouldPresent = NO;
    if ([self.delegate respondsToSelector:_cmd]) {
        shouldPresent = [self.delegate userNotificationCenter:center shouldPresentNotification:notification];
    }
    return shouldPresent;
}

@end
