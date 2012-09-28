//
//  FontViewController.h
//  JoseonCamera
//
//  Created by Jeong YunWon on 10. 5. 23..
//  Copyright 2010 3rddev.org. All rights reserved.
//

@interface FontViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UIImageView *_fontImageView, *_backgroundImageView;
	IBOutlet id delegate;
	IBOutlet UISlider *alphaSlider;
	NSArray *filenameArray, *fontnameArray;
}

- (IBAction) onDone:(id)sender;
- (IBAction) alphaChanged:(id)sender;

@property (nonatomic, retain) UIImageView *fontImageView;
@property (nonatomic, retain) UIImageView *backgroundImageView;

@end
