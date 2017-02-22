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

@property (nonatomic) NSString *imagePath;
@property (nonatomic) NSUInteger imageIndex;
@property (nonatomic) BOOL isVisible;
@property (nonatomic) BOOL wasSelected;

@end
