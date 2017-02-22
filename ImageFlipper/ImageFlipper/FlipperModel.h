//
//  FlipperModel.h
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 19/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "FlickrJsonModel.h"
#import "FlickrJsonItemDetails.h"
#import "ServerCommunication.h"
#import "ImageObject.h"

@protocol FlipperDelegate <NSObject>

/**
 Callback for 'getFlickrPhotos' method.

 @param response JSON Response if the fetch was successfull
 @param error Error object if error occurred else nil
 */
-(void) fetchedPhotosWithResponse:(id)response withError:(NSError*)error;



/**
 <#Description#>

 @param object <#object description#>
 */
-(void) receivedRandomObject:(ImageObject*)object;

@end

/**
 Flipper model class
 */
@interface FlipperModel : NSObject <ServerCommunicationDelegate>

@property (nonatomic) id<FlipperDelegate> delegate;

-(id) initWithURLString:(NSString*)url withParams:(NSDictionary*)params withRequestMethod:(REQUEST_METHOD)method;

-(void) getFlickrPhotos;

-(void) flickImageCells;

-(void) getRandomObject;
-(void) resetValues;

@end
