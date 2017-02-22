//
//  ImageObject.h
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 21/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageObject : NSObject

-(id) initWithImagePath:(NSString*)path withIndex:(NSUInteger)index;

@property (nonatomic) NSString *imagePath;
@property (nonatomic) NSUInteger imageIndex;
@property (nonatomic) BOOL isVisible;
@property (nonatomic) BOOL wasSelected;

@end
