//
//  FlippingCollectionReusableView.h
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 20/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlippingCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageHeader;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageFooter;

@end
