//
//  APIS.m
//  CEAS
//
//  Created by Attique Ullah on 13/10/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "APIS.h"
@implementation APIS
+(id)sharedInstance
{
    static APIS *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [self manager];
        _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sharedManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });
    return _sharedManager;
}
- (void)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters withCompletionBlock:(requestCompletionBlock) completionBlock andFailureBlock:(requestFailureBlock)failureBlock
{
    [DATAMANAGER checkInterneConnectivitywithCompletionBlock:^(BOOL isConnected){
        if (isConnected) {
            [DATAMANAGER showWithStatus:@"Please wait..." withType:STATUS];
            if ([method isEqualToString:@"GET"]) {
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                //manager.requestSerializer.timeoutInterval = 30;
                [manager GET:[NSString stringWithFormat:@"%@/%@",UNI_URL,path] parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject){
                        //
                    [SVProgressHUD dismiss];
                    NSError *jsonError;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&jsonError];
                    
                    completionBlock(task,json);
                                       
                }
                   failure:^(NSURLSessionTask *operation, NSError *error){
                       [SVProgressHUD showErrorWithStatus:error.debugDescription];
                       failureBlock(operation,error);
                   }];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"No Internet Found"];
        }
 
    }];
    
}

@end
