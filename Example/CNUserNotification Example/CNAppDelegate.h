//
//  CNAppDelegate.h
//  CNUserNotification Example
//
//  Created by Frank Gregor on 17.05.13.
//  Copyright (c) 2013 cocoa:naut. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CNAppDelegate : NSObject <NSApplicationDelegate, CNUserNotificationCenterDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (strong) IBOutlet NSTextField *title;
@property (strong) IBOutlet NSTextField *subtitle;
@property (strong) IBOutlet NSTextField *informativeText;

@property (strong) IBOutlet NSTextField *actionButtonTitleLabel;
@property (strong) IBOutlet NSTextField *actionButtonTitle;
@property (strong) IBOutlet NSTextField *otherButtonTitle;
@property (strong) IBOutlet NSTextField *urlToOpen;

@property (strong) IBOutlet NSMatrix *notificationSelectionMatrix;
@property (strong) IBOutlet NSSlider *dismissDelayTimeSlider;
@property (strong) IBOutlet NSButton *hasActionButtonCheckbox;

- (IBAction)deliverButtonAction:(id)sender;
- (IBAction)notificationSelectionMatrixAction:(id)sender;
- (IBAction)dismissDelayTimeSliderAction:(id)sender;
- (IBAction)hasActionButtonCheckboxAction:(id)sender;

@end
