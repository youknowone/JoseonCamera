//
//  JoseonCameraAppDelegate.m
//  JoseonCamera
//
//  Created by Jeong YunWon on 10. 5. 22..
//  Copyright 3rddev.org 2010. All rights reserved.
//

#import "JoseonCameraAppDelegate.h"
#import "JoseonCameraViewController.h"

#import "CaulyHelper.h"

@implementation JoseonCameraAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize adsenseContainer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
	[window bringSubviewToFront:adsenseContainer];
    [window makeKeyAndVisible];

    CaulyGlobalSet(@"iKFhptg8jU", viewController, adsenseContainer, nil);

	return YES;
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

+ (JoseonCameraAppDelegate *)sharedAppDelegate {
    return (JoseonCameraAppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
