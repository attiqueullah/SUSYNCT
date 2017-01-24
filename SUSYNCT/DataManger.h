//
//  DataManger.h
//  SUSYNCT
//
//  Created by Attique Ullah on 09/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ProgressHUDType) {
    STATUS = 1,
    SUCESS,
    ERROR,
    IMAGE,
    PROGRESS,
    INFO
};

@interface DataManger : NSObject
+(id)sharedInstance;


#pragma mark SVProgressHud
-(void)showWithStatus:(NSString*)text withType:(ProgressHUDType)type;
#pragma mak Custom Methods
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
#pragma mark Check Internet Availability
-(void)checkInterneConnectivitywithCompletionBlock:(void(^)( BOOL connect))completionBlock;
#pragma mark GET Terms Service
-(void)getTermsWithCompletionBlock:(void (^)(NSArray*, NSError *))completionBlock;
#pragma mark GET Departmetns Service
-(void)getDepartmentsWithId:(NSString*)sessionId WithCompletionBlock:(void (^)(NSArray*, NSError *))completionBlock;
#pragma mark GET CLASSES Service
-(void)getClassesWithId:(NSString*)Id WithCompletionBlock:(void (^)(NSArray*, NSError *))completionBlock;
@end
