//
//  ImageObject.m
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 21/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//

#import "ImageObject.h"

@implementation ImageObject

-(id) init {
    
    self = [super init];
    return self;
}

-(id) initWithImagePath:(NSString*)path withIndex:(NSUInteger)index {
    
    self.imagePath = path;
    self.imageIndex = index;
    self.isVisible = TRUE;
    self.wasSelected = FALSE;
    
    return self;
}

@end
