//
//  ImageObject.h
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 21/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 This class is used to consolidate and maintain the image states, path(url) and index.
 */
@interface ImageObject : NSObject


/**
 Designated initialiser to create an ImageObject with path and index.

 @param path Web link where the image is available
 @param index Index of this link in the array
 @return Returns self object
 */
-(id) initWithImagePath:(NSString*)path withIndex:(NSUInteger)index;


/**
 Stores web link for the image
 */
@property (nonatomic) NSString *imagePath;

/**
 Stores the index on image in the storing array
 */
@property (nonatomic) NSUInteger imageIndex;

/**
 Stores whether the image is visible or flipped. Used in toggling grids in the CollectionView. Default value is TRUE.
 */
@property (nonatomic) BOOL isVisible;

/**
 Stores whether the image was correctly guessed while playing or not. Used while generating the random index to avoid repitition. Default value is FALSE.
 */
@property (nonatomic) BOOL wasSelected;

@end
