//
//  FlipperModel.m
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 19/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//

#import "FlipperModel.h"
#import "ServerCommunication.h"

#include <stdlib.h>

@interface FlipperModel() {
 
    FlickrJsonModel *formattedResponse;
    
    NSString *urlString;
    ServerCommunication *sharedComm;
    
    NSMutableArray *imageObjectsArray;
    NSMutableArray *randomChecker;
}
@end

@implementation FlipperModel

-(id) init {
    
    self = [super init];
    if (self) {
    }
    return self;
}

-(id) initWithURLString:(NSString *)url withParams:(NSDictionary *)params withRequestMethod:(REQUEST_METHOD)method {
    
    sharedComm = [ServerCommunication getSingleInstance];
    sharedComm.delegate = self;
    
    [sharedComm setURLForRequest:url];
    [sharedComm setRequestType:method];
    [sharedComm setParametersForRequest:params];
    
    randomChecker = [[NSMutableArray alloc] initWithCapacity:9];
    
    return self;
}

// Separate Server Communication class can be created here...
-(void) getFlickrPhotos {
    
    [sharedComm sendRequestToServer];
}

-(void) flickImageCells {
    
    
}

-(void) resetValues {
    
    randomChecker = nil;
    randomChecker = [[NSMutableArray alloc] initWithCapacity:9];
}

-(void) getRandomObject {
    
    NSUInteger random = arc4random_uniform(9);
    
    NSLog(@"Random generated - %ld",random);
    if ([randomChecker containsObject:@(random)]) {
        [self getRandomObject];
    }
    else {
    
        [randomChecker addObject:@(random)];
        ImageObject *randomImageObject = [imageObjectsArray objectAtIndex:random];
        if ([self.delegate respondsToSelector:@selector(receivedRandomObject:)]) {
            
            [self.delegate receivedRandomObject:randomImageObject];
        }
    }
}

#pragma ServerCommunication delegates
-(void) serverCommunicationCompletedWithData:(NSData *)data withError:(NSError *)error {
    
    if (error) {
        NSLog(@"Server Comm Failed with Error - %@",[error description]);
    }
    else {
        
        NSMutableString *unformattedString = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        /*
         This hack has been done to fix the malformed JSON being sent by FlickrAPI. This is a known issue.
         https://www.flickr.com/groups/51035612836@N01/discuss/72157622950514923/
         */
        unformattedString = [[unformattedString substringWithRange:NSMakeRange(15, unformattedString.length-16)] mutableCopy];
        
        // Convert unformatted string to JSON object using JSONModel and pick out ImagePaths from object. Storing them in an array.
        formattedResponse = [[FlickrJsonModel alloc] initWithString:unformattedString error:&error];
        if (!error) {
            
            imageObjectsArray = [[NSMutableArray alloc] init];
            int count = 0;
            for (FlickrJsonItemDetails *obj in formattedResponse.items) {
                
                [imageObjectsArray addObject:[[ImageObject alloc] initWithImagePath:[obj.media objectForKey:@"m"] withIndex:count]];
                count++;
            }
        }
    
        // Passing parsed response to caller, in current case FlippingViewController
        if ([self.delegate respondsToSelector:@selector(fetchedPhotosWithResponse:withError:)]) {
            
            [self.delegate fetchedPhotosWithResponse:imageObjectsArray withError:error];
        }
    }
}

-(void) requestSendingFailedWithError:(NSError *)error {
    
    if (error) {
        NSLog(@"Request Sending Failed with Error - %@",[error description]);
    }
}

@end
