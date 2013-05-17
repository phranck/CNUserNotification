//
//  CNUserNotificationCenterDelegate.h
//  CNUserNotification Example
//
//  Created by Frank Gregor on 17.05.13.
//  Copyright (c) 2013 cocoa:naut. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CNUserNotificationCenter, CNUserNotification;

@protocol CNUserNotificationCenterDelegate <NSUserNotificationCenterDelegate>
@optional

/**
 ...
 */
- (BOOL)userNotificationCenter:(CNUserNotificationCenter *)center shouldPresentNotification:(CNUserNotification *)notification;

/**
 ...
 */
- (void)userNotificationCenter:(CNUserNotificationCenter *)center didActivateNotification:(CNUserNotification *)notification;

/**
 ...
 */
- (void)userNotificationCenter:(CNUserNotificationCenter *)center didDeliverNotification:(CNUserNotification *)notification;
@end
