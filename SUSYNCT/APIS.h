//
//  APIS.h
//  CEAS
//
//  Created by Attique Ullah on 13/10/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^requestCompletionBlock) (NSURLSessionTask *task, NSDictionary* responseObject);
typedef void (^requestFailureBlock) (NSURLSessionTask *task, NSError *error) ;

@interface APIS : AFHTTPSessionManager
+(id)sharedInstance;
- (void)requestWithMethod:(NSString *)method
                     path:(NSString *)path
               parameters:(NSDictionary *)parameters withCompletionBlock:(requestCompletionBlock) completionBlock andFailureBlock:(requestFailureBlock)failureBlock;
@end
