//
//  CNUserNotification.m
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

#import "CNUserNotification.h"


/// names for notifications
NSString *CNUserNotificationPresentedNotification = @"com.cocoanaut.CNUserNotificationWasPresentedNotification";

@interface CNUserNotification () {
    id _CNInstance;
}
@end

@implementation CNUserNotification

- (id)init {
    if (NSClassFromString(@"NSUserNotification")) {
        _CNInstance = [[NSUserNotification alloc] init];
        return _CNInstance;
    } else {
        self = [super init];
        if (self) {
            _CNInstance = nil;
            _title = nil;
            _subtitle = nil;
            _informativeText = nil;
            _userInfo = [[NSDictionary alloc] init];
            _presented = NO;

            [[NSNotificationCenter defaultCenter] addObserverForName:CNUserNotificationPresentedNotification
                                                              object:nil
                                                               queue:[NSOperationQueue mainQueue]
                                                          usingBlock:^(NSNotification *note) {
                                                              _presented = YES;
                                                          }];
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    CNUserNotification *copy = [super copy];
    [copy setTitle:self.title];
    [copy setSubtitle:self.subtitle];
    [copy setInformativeText:self.informativeText];
    [copy setHasActionButton:self.hasActionButton];
    [copy setActionButtonTitle:self.actionButtonTitle];
    [copy setOtherButtonTitle:self.otherButtonTitle];
    [copy setUserInfo:self.userInfo];
    return copy;
}

@end
