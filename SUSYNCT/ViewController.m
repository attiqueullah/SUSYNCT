//
//  ViewController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 08/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "ViewController.h"
#import "TextFieldCell.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblSignIn;
@property (nonatomic,strong)UserInfo* userData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userData = [[UserInfo alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
    }
    else
    {
        cell.btnShowPassword.tag = 0;
        [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    }
}
-(void)btnSignIn:(UIButton*)sender
{
    [self hideKeyboard];
    [NSUserDefaults saveObject:[NSDate date] forKey:@"loginDate"];
    [AppDelegateAccessor goToDashboard:self];
    /*if (self.userData.username.length==0 ) {
        [DATAMANAGER showWithStatus:@"Please Enter UserName" withType:ERROR];
        return;
    }
    if (self.userData.password.length==0) {
        [DATAMANAGER showWithStatus:@"Please Enter Password" withType:ERROR];
        return;
        
    }

    [PARSEMANAGER signinWithUsername:self.userData.username andPassword:self.userData.password inController:self withCompletionBlock:^(PFUser*user, BOOL success,NSError* error){
        if (!error) {
            [NSUserDefaults saveObject:[NSDate date] forKey:@"loginDate"];
            [AppDelegateAccessor goToDashboard:self];
        }
    }];*/

}
-(void)btnSignUp:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"register" sender:self];
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
-(void)btnForgotPassword:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"forgot_password" sender:self];
}
-(void)btnSignUpGoogle:(UIButton*)sender
{
}
-(void)btnSignUpTwitter:(UIButton*)sender
{
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    
    if (indexPath.section==0) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextField" forIndexPath:indexPath];
        
        cell.txtInput1.placeholder = @"Username/User ID";
        cell.btnShowPassword.hidden = YES;
        [cell.txtInput1 setBk_didEndEditingBlock:^(UITextField *textField) {
            self.userData.username = textField.text;
        }];

        return cell;
        
    }
    if (indexPath.section==1) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextField" forIndexPath:indexPath];
        
        cell.txtInput1.placeholder = @"Password";
        cell.txtInput1.autocapitalizationType = UITextAutocapitalizationTypeWords;
        cell.btnShowPassword.hidden = NO;
        cell.txtInput1.secureTextEntry = YES;
        [cell.btnShowPassword addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnShowPassword.tag = 0;
        [cell.txtInput1 setBk_didEndEditingBlock:^(UITextField *textField) {
            self.userData.password = textField.text;
        }];
        return cell;
        
    }
    if (indexPath.section==2) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        [cell.btnAction addTarget:self action:@selector(btnSignIn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnAction setTitle:@"SignIn" forState:UIControlStateNormal];
        return cell;

        
    }
    if (indexPath.section==3) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        [cell.btnAction addTarget:self action:@selector(btnSignUp:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnAction setTitle:@"SignUp" forState:UIControlStateNormal];
        return cell;
        
        
    }
    if (indexPath.section==4) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        [cell.btnAction addTarget:self action:@selector(btnForgotPassword:) forControlEvents:UIControlEventTouchUpInside];
        cell.txtInput1.hidden = YES;
        [cell.btnAction setTitle:@"Forgot Password" forState:UIControlStateNormal];
        return cell;
        
        
    }
    if (indexPath.section==5) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seperatorCell" forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.section==6) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        [cell.btnAction addTarget:self action:@selector(btnSignUpFacebook:) forControlEvents:UIControlEventTouchUpInside];

        [cell.btnAction setTitle:@"Facebook" forState:UIControlStateNormal];
        return cell;
        
        
    }
    if (indexPath.section==7) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        [cell.btnAction addTarget:self action:@selector(btnSignUpGoogle:) forControlEvents:UIControlEventTouchUpInside];

        [cell.btnAction setTitle:@"Google" forState:UIControlStateNormal];
        return cell;
        
        
    }
    if (indexPath.section==8) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        [cell.btnAction addTarget:self action:@selector(btnSignUpTwitter:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnAction setTitle:@"Twitter" forState:UIControlStateNormal];
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
    if (section==1) {
        return 20.0;
    }
    if (section==5) {
        return 20.0f;
    }
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
@end
