//
//  FlippingCollectionReusableView.h
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 20/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 This class is used to just define the header and footer of main collection view.
 */
@interface FlippingCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageHeader;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageFooter;

@end
