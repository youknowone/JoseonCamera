//
//  JoseonCameraViewController.m
//  JoseonCamera
//
//  Created by Jeong YunWon on 10. 5. 22..
//  Copyright 3rddev.org 2010. All rights reserved.
//

#import "JoseonCameraAppDelegate.h"
#import "JoseonCameraViewController.h"
#import "FontViewController.h"

@implementation JoseonCameraViewController
@synthesize fontViewController, scrollView;

-(void) onFont:(id)sender {
	[self presentModalViewController:fontViewController animated:YES];
	fontViewController.fontImageView.alpha = no1ImageView.alpha;
	fontViewController.backgroundImageView.image = joseonImageView.image;
}

- (void) onCompose:(id)sender {
	if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO ) {
		[self onPick:nil];
		return;
	}
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"사진 선택"
															 delegate:self
													cancelButtonTitle:@"취소"
											   destructiveButtonTitle:@"새로운 사진 찍기"
													otherButtonTitles:@"기존의 사진 사용", nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void) onPick:(id)sender {
	UIImagePickerController *picker = imagePickerViewController;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	if ( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
		popover = [[UIPopoverController alloc] initWithContentViewController:picker];
		[popover setPopoverContentSize:self.view.bounds.size];
		[popover presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		[popover setDelegate:self];
		return;
	} else {
		[self presentModalViewController:picker animated:YES];
        [JoseonCameraAppDelegate sharedAppDelegate].adsenseContainer.hidden = YES;
	}
	JoseonCameraAppDelegate *appDelegate = (JoseonCameraAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.adsenseContainer.hidden = YES;
}

- (void) onTake:(id)sender {
	UIImagePickerController *picker = imagePickerViewController;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:picker animated:YES];
    [JoseonCameraAppDelegate sharedAppDelegate].adsenseContainer.hidden = YES;
	picker.cameraOverlayView = overlayView;
}

void *context;
- (void) imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	UIAlertView *alert;
	if ( nil == error ) {
		alert = [[UIAlertView alloc] initWithTitle:@"저장 성공"
										   message:@"이미지가 저장되었습니다. 애플리케이션을 닫은 후 사진->카메라롤 에서 확인하실 수 있습니다."
										  delegate:nil
								 cancelButtonTitle:@"확인"
								 otherButtonTitles:nil];
	} else {
		alert = [[UIAlertView alloc] initWithTitle:@"저장 실패"
										   message:[NSString stringWithFormat:@"저장에 실패했습니다. 다시 시도해 주세요. 오류: %@", error]
										  delegate:nil
								 cancelButtonTitle:@"확인"
								 otherButtonTitles:nil];
	}
	[alert show];
	[alert release];
	self.view.userInteractionEnabled = YES;
	waitLabel.hidden = YES;
	[activityIndicator stopAnimating];
}

- (void) onSaveStart:(id)sender {
	UIImageWriteToSavedPhotosAlbum([self processImage:joseonImageView.image], self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), context);
	
}

- (void) onSave:(id)sender {
	if ( joseonImageView.image == nil ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"저장 실패"
														message:@"찍은 사진이 없어 저장할 수 없습니다. 먼저 '새로 만들기'를 해주세요."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return;
	}
	self.view.userInteractionEnabled = NO;
	[activityIndicator startAnimating];
	waitLabel.hidden = NO;
	[self onSaveStart:sender];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	CGFloat viewWidth = scrollView.frame.size.width;
	CGFloat viewHeight = scrollView.frame.size.height;
	scrollView.contentSize = CGSizeMake(viewWidth*10, viewHeight*10);	
	[scrollView setContentOffset:CGPointMake(viewWidth*5-viewWidth/2, viewHeight*5-viewHeight/2) animated:NO];
	
	CGRect frame = overlaySubview.frame;
	frame.size = scrollView.contentSize;
	overlaySubview.frame = frame;
	scrollView.maximumZoomScale = 4;
	scrollView.minimumZoomScale = 0.1;
	scrollView.zoomScale = 0.5;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark ImagePickerController delegate
#define PI 3.1415926535

- (UIImage *) rotateImage:(UIImage *)image
{
	CGImageRef imageRef = image.CGImage;
	CGContextRef bitmap = CGBitmapContextCreate(
												NULL,
												image.size.width,
												image.size.height,
												CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
												CGImageGetBytesPerRow(imageRef),
												CGImageGetColorSpace(imageRef),
												CGImageGetBitmapInfo(imageRef)
												);
	CGContextTranslateCTM(bitmap, 0, image.size.height);
	CGContextRotateCTM (bitmap, -PI/2);
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, image.size.height, image.size.width), imageRef);
	
	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);
	
	return result;
}

- (UIImage *) processImage:(UIImage *)image {
	CGImageRef imageRef = image.CGImage;
	CGSize outSize = image.size.height > image.size.width ? image.size : CGSizeMake(image.size.height, image.size.width);
	if ( image.size.height < image.size.width ) image = [self rotateImage:image];
	NSLog(@"processing size: %.0fx%.0f orientation:%d", image.size.width,image.size.height, image.imageOrientation);
	CGContextRef bitmap = CGBitmapContextCreate(
												NULL,
												outSize.width,
												outSize.height,
												CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
												CGImageGetBytesPerRow(imageRef),
												CGImageGetColorSpace(imageRef),
												CGImageGetBitmapInfo(imageRef)
												);
	
	if ( image.imageOrientation == 3 ) {
		CGContextTranslateCTM(bitmap, 0, outSize.height);
		CGContextRotateCTM(bitmap,-PI/2);
	}
	
	if ( image.imageOrientation == 3 ) {
		CGContextDrawImage(bitmap, CGRectMake(0, 0, outSize.height, outSize.width), imageRef);
	} else {
		CGContextDrawImage(bitmap, CGRectMake(0, 0, outSize.width, outSize.height), imageRef);
	}
	
	if ( image.imageOrientation == 3 ) {
		CGContextRotateCTM(bitmap, PI/2);
		CGContextTranslateCTM(bitmap, 0,-outSize.height);
	}
	CGContextSetAlpha(bitmap, no1ImageView.alpha);

	CGSize no1Size = CGSizeMake(no1ImageView.image.size.width*scrollView.zoomScale, no1ImageView.image.size.height*scrollView.zoomScale);
	CGPoint no1Point = CGPointMake((no1ImageView.frame.size.width-no1Size.width)/2, (no1ImageView.frame.size.height-no1Size.height)/2);
	CGRect subrect = CGRectMake(no1Point.x-scrollView.contentOffset.x, joseonImageView.frame.size.height-(no1Point.y-scrollView.contentOffset.y)-no1Size.height, no1Size.width, no1Size.height);
	CGFloat xrate = outSize.width /joseonImageView.frame.size.width;
	CGFloat yrate = outSize.height/joseonImageView.frame.size.height;
	CGContextDrawImage(bitmap, CGRectMake(subrect.origin.x*xrate, subrect.origin.y*yrate, subrect.size.width*xrate, subrect.size.height*yrate), no1ImageView.image.CGImage);
	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);
	
	return result;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	if ( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
		[popover dismissPopoverAnimated:YES];
		[popover release];
		popover = nil;
	}
	[picker dismissModalViewControllerAnimated:YES];
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	NSLog(@"%.0f x %.0f", image.size.width, image.size.height);
	if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
		picker.cameraOverlayView = nil;
		image = [self rotateImage:image];
	} else {
		if ( image.size.height < image.size.width ) image = [self rotateImage:image];
	}

    [JoseonCameraAppDelegate sharedAppDelegate].adsenseContainer.hidden = NO;
	joseonImageView.image = image;
	[self.view addSubview:overlayView];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
 	if ( picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
		picker.cameraOverlayView = nil;
    }
    [JoseonCameraAppDelegate sharedAppDelegate].adsenseContainer.hidden = NO;
	[self.view addSubview:overlayView];
}

#pragma mark -
#pragma mark scrollView delegate

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return overlaySubview;
}

#pragma mark -
#pragma mark modalViewController delegate

- (void) modalViewControllerDismissed:(UIViewController *)viewController {
	no1ImageView.image = ((FontViewController *)viewController).fontImageView.image;
	no1ImageView.alpha = ((FontViewController *)viewController).fontImageView.alpha;
}

#pragma mark -
#pragma mark actionSheet delegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0: [self onTake:nil]; break;
		case 1: [self onPick:nil]; break;
		default: break;
	}
}

#pragma mark -
#pragma mark popover delegate


@end
