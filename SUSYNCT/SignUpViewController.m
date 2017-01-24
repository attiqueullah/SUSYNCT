//
//  SignUpViewController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 08/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "SignUpViewController.h"
#import "TextFieldCell.h"
#import "TermsViewController.h"
#import "EmailVerificationController.h"

@interface SignUpViewController ()<TTTAttributedLabelDelegate>
@property (nonatomic,strong)UserInfo* userData;
@property (weak, nonatomic) IBOutlet UITableView *tblSignIn;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userData = [[UserInfo alloc]init];
    // Do any additional setup after loading the view.
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


-(void)hideKeyboard
{
    NSArray* arr = self.tblSignIn.visibleCells;
    for (TextFieldCell * cell in arr) {
        if ([cell isKindOfClass:[TextFieldCell class]]) {
            if ([cell.txtInput1 isFirstResponder] || [cell.txtInput2 isFirstResponder]) {
                [cell.txtInput1 resignFirstResponder];
                 [cell.txtInput2 resignFirstResponder];
                break;
            }
        }
    }
}
-(void)showAlertNotification
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:APP_TITLE
                                 message:@"Thanks for joining XXX. Your next task is to setup your schedule so you can start using XXX."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark IBActions
-(void)showPassword:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblSignIn];
    NSIndexPath *indexPath = [self.tblSignIn indexPathForRowAtPoint:buttonPosition];
    TextFieldCell* cell = [self.tblSignIn cellForRowAtIndexPath:indexPath];
    if (cell.txtInput1.text.length==0) {
        return;
    }
    if (sender.tag==0) {
        cell.btnShowPassword.tag = 1;
        [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"eye-slash"] forState:UIControlStateNormal];
        cell.txtInput1.secureTextEntry = NO;
    }
    else
    {
        cell.btnShowPassword.tag = 0;
        [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
        cell.txtInput1.secureTextEntry = YES;
    }
}
-(void)btnTermsAndConditions:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblSignIn];
    NSIndexPath *indexPath = [self.tblSignIn indexPathForRowAtPoint:buttonPosition];
    TextFieldCell* cell = [self.tblSignIn cellForRowAtIndexPath:indexPath];
    
    if (sender.tag==2) {
        cell.btnAction.tag = 3;
        [cell.btnAction setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        self.userData.isAgreeTerms = YES;
    }
    else if (sender.tag==3)
    {
        cell.btnAction.tag = 2;
        [cell.btnAction setBackgroundImage:[UIImage imageNamed:@"unCheck"] forState:UIControlStateNormal];
        self.userData.isAgreeTerms = NO;
    }
}

-(void)btnSignUp:(UIButton*)sender
{
    [self hideKeyboard];
    [self performSegueWithIdentifier:@"email_verifi" sender:self.userData];

    /*if (self.userData.first_name.length==0) {
        [DATAMANAGER showWithStatus:@"Please Enter Full Name" withType:ERROR];
        return;
        
    }
    if (self.userData.username.length==0) {
        [DATAMANAGER showWithStatus:@"Please Enter Username" withType:ERROR];
        return;
        
    }
    else
    {
        if (!self.userData.validUsername) {
            [DATAMANAGER showWithStatus:@"Username already taken" withType:ERROR];
            return;
        }
    }
    
    
    if (!self.userData.isAgreeTerms) {
        [DATAMANAGER showWithStatus:@"Please Agree To Terms & Conditions" withType:ERROR];
        return;
    }
    */
}
-(void)btnSignUpFacebook:(UIButton*)sender
{
    [PARSEMANAGER facebookBookLoginPressedWithKey:@"fbID" withCompletionBlock:^(BOOL result , NSError *error){
        if (result) {
            [NSUserDefaults saveObject:[NSDate date] forKey:@"loginDate"];
            [AppDelegateAccessor goToDashboard:self];
        }else{
            
        }
    }];

}
-(void)btnSignUpGoogle:(UIButton*)sender
{
}
-(void)btnSignUpTwitter:(UIButton*)sender
{
}
- (IBAction)selectStudentOption:(UISwitch*)sender {
    self.userData.isStudent = sender.isOn;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    
    if (indexPath.section==0) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextField1" forIndexPath:indexPath];
        
        cell.txtInput1.placeholder = @"Name";
        cell.txtInput1.autocapitalizationType = UITextAutocapitalizationTypeWords;
        
        [cell.txtInput1 setBk_didEndEditingBlock:^(UITextField *textField) {
            self.userData.first_name = textField.text;
        }];
        
        return cell;
        
    }
    /*if (indexPath.section==3) {
        if (indexPath.row==0) {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextField" forIndexPath:indexPath];
            
            cell.txtInput1.placeholder = @"Username";
            cell.txtInput1.keyboardType = UIKeyboardTypeEmailAddress;
            cell.btnShowPassword.hidden = YES;
            cell.activityCell.hidden = YES;
            [cell.txtInput1 setBk_didEndEditingBlock:^(UITextField *textField) {
                self.userData.validEmail = NO;
                self.userData.email = textField.text;
            }];
            [cell.txtInput1 setBk_shouldEndEditingBlock:^BOOL(UITextField *textField){
                
                if ([DATAMANAGER NSStringIsValidEmail:textField.text]) {
                    [cell.activityCell startAnimating];
                    cell.activityCell.hidden = NO;
                    PFQuery* query = [PFUser query];
                    [query whereKey:@"email" equalTo:textField.text];
                    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error){
                        
                        [cell.activityCell stopAnimating];
                        cell.activityCell.hidden = YES;
                        
                        if ( [textField.text isEqualToString:[PFUser currentUser][@"email"]]) {
                            [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
                            self.userData.validEmail = YES;
                            cell.btnShowPassword.hidden = NO;
                            self.userData.email = textField.text;
                            return;
                        }
                        
                        if (objects.count>0) {
                            self.userData.validEmail = NO;
                            [cell.txtInput1 becomeFirstResponder];
                            [DATAMANAGER showWithStatus:@"Email already taken" withType:ERROR];
                            
                        }
                        else
                        {
                            [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
                            cell.btnShowPassword.hidden = NO;
                            self.userData.validEmail = YES;
                            self.userData.email = textField.text;
                        }
                    }];
                    return YES;
                }
                else
                {
                    if (textField.text.length>0) {
                        [DATAMANAGER showWithStatus:@"Invalid email address" withType:ERROR];
                    }
                    return YES;
                    
                }
                
            }];
            // [cell.btnShowPassword addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnShowPassword.tag = 0;
            return cell;
            

        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValidateCell" forIndexPath:indexPath];
            cell.textLabel.text = @"Email Address is required to recover lost or forgotten password.";
            cell.textLabel.font = [UIFont fontWithName:AvenirRegular size:11.0];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.numberOfLines = 2.0;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }
            }*/
    if (indexPath.section==1) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextField" forIndexPath:indexPath];
        
        cell.txtInput1.placeholder = @"Username/User ID";
        cell.btnShowPassword.hidden = YES;
        cell.activityCell.hidden = YES;
        [cell.txtInput1 setBk_didEndEditingBlock:^(UITextField *textField) {
            self.userData.username = textField.text;
            self.userData.validUsername = NO;
        }];
        [cell.txtInput1 setBk_shouldEndEditingBlock:^BOOL(UITextField *textField){
            
            [cell.activityCell startAnimating];
            cell.activityCell.hidden = NO;
            PFQuery* query = [PFUser query];
            [query whereKey:@"username" equalTo:textField.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error){
                
                [cell.activityCell stopAnimating];
                cell.activityCell.hidden = YES;
                if ( [textField.text isEqualToString:[PFUser currentUser][@"username"]]) {
                    self.userData.validUsername = YES;
                    [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
                    cell.btnShowPassword.hidden = NO;
                    self.userData.username = textField.text;
                    return;
                }
                if (objects.count>0) {
                    self.userData.validUsername = NO;
                    [cell.txtInput1 becomeFirstResponder];
                    [DATAMANAGER showWithStatus:@"Username already taken" withType:ERROR];
                }
                else
                {
                    self.userData.validUsername = YES;
                    [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
                    cell.btnShowPassword.hidden = NO;
                    self.userData.username = textField.text;
                }
            }];
            return YES;
            
        }];
        return cell;
        
        
    }
    if (indexPath.section==2) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextField" forIndexPath:indexPath];
        
        cell.txtInput1.placeholder = @"Password";
        cell.txtInput1.autocapitalizationType = UITextAutocapitalizationTypeWords;
        cell.btnShowPassword.hidden = NO;
        cell.activityCell.hidden = YES;
        cell.txtInput1.secureTextEntry = YES;
        [cell.btnShowPassword addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnShowPassword.tag = 0;
        [cell.txtInput1 setBk_didEndEditingBlock:^(UITextField *textField) {
            self.userData.password = textField.text;
        }];
        return cell;
    }
    if (indexPath.section==3) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
        return cell;
    }

    if (indexPath.section==4) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conditionCell" forIndexPath:indexPath];
        cell.btnAction.tag = 2;
        [cell createLink];
        cell.lblTitle.delegate = self;
        [cell.btnAction addTarget:self action:@selector(btnTermsAndConditions:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (indexPath.section==5) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        [cell.btnAction addTarget:self action:@selector(btnSignUp:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnAction setTitle:@"SignUp" forState:UIControlStateNormal];
        return cell;
    }
    if (indexPath.section==6) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seperatorCell" forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.section==7) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        [cell.btnAction addTarget:self action:@selector(btnSignUpFacebook:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.btnAction setTitle:@"Facebook" forState:UIControlStateNormal];
        return cell;
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==5) {
        return 10.0f;
    }
    if (section==7) {
        return 20.0f;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 20.0;
    }
    if (section==5) {
        return 10.0f;
    }
    if (section==7) {
        return 20.0f;
    }
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    TermsViewController* vc = [[TermsViewController alloc] initWithNibName:@"TermsViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.'
     if ([segue.identifier isEqualToString:@"email_verifi"]) {
         EmailVerificationController* vc = segue.destinationViewController;
         vc.userData = sender;
     }
 }
 
@end
