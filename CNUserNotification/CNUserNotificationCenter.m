//
//  CNUserNotificationCenter.m
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

#import "CNUserNotificationBannerController.h"


@interface CNUserNotificationCenter () {}
@property (strong) CNUserNotificationBannerController *notificationBannerController;
@end

@implementation CNUserNotificationCenter

+ (instancetype)defaultUserNotificationCenter {
    __strong static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (NSClassFromString(@"NSUserNotificationCenter")) sharedInstance = [NSUserNotificationCenter defaultUserNotificationCenter];
        else sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _notificationBannerController = nil;
    }
    return self;
}

- (void)deliverNotification:(CNUserNotification *)notification {
    if (!self.notificationBannerController) {
        self.notificationBannerController = [[CNUserNotificationBannerController alloc] initWithNotification:notification
                                                                                                    delegate:self.delegate];
    } else {
    }
    [self.notificationBannerController presentBannerDismissAfter:7];
}

@end
