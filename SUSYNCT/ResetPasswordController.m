//
//  ResetPasswordController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 13/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "ResetPasswordController.h"

@interface ResetPasswordController ()
@property (weak, nonatomic) IBOutlet UIButton *resetPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@end

@implementation ResetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.resetPassword.layer.cornerRadius = 8.0;
    self.resetPassword.layer.borderColor = [UIColor blackColor].CGColor;
    self.resetPassword.layer.borderWidth = 1.0;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnResetPassword:(id)sender {
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
