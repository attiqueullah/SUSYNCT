//
//  DataManger.h
//  SUSYNCT
//
//  Created by Attique Ullah on 09/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "INTULocationManager.h"

typedef NS_ENUM(NSUInteger, ProgressHUDType) {
    STATUS = 1,
    SUCESS,
    ERROR,
    IMAGE,
    PROGRESS,
    INFO
};

typedef NS_ENUM(NSUInteger, DayView)
{
    Monday   = 0,
    Tuesday  = 1,
    Wednesday= 2,
    Thrusday = 3,
    Friday   = 4,
    Saturday = 5,
    Sunday   = 6,
};
typedef NS_ENUM(NSUInteger, EventType)
{
    Course   = 0,
    Event    = 1,
    Other    = 2,
};
typedef NS_ENUM(NSUInteger, Status)
{
    Default      = 0,
    Active       = 1,
    Inactive     = 2,
};

@interface DataManger : NSObject
@property(nonatomic,readonly)BOOL allowLocation;
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
#pragma mark Get User Location Availability
-(void)getLocationUpdatewithCompletionBlock:(void(^)(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status,NSString* error))completionBlock;
@end
