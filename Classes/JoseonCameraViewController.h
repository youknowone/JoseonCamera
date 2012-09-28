//
//  JoseonCameraViewController.h
//  JoseonCamera
//
//  Created by Jeong YunWon on 10. 5. 22..
//  Copyright 3rddev.org 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FontViewController;
@interface JoseonCameraViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIScrollViewDelegate> {
	IBOutlet FontViewController *fontViewController;
	IBOutlet UIImagePickerController *imagePickerViewController;
	IBOutlet UIView *overlayView, *overlaySubview;
	IBOutlet UIImageView *joseonImageView, *no1ImageView;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UILabel *waitLabel;
	id popover;
}

@property (nonatomic, retain) FontViewController *fontViewController;
@property (nonatomic, retain) UIScrollView *scrollView;

- (void) modalViewControllerDismissed:(UIViewController *)viewController;

- (IBAction) onFont:(id)sender;
- (IBAction) onCompose:(id)sender;
- (void) onPick:(id)sender;
- (void) onTake:(id)sender;
- (IBAction) onSave:(id)sender;

- (UIImage *) rotateImage:(UIImage *)image;
- (UIImage *) processImage:(UIImage *)image;

@end

