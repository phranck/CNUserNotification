//
//  CNAppDelegate.m
//  CNUserNotification Example
//
//  Created by Frank Gregor on 17.05.13.
//  Copyright (c) 2013 cocoa:naut. All rights reserved.
//

#import "CNAppDelegate.h"


@interface CNAppDelegate() {}
@property (assign) NSUInteger dismissDelayTime;
@property (strong) CNUserNotificationCenter *notificationCenter;
@property (assign) NSLineBreakMode lineBreakMode;
@end

@implementation CNAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.dismissDelayTimeSlider.intValue = 6;
    self.dismissDelayTime = [self.dismissDelayTimeSlider intValue];

    self.notificationCenter = [CNUserNotificationCenter defaultUserNotificationCenter];
    self.notificationCenter.delegate = self;

    self.lineBreakMode = NSLineBreakByTruncatingTail;

    [self.dismissDelayTimeSlider setEnabled:NO];
    [self.bannerImageMatrix setEnabled:NO];
    self.bannerImagePreview.image = [NSApp applicationIconImage];
}

- (IBAction)deliverButtonAction:(id)sender
{
    CNUserNotification *notification = [CNUserNotification new];
    notification.title = self.title.stringValue;
    notification.subtitle = self.subtitle.stringValue;
    notification.informativeText = self.informativeText.stringValue;
    notification.hasActionButton = (self.hasActionButtonCheckbox.state == NSOnState ? YES : NO);
    notification.actionButtonTitle = (![self.actionButtonTitle.stringValue isEqualToString:@""] ? self.actionButtonTitle.stringValue : @"Action");
    notification.feature.dismissDelayTime = self.dismissDelayTime;
    notification.feature.bannerImage = self.bannerImagePreview.image;
    notification.feature.lineBreakMode = self.lineBreakMode;
    notification.userInfo = @{
        @"openThisURLBecauseItsAwesome": self.urlToOpen.stringValue
    };

    [self.notificationCenter deliverNotification:notification];
}

- (IBAction)lineBreakModeMatrixAction:(id)sender
{
    switch ([self.lineBreakModeMatrix selectedRow]) {
        case 0: self.lineBreakMode = NSLineBreakByTruncatingTail; break;
        case 1: self.lineBreakMode = NSLineBreakByWordWrapping; break;
    }
}

- (IBAction)notificationSelectionMatrixAction:(id)sender
{
    self.notificationCenter = nil;
    switch ([self.notificationSelectionMatrix selectedRow]) {
        case 0: {
            self.notificationCenter = [CNUserNotificationCenter defaultUserNotificationCenter];
            [self.dismissDelayTimeSlider setEnabled:NO];
            [self.bannerImageMatrix setEnabled:NO];
            break;
        }
        case 1: {
            self.notificationCenter = [CNUserNotificationCenter customUserNotificationCenter];
            [self.dismissDelayTimeSlider setEnabled:YES];
            [self.bannerImageMatrix setEnabled:YES];
            break;
        }
    }
    self.notificationCenter.delegate = self;
}

- (IBAction)dismissDelayTimeSliderAction:(id)sender
{
    self.dismissDelayTime = [self.dismissDelayTimeSlider intValue];
}

- (IBAction)hasActionButtonCheckboxAction:(id)sender
{
    switch ([self.hasActionButtonCheckbox state]) {
        case NSOnState: {
            [self.actionButtonTitleLabel setEnabled:YES];
            [self.actionButtonTitle setEnabled:YES];
            [self.actionButtonTitleLabel setTextColor:[NSColor controlTextColor]];
            break;
        }
        case NSOffState: {
            [self.actionButtonTitleLabel setEnabled:NO];
            [self.actionButtonTitle setEnabled:NO];
            [self.actionButtonTitleLabel setTextColor:[NSColor disabledControlTextColor]];
            break;
        }
    }
}

- (IBAction)bannerImageMatrixAction:(id)sender
{
    switch ([self.bannerImageMatrix selectedRow]) {
        case 0: self.bannerImagePreview.image = [NSApp applicationIconImage]; break;
        default: self.bannerImagePreview.image = [NSImage imageNamed:[NSString stringWithFormat:@"banner-image-%li", [self.bannerImageMatrix selectedRow]]]; break;
    }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CNUserNotification Delegate

- (BOOL)userNotificationCenter:(CNUserNotificationCenter *)center shouldPresentNotification:(CNUserNotification *)notification
{
    return YES;
}

- (void)userNotificationCenter:(CNUserNotificationCenter *)center didActivateNotification:(CNUserNotification *)notification
{
    CNLog(@"userNotificationCenter:didActivateNotification: %@", notification);
    NSString *urlToOpen = [notification.userInfo objectForKey:@"openThisURLBecauseItsAwesome"];
    if (urlToOpen && ![urlToOpen isEqualToString:@""]) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlToOpen]];
    }
}

- (void)userNotificationCenter:(CNUserNotificationCenter *)center didDeliverNotification:(CNUserNotification *)notification
{
//    CNLog(@"userNotificationCenter:didDeliverNotification: %@", notification);
}

@end


