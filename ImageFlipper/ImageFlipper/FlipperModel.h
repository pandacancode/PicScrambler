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


/**
 Protocol for a user to receive events/responses happening in 'FlipperModel' class
 */
@protocol FlipperDelegate <NSObject>

/**
 Callback for 'getFlickrPhotos' method. Calling class gets the response/error in this callback if conforming to this protocol.

 @param response JSON Response if the fetch was successfull
 @param error Error object if error occurred else nil
 */
-(void) fetchedPhotosWithResponse:(id)response withError:(NSError*)error;

/**
 Callback for 'getRandomObject' method. Calling class gets the random ImageObject in this callback if conforming to this protocol. This is used to show to user for guessing.

 @param object ImageObject randomly chosen
 */
-(void) receivedRandomObject:(ImageObject*)object;

@end

/**
 This class acts as a controller between communication class and ViewController class.
 */
@interface FlipperModel : NSObject <ServerCommunicationDelegate>

@property (nonatomic) id<FlipperDelegate> delegate;


/**
 Designated initialiser to receive required information for setting up server connection.

 @param url URL to connect to
 @param params Request parameters if any
 @param method Request method
 @return Returns self object
 */
-(id) initWithURLString:(NSString*)url withParams:(NSDictionary*)params withRequestMethod:(REQUEST_METHOD)method;


/**
 Method which initiates the server call to fetch Flickr photos
 */
-(void) getFlickrPhotos;

/**
 This method selects a random ImageObject and returns in a callback
 */
-(void) getRandomObject;

/**
 Method to reset local values in this class when game's next iteration starts 
 */
-(void) resetValues;

@end
