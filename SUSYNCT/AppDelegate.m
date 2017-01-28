//
//  AppDelegate.m
//  SUSYNCT
//
//  Created by Attique Ullah on 08/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
@interface AppDelegate ()<SWRevealViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupParse];
    
    NSDate* previousLogin = [NSUserDefaults retrieveObjectForKey:@"loginDate"];
    NSUInteger remainDays = [[NSDate date] daysAfterDate:previousLogin];
    if (remainDays<=DEFAULT_TIME && previousLogin !=nil) {
        [self goToDashboard:self.window.rootViewController];
    }
    self.window.backgroundColor = [UIColor lightGrayColor];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

-(void)goToDashboard:(UIViewController*)controller
{
    ScheduleSetupController *frontViewController = [STUDENT instantiateViewControllerWithIdentifier:NAV_MAIN];
    MenuViewController *rearViewController = [controller.storyboard instantiateViewControllerWithIdentifier:@"MenuController"];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:frontViewController];
    revealController.delegate = self;
   
    revealController.rearViewRevealWidth = 250;
    revealController.rearViewRevealOverdraw = 0;
    revealController.bounceBackOnOverdraw = NO;
    revealController.stableDragOnOverdraw = YES;
    [revealController setFrontViewPosition:FrontViewPositionLeft];

    self.viewController = revealController;
    self.window.rootViewController = self.viewController;
}
-(void)setupParse
{
   ParseClientConfiguration* config = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = APPID;
        configuration.clientKey = CLIENTID;
        configuration.server = SERVER;
    }];
    [Parse initializeWithConfiguration:config];
    // [PFUser enableRevocableSessionInBackground];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
+(void)sendUserLocationToServer
{
    [DATAMANAGER getLocationUpdatewithCompletionBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status,NSString* error){
        if (!error) {
            PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
            [AppDelegate updateLocationOnParse:point];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:error];
        }
    }];
}
+(void)updateLocationOnParse:(PFGeoPoint*)dict
{
    PFUser* user = [PFUser currentUser];
    user[@"usrLocation"] = dict;
    [PARSEMANAGER saveParseDataWithObject:user withCompletionBlock:^(BOOL isSave , NSError* error){
        
    }];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma  mark SWReveal Delegates
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    
    if (position == FrontViewPositionLeft) {
        revealController.rearViewRevealWidth = 250;
        revealController.rearViewRevealOverdraw = 0;
    }
    if (position == FrontViewPositionRightMost) {
        revealController.rearViewRevealWidth = 60;
        revealController.rearViewRevealOverdraw = 120;
    }
}



@end
