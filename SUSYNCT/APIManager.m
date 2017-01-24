//
//  APIManager.m
//  SUSYNCT
//
//  Created by Attique Ullah on 09/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager
#pragma mark - ShareInstance Method Implementation
+(id)sharedInstance
{
    static APIManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[APIManager alloc] init];
    });
    return _sharedManager;
}
#pragma mark Facebook Login
-(void) storeFacebookIdOnServerWithKey:(NSString*)key withCompletionBlock:(void(^)( BOOL success, NSError *error))completionBlock
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Store the current user's Facebook ID on the user
            [[PFUser currentUser] setObject:[result objectForKey:@"id"]forKey:key];
            [[PFUser currentUser] setObject:[result objectForKey:@"name"]forKey:@"username"];
            [[PFUser currentUser] saveInBackground];
            NSDictionary *userData = (NSDictionary *)result;
            NSLog(@"User with facebook logged in! his data is %@",userData);
            completionBlock(YES,nil);
        }else{
            completionBlock(NO,error);
        }

    }];
}
-(void)facebookBookLoginPressedWithKey:(NSString*)key withCompletionBlock:(void(^)( BOOL success, NSError *error))completionBlock
{
    NSArray *permissions = @[ @"user_about_me",@"email", @"user_relationships", @"user_birthday", @"user_location"];

    
    [DATAMANAGER checkInterneConnectivitywithCompletionBlock:^(BOOL isavailable)
     {
         if (!isavailable) {
             [DATAMANAGER showWithStatus:INTERNET withType:ERROR];
            
             return ;
         }
         // Login PFUser using Facebook
          [DATAMANAGER showWithStatus:@"Please wait..." withType:STATUS];
         [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
             if (!user) {
                 NSLog(@"Uh oh. The user cancelled the Facebook login.");
                 completionBlock(NO,error);
             } else if (user.isNew) {
                 NSLog(@"User signed up and logged in through Facebook!");
                 [self storeFacebookIdOnServerWithKey:key withCompletionBlock:^(BOOL result , NSError *error){
                     if (result) {
                         [SVProgressHUD dismiss];
                         [AppDelegate sendUserLocationToServer];
                         completionBlock(result,nil);
                     }else
                     {
                         completionBlock(result,error);
                     }
                 }];
             } else {
                 NSLog(@"User logged in through Facebook!");
                 [self storeFacebookIdOnServerWithKey:key withCompletionBlock:^(BOOL result , NSError *error){
                     if (result) {
                         [SVProgressHUD dismiss];
                         [AppDelegate sendUserLocationToServer];
                         completionBlock(result,nil);
                     }
                     else
                     {
                         completionBlock(result,error);
                     }
                     
                 }];
             }
         }];
    }];
    
}

#pragma  mark Signup Method
-(void)signupWithUsername:(NSString*)username andPassword:(NSString*)password andEmail:(NSString*)email andStudent:(BOOL)isStudent andFirstName:(NSString*)fname andLastName:(NSString*)lname inController:(UIViewController*)controller withCompletionBlock:(void(^)(PFUser *user, BOOL success, NSError *error))completionBlock

{
    controller.view.userInteractionEnabled = NO;
    [DATAMANAGER checkInterneConnectivitywithCompletionBlock:^(BOOL isavailable)
     {
         if (!isavailable) {
             [DATAMANAGER showWithStatus:INTERNET withType:ERROR];
             controller.view.userInteractionEnabled = YES;
             return ;
         }
         [DATAMANAGER showWithStatus:@"Please wait..." withType:STATUS];
         PFUser *user = [PFUser user];
         user.username = username;
         user.password = password;
         user.email = email;
         user[@"name"] = fname;
         user[@"isStudent"]  = [NSNumber numberWithBool:isStudent];
         
         [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
             controller.view.userInteractionEnabled = YES;
             if (!error) {
                 [SVProgressHUD dismiss];
                 
                 completionBlock(user,succeeded,nil);
             } else {
                 completionBlock(user,NO,error);
             }
         }];
         
     }];
}
#pragma  mark Login Email Method
-(void)signinWithUsername:(NSString*)username andPassword:(NSString*)password  inController:(UIViewController*)controller withCompletionBlock:(void(^)(PFUser *user, BOOL success, NSError *error))completionBlock
{
     controller.view.userInteractionEnabled = NO;
    [DATAMANAGER checkInterneConnectivitywithCompletionBlock:^(BOOL isavailable)
     {
         if (!isavailable) {
             [DATAMANAGER showWithStatus:INTERNET withType:ERROR];
             controller.view.userInteractionEnabled = YES;
             return ;
         }
         [DATAMANAGER showWithStatus:@"Please wait..." withType:STATUS];
         [PFUser logInWithUsernameInBackground:username password:password
                                         block:^(PFUser *user, NSError *error) {
                                             [SVProgressHUD dismiss];
                                             controller.view.userInteractionEnabled = YES;
                                             if (user) {
                                                 [user saveInBackgroundWithBlock:nil];
                                                 completionBlock(user,YES,nil);
                                             } else {
                                                 completionBlock(nil,NO,error);
                                             }
                                             
        }];
    }];
    
}

#pragma mark Intialize Push Method
-(void)setPushNotifications
{
    
}
#pragma mark Intialize Get Location Method
-(void)setLocationUpdate
{
    
}
@end
