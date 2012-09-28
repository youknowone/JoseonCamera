//
//  JoseonCameraAppDelegate.h
//  JoseonCamera
//
//  Created by Jeong YunWon on 10. 5. 22..
//  Copyright 3rddev.org 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JoseonCameraViewController;

@interface JoseonCameraAppDelegate : NSObject <UIApplicationDelegate> {
	UIView *adsenseContainer;
    UIWindow *window;
    JoseonCameraViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet JoseonCameraViewController *viewController;
@property (nonatomic, retain) IBOutlet UIView *adsenseContainer;

+ (JoseonCameraAppDelegate *)sharedAppDelegate;

@end

