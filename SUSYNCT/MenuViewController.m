//
//  MenuViewController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 20/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "MenuViewController.h"

#import "ViewController.h"


@interface MenuViewController ()
{
    NSInteger _presentedRow;
    NSInteger _presentedSection;
    NSInteger selectedMenu;
    BOOL isSelected;
}
@property (weak, nonatomic) IBOutlet UITableView *tblData;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _presentedSection = 0;
    _presentedRow = 0;
    selectedMenu = 3;
    self.tblData.tableFooterView = [UIView new];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark GO TO CALENDAR SETUP
-(void)goToCalendarSetup:(LeftTableViewCell*)cell
{
    NSMutableArray* arr = [NSMutableArray new];
    for (int i=1; i<=3; i++) {
        [arr addObject:[NSIndexPath indexPathForRow:i inSection:1]];
    }
    [self.tblData beginUpdates];
    if (isSelected) {
         selectedMenu = 3;
         isSelected= NO;
         cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
         [self.tblData deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
         selectedMenu = 0;
         isSelected= YES;
         cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_UNFOLD_INDICATOR colors:@[[UIColor whiteColor]]];
         [self.tblData insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationBottom];
    }
    [self.tblData endUpdates];
}
#pragma mark GO TO Class
-(void)goToClass
{
    UINavigationController *frontViewController = [STUDENT instantiateViewControllerWithIdentifier:NAV_MAIN];
    [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
#pragma mark GO TO FRIENDS
-(void)goToFriends
{
    FriendsViewController *frontViewController = [FRIENDS instantiateViewControllerWithIdentifier:NAV_FRIENDS];
     [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
     [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
#pragma mark GO TO EVENTS
-(void)goToEvents
{
    EventsViewController *frontViewController = [EVENTS instantiateViewControllerWithIdentifier:NAV_EVENTS];
    [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
#pragma mark GO TO GROUPS
-(void)goToGroups
{
        GroupsViewController *frontViewController = [GROUPS instantiateViewControllerWithIdentifier:NAV_GROUPS];
        [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
#pragma mark GO TO NOTIFICATIONS
-(void)goToNotifications
{
        NotificationsViewController *frontViewController = [NOTIFI instantiateViewControllerWithIdentifier:NAV_NOTIFI];
        [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
#pragma mark GO TO SETTINGS
-(void)goToSettings
    {
        SettingsViewController *frontViewController = [SETTINGS instantiateViewControllerWithIdentifier:NAV_SETTINGS];
        [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
#pragma mark GO TO HELP
-(void)goToHelp
    {
        HelpViewController *frontViewController = [HELP instantiateViewControllerWithIdentifier:NAV_HELP];
        [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
#pragma mark GO TO ABOUT
-(void)goToAbout
    {
        AboutViewController *frontViewController = [ABOUT instantiateViewControllerWithIdentifier:NAV_ABOUT];
        [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
#pragma mark GO TO LOGOUT
-(void)goToLogout
    {
        ViewController *frontViewController = [MAIN instantiateViewControllerWithIdentifier:NAV_LOGIN];
        [[UIApplication sharedApplication] keyWindow].rootViewController = frontViewController;
    }
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60.0f;
    }
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return CGFLOAT_MIN;
    }
    else if( section == 2  )
        return 40.0f;
    else
        return CGFLOAT_MIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 8-selectedMenu;
    }
    if (section == 2) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftCell";
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.lblNTitle.text = @"Calendar Setup";
            [cell configureCell:[UIColor whiteColor]];
            cell.backgroundColor = [UIColor blackColor];
            
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
            return cell;
        }
        else if (indexPath.row==(1-selectedMenu) && isSelected == YES)
        {
            static NSString *SubCellIdentifier = @"SubLeftCell";
            LeftTableViewCell *subCell = [tableView dequeueReusableCellWithIdentifier:SubCellIdentifier];
            subCell.lblNTitle.text = @"Sync Calendar";
            [subCell configureCell:[UIColor whiteColor]];
            subCell.backgroundColor = RGB(0,89,168);
            subCell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return subCell;
            
        }
        else if (indexPath.row==(2-selectedMenu) && isSelected == YES)
        {
            static NSString *SubCellIdentifier = @"SubLeftCell";
            LeftTableViewCell *subCell = [tableView dequeueReusableCellWithIdentifier:SubCellIdentifier];
            subCell.lblNTitle.text = @"Class";
            [subCell configureCell:[UIColor whiteColor]];
            subCell.backgroundColor = RGB(0,89,168);
            subCell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return subCell;
            
        }
        else if (indexPath.row==(3-selectedMenu) && isSelected == YES)
        {
            static NSString *SubCellIdentifier = @"SubLeftCell";
            LeftTableViewCell *subCell = [tableView dequeueReusableCellWithIdentifier:SubCellIdentifier];
            subCell.lblNTitle.text = @"Other";
            [subCell configureCell:[UIColor whiteColor]];
            subCell.backgroundColor = RGB(0,89,168);
            subCell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return subCell;
            
        }
        else if (indexPath.row==(4-selectedMenu))
        {
            cell.lblNTitle.text = @"Friends";
            [cell configureCell:[UIColor whiteColor]];
            cell.backgroundColor = RGB(0,89,168);
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            
            return cell;
            
        }
        else if (indexPath.row==(5-selectedMenu))
        {
            cell.lblNTitle.text = @"Events";
            [cell configureCell:[UIColor whiteColor]];
            cell.backgroundColor = RGB(0,89,168);
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            
            return cell;
            
            
        }
        else if (indexPath.row==(6-selectedMenu))
        {
            cell.lblNTitle.text = @"Groups";
            
            [cell configureCell:[UIColor whiteColor]];
            
            cell.backgroundColor = RGB(0,89,168);
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return cell;
            
            
        }
        
        else if (indexPath.row==(7-selectedMenu))
        {
            cell.lblNTitle.text = @"Notifications";
            
            [cell configureCell:[UIColor whiteColor]];
            
            cell.backgroundColor = RGB(0,89,168);
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return cell;

            
        }
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row==0) {
            cell.lblNTitle.text = @"Settings";
            [cell configureCell:[UIColor whiteColor]];
            cell.backgroundColor = RGB(0,89,168);
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return cell;
            
        }
        else if (indexPath.row==1)
        {
            cell.lblNTitle.text = @"Help";
            [cell configureCell:[UIColor whiteColor]];
            cell.backgroundColor =RGB(0,89,168);
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return cell;
            
        }
        else if (indexPath.row==2)
        {
            cell.lblNTitle.text = @"About";
            [cell configureCell:[UIColor whiteColor]];
            cell.backgroundColor = RGB(0,89,168);
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return cell;
            
        }
        
        else if (indexPath.row==3)
        {
            cell.lblNTitle.text = @"Logout";
            [cell configureCell:[UIColor whiteColor]];
            cell.backgroundColor = RGB(0,89,168);
            
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return cell;
        }
        
    }
    else
    {
       // PFUser *currentUser = [PFUser currentUser];
        cell.lblNTitle.text = @"JOHN WHITE";
        cell.lblNTitle.textColor = [UIColor whiteColor];
        //cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
        cell.lblNTitle.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:20.0];
        return cell;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView * headerview = (UITableViewHeaderFooterView *)view;
    
    headerview.contentView.backgroundColor = RGB(0, 89, 168);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    
    if ((indexPath.section == _presentedSection && indexPath.row == _presentedRow) && (indexPath.section!=1 && indexPath.row!=0))
    {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    LeftTableViewCell *cell = (LeftTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];

    if (indexPath.section==1) {
        if (indexPath.row==0) {
            [self goToCalendarSetup:cell];
        }
        if (indexPath.row==(1-selectedMenu)) {
            ///Go to Cync Calendar ///
            
        }
        if (indexPath.row==(2-selectedMenu)) {
            ///Go to Class ///
            [self goToClass];

        }
        if (indexPath.row==(3-selectedMenu)) {
            ///Go to Others ///
            
        }
        if (indexPath.row==(4-selectedMenu)) {
            ///Go to Friends ///
            [self goToFriends];
        }
        if (indexPath.row==(5-selectedMenu)) {
           ///Go to Events ///
            [self goToEvents];
        }
        if (indexPath.row==(6-selectedMenu)) {
           ///Go to Groups ///
            [self goToGroups];
        }
        if (indexPath.row==(7-selectedMenu)) {
           ///Go to Notifications ///
            [self goToNotifications];
        }
    }
    else
    {
        if (indexPath.row==0) {
            [self goToSettings];
        }
        if (indexPath.row==1) {
            [self goToHelp];
        }
        if (indexPath.row==2) {
            [self goToAbout];
        }
        if (indexPath.row==3) {
            ///// LOGOUT /////
            [self goToLogout];
        }
    }
    _presentedRow = indexPath.row;
    _presentedSection = indexPath.section;
    
    if (indexPath.row!=0 && selectedMenu !=3) {
        
        NSMutableArray* arr = [NSMutableArray new];
        for (int i=1; i<=3; i++) {
            [arr addObject:[NSIndexPath indexPathForRow:i inSection:1]];
        }
        [self.tblData beginUpdates];
        selectedMenu = 3;
        isSelected= NO;
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
        [self.tblData deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
        [self.tblData endUpdates];

    }
   
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTableViewCell *cell = (LeftTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = RGB(0, 89, 168);
}
@end
