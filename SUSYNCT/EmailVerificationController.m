//
//  EmailVerificationController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 20/01/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "EmailVerificationController.h"

@interface EmailVerificationController ()
@property (weak, nonatomic) IBOutlet UIButton *finish;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@end

@implementation EmailVerificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.finish.layer.cornerRadius = 8.0;
    self.finish.layer.borderColor = [UIColor blackColor].CGColor;
    self.finish.layer.borderWidth = 1.0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction
- (IBAction)btnFinish:(id)sender {
    
    if (self.userData.isStudent) {
        if (![DATAMANAGER NSStringIsValidEmail:self.txtEmail.text]) {
            [DATAMANAGER showWithStatus:@"Invalid School Email Address" withType:ERROR];
            return;
        }
        else
        {
            if ([self.txtEmail.text containsString:@"usc.edu"]==NSNotFound) {
                [DATAMANAGER showWithStatus:@"Please Enter Correct School Email" withType:ERROR];
                return;
            }
        }
        
    }
    else
    {
        if (self.txtEmail.text.length==0) {
            [DATAMANAGER showWithStatus:@"Please Enter Email" withType:ERROR];
            return;
            
        }
        else
        {
            if (!([self.txtEmail.text isEqualToString:[PFUser currentUser][@"email"]])) {
                [DATAMANAGER showWithStatus:@"Email already taken" withType:ERROR];
                return;
            } else if (![DATAMANAGER NSStringIsValidEmail:self.txtEmail.text]) {
                [DATAMANAGER showWithStatus:@"Invalid email address" withType:ERROR];
                return;
            }
        }
    }
    
    PFQuery* query = [PFUser query];
    [query whereKey:@"email" equalTo:self.txtEmail.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error){
        
        
        if ( [self.txtEmail.text isEqualToString:[PFUser currentUser][@"email"]]) {
           
            self.userData.email = self.txtEmail.text;
            [self registerStudent];
            
        }
        
        if (objects.count>0) {
            self.userData.validEmail = NO;
            [self.txtEmail becomeFirstResponder];
            [DATAMANAGER showWithStatus:@"Email already taken" withType:ERROR];
            
            
        }
        else
        {
            self.userData.validEmail = YES;
            self.userData.email = self.txtEmail.text;
            [self registerStudent];
        }
    }];
}

-(void)registerStudent
{
    [PARSEMANAGER signupWithUsername:self.userData.username andPassword:self.userData.password andEmail:self.txtEmail.text andStudent:self.userData.isStudent andFirstName:self.userData.first_name andLastName:nil inController:self withCompletionBlock:^(PFUser *user, BOOL success, NSError *error){
        if (success && !error) {
            /////Go to Home Screen////
            
            [NSUserDefaults saveObject:[NSDate date] forKey:@"loginDate"];
            [AppDelegateAccessor goToDashboard:self];
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
