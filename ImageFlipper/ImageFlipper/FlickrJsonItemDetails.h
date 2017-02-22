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

@property (nonatomic) NSString<Optional> *title;
@property (nonatomic) NSString<Optional> *link;
@property (nonatomic) NSDictionary *media;
@property (nonatomic) NSString<Optional> *author;
@property (nonatomic) NSString<Optional> *author_id;

@end
