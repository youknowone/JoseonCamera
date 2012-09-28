    //
//  FontViewController.m
//  JoseonCamera
//
//  Created by Jeong YunWon on 10. 5. 23..
//  Copyright 2010 3rddev.org. All rights reserved.
//

#import "JoseonCameraAppDelegate.h"
#import "FontViewController.h"


@implementation FontViewController
@synthesize backgroundImageView=_backgroundImageView, fontImageView=_fontImageView;

- (void) onDone:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
	[delegate modalViewControllerDismissed:self];
}

- (UIImage *) getFontImage {
	return self.fontImageView.image;
}

- (void) alphaChanged:(id)sender {
	self.fontImageView.alpha = alphaSlider.value;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	filenameArray = [[NSArray alloc] initWithObjects:
					 @"num1_1_0.png", @"num1_1_1.png", @"num1_1_2.png",
					 @"num1_2_1.png", @"num1_2_2.png", @"num1_2_3.png",
					 @"002_bloom.png", @"002_line.png",
					 @"003_watered.png", @"005_oiled.png",
					 @"001_blue.png", @"006_magic.png", @"007_magic2.png",
					 nil];
	fontnameArray = [[NSArray alloc] initWithObjects:
					 @"맑은어뢰체", @"맑은어뢰체 오른쪽기울임", @"맑은어뢰체 왼쪽기울임",
					 @"사과어뢰체", @"사과어뢰체 오른쪽기울임", @"사과어뢰체 왼쪽기울임",
					 @"스크루", @"스크루 헤테로",
					 @"황해바닷물글꼴", @"포항급윤활유글꼴",
					 @"산화철튼튼체", @"해류튼튼체", @"조류튼튼체",
					 nil];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	alphaSlider.value = self.fontImageView.alpha;
	JoseonCameraAppDelegate *appDelegate = (JoseonCameraAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.adsenseContainer.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
	JoseonCameraAppDelegate *appDelegate = (JoseonCameraAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.adsenseContainer.hidden = NO;
	[super viewWillDisappear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[filenameArray release];
	[fontnameArray release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark pickerView protocols

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [fontnameArray count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [fontnameArray objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.fontImageView.image = [UIImage imageNamed:[filenameArray objectAtIndex:row]];
}

@end
