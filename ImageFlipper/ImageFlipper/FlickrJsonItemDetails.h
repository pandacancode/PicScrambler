//
//  FlickrJsonItemDetails.h
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 20/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol FlickrJsonItemDetails
@end

@interface FlickrJsonItemDetails : JSONModel

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *link;
@property (nonatomic) NSDictionary *media;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *author_id;

@end
