//
//  APIManager.h
//  SUSYNCT
//
//  Created by Attique Ullah on 09/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject
#pragma mark - ShareInstance Method Implementation

+(id)sharedInstance;
-(void)facebookBookLoginPressedWithKey:(NSString*)key withCompletionBlock:(void(^)( BOOL success, NSError *error))completionBlock;
#pragma  mark Signup Method
-(void)signupWithUsername:(NSString*)username andPassword:(NSString*)password andEmail:(NSString*)email andStudent:(BOOL)isStudent andFirstName:(NSString*)fname andLastName:(NSString*)lname inController:(UIViewController*)controller withCompletionBlock:(void(^)(PFUser *user, BOOL success, NSError *error))completionBlock;
#pragma  mark Login Email Method
-(void)signinWithUsername:(NSString*)username andPassword:(NSString*)password  inController:(UIViewController*)controller withCompletionBlock:(void(^)(PFUser *user, BOOL success, NSError *error))completionBlock;
-(void)saveParseDataWithObject:(PFObject*)obj withCompletionBlock:(void(^)(BOOL succeeded, NSError *error))completionBlock;
#pragma mark Intialize Push Method
-(void)setPushNotifications;
#pragma mark Intialize Get Location Method
-(void)setLocationUpdate;
@end
