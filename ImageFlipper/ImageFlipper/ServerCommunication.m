//
//  ServerCommunication.m
//  ImageFlipper
//
//  Created by Ankit Bharadwaj on 20/02/17.
//  Copyright © 2017 com.flipper. All rights reserved.
//

#import "ServerCommunication.h"

@interface ServerCommunication()<NSURLSessionDelegate, NSURLSessionDataDelegate> {
 
    NSURL *_url;
    NSString *_method;
    NSDictionary *_parameters;
    
    NSURLSessionConfiguration *configuration;
    NSURLSession *session;
}
@end

@implementation ServerCommunication

-(id) init {
 
    configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    return self;
}

+(ServerCommunication*) getSingleInstance {
    
    static ServerCommunication *sharedObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

-(void) setRequestType:(REQUEST_METHOD)method {
    
    switch (method)
    {
        case GET:
            _method = @"GET";
            break;
        case POST:
            _method = @"POST";
            break;
        case PATCH:
            _method = @"PATCH";
            break;
        case PUT:
            _method = @"PUT";
            break;
        case DELETE:
            _method = @"DELETE";
            break;
        default:
            break;
    }
}

-(void) setURLForRequest:(NSString*)url {
    
    if (url)
        _url = [NSURL URLWithString:url];
}

-(void) setParametersForRequest:(NSDictionary*)params {
    
    if (params)
        _parameters = params;
}

-(void) addRequestParameters
{
    NSMutableString *urlString;
    if (_parameters) {
        
        if (_url && [_method isEqualToString:@"GET"]) {
            
            urlString = [[_url absoluteString] mutableCopy];
            [urlString appendString:@"?"];
            for (id key in _parameters) {
                
                [urlString appendFormat:@"%@=%@&",[NSString stringWithFormat:@"%@",key],[_parameters objectForKey:key]];
            }
            _url = [NSURL URLWithString:urlString];
        }
    }
    return;
}

-(void) sendRequestToServer
{
    // Check if URL available
    if (!_url)
    {
        if ([self.delegate respondsToSelector:@selector(requestSendingFailedWithError:)]) {
            
            NSError *error = [NSError errorWithDomain:@"ImageFlipperNetworkDomain" code:1234 userInfo:@{@"message":@"URL for request is not set"}];
            [self.delegate requestSendingFailedWithError:error];
            return;
        }
    }
    
    // Check for parameters to be added in the URL
    if (_parameters) {
        
        [self addRequestParameters];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
    
    // Check which request method did user set.
    if (_method)
        [request setHTTPMethod:_method];
    else
        [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *sendRequestTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(serverCommunicationCompletedWithData:withError:)]) {
            
            [self.delegate serverCommunicationCompletedWithData:data withError:error];
        }
    }];
    
    [sendRequestTask resume];
}

@end
