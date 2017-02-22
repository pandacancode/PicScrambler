//
//  FlickrJsonModel.h
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 19/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FlickrJsonItemDetails.h"

@interface FlickrJsonModel : JSONModel

@property (nonatomic) NSArray<FlickrJsonItemDetails> *items;

@end
