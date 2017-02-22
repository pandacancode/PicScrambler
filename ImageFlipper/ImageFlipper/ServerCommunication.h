//
//  ServerCommunication.h
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 20/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//


#import <Foundation/Foundation.h>


typedef enum : NSUInteger
{
    GET,
    POST,
    DELETE,
    PATCH,
    PUT
} REQUEST_METHOD;

@protocol ServerCommunicationDelegate <NSObject>

/**
 Callback for '', which implementing class will recieve when the data fetching from server completes.

 @param data Recieved data is NSData format. Conforming class is free to convert this in required format.
 @param error Contains error details in case of failure, nil if server call succeeded.
 */
-(void) serverCommunicationCompletedWithData:(NSData*)data withError:(NSError*)error;

/**
 Callback only when request sending fails because of some reason. Simple reason being URL was not set by user. Callback is not called if there's no error in request sending.

 @param error Contains error details in case of failure.
 */
-(void) requestSendingFailedWithError:(NSError*)error;

@end


@interface ServerCommunication : NSObject

@property (nonatomic) id<ServerCommunicationDelegate> delegate;

/**
 Creates a singleton object of ServerCommunication class. Singleton is used to reuse single NSURLSession all the time. Return object can be used for making server calls.

 @return ServerCommunication object
 */
+(ServerCommunication*) getSingleInstance;

/**
 Allows user to set the type of request. Allowed values are available in REQUEST_METHOD enum.

 @param method REQUEST_METHOD enum value
 */
-(void) setRequestType:(REQUEST_METHOD)method;

/**
 Sets URL for the request

 @param url URL is String format.
 */
-(void) setURLForRequest:(NSString*)url;

/**
 User can set the request parameters using this method. Parameters will be embedded in request based on the request type. Ex - For GET request, this dictionary should be converted to query parameters. For POST, same dictionary should be embedded in request body.

 @param params Request parameter in dictionary format {key:value}
 */
-(void) setParametersForRequest:(NSDictionary*)params;


/**
 Sends request to server based on above configurations.
 */
-(void) sendRequestToServer;

@end
