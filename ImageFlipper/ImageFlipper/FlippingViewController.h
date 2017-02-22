//
//  FlippingViewController.h
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 19/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlippingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *imageGridCollection;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *randomImageView;
@property (weak, nonatomic) IBOutlet UIButton *playAgainBtn;

- (IBAction)playAgainPressed:(UIButton *)sender;

@end
