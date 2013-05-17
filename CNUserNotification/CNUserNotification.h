//
//  CNUserNotification.h
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

#import <Foundation/Foundation.h>
#import "CNUserNotificationCenter.h"
#import "CNUserNotificationCenterDelegate.h"



/// notification names
extern NSString *CNUserNotificationPresentedNotification;

/// custom keys are used for the userInfo dictionary of a `CNUserNotification`
extern NSString *kCNUserNotificationDismissDelayTimeKey;                     /// this key is used to specify time a notification banner is visible on the screen


typedef NS_ENUM (NSInteger, CNUserNotificationActivationType) {
    CNUserNotificationActivationTypeNone = 0,
    CNUserNotificationActivationTypeContentsClicked,
    CNUserNotificationActivationTypeActionButtonClicked
} NS_ENUM_AVAILABLE (10_7, NA);


NS_CLASS_AVAILABLE(10_7, NA)
@interface CNUserNotification : NSObject <NSCopying>

#pragma mark - Display Information
/** @name Display Information */

/**
 Specifies the title of the notification.
 
 This value should localized as it will be presented to the user. The string will be truncated to a length appropriate for display and the property will be modified to reflect the truncation.

 @see subtitle
 @see informativeText
 */
@property (copy) NSString *title;

/**
 Specifies the subtitle of the notification.
 
 This value should localized as it will be presented to the user. The string will be truncated to a length appropriate for display and the property will be modified to reflect the truncation.

 @see title
 @see informativeText
 */
@property (copy) NSString *subtitle;

/**
 The body text of the notification.
 
 This value should localized as it will be presented to the user. The string will be truncated to a length appropriate for display and the property will be modified to reflect the truncation.

 @see title
 @see subtitle
 */
@property (copy) NSString *informativeText;


#pragma mark - Displayed Notification Buttons
/** @name Displayed Notification Buttons */

/**
 Specifies whether the notification displays an action button.
 
 Set to NO if the notification has no action button. This will be the case for notifications that are purely for informational purposes and have no user action.
 
 The default value is `YES`.

 @see actionButtonTitle
 @see otherButtonTitle
 */
@property  BOOL hasActionButton;

/**
 Specifies the title of the action button displayed in the notification.
 
 This value should localized as it will be presented to the user. The string will be truncated to a length appropriate for display and the property will be modified to reflect the truncation.

 @see hasActionButton
 @see otherButtonTitle
 */
@property (copy) NSString *actionButtonTitle;

/**
 Specifies a custom title for the close button in an alert-style notification.
 
 This value should localized as it will be presented to the user. The string will be truncated to a length appropriate for display and the property will be modified to reflect the truncation.
 
 An empty string will cause the default localized text to be used. A `nil` value is invalid.

 @see hasActionButton
 @see actionButtonTitle
 */
@property (copy) NSString *otherButtonTitle;


#pragma mark - Delivery Information
/** @name User Delivery Information */

@property (readonly, getter=isPresented) BOOL presented;


#pragma mark - User Notification Activation Method
/** @name User Notification Activation Method */

/**
 Specifies what caused a user notification to occur. (read-only)
 
 This property specifies why the user notification was sent to to the CNUserNotificationCenterDelegate method `userNotificationCenter:didActivateNotification:`.
 The supported values are described in `CNUserNotificationActivationType`.
 
    typedef NS_ENUM (NSInteger, CNUserNotificationActivationType) {
        CNUserNotificationActivationTypeNone = 0,
        CNUserNotificationActivationTypeContentsClicked,
        CNUserNotificationActivationTypeActionButtonClicked
    } NS_ENUM_AVAILABLE (10_7, NA);

 */
@property (readonly) CNUserNotificationActivationType activationType;


#pragma mark - User Notification User Information
/** @name User Notification User Information */

/**
 Application-specific user info that can be attached to the notification.
 
 All items must be property list types or an exception will be thrown.
 */
@property (copy) NSDictionary *userInfo;
@end
