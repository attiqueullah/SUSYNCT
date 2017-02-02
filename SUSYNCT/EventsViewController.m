//
//  EventsViewController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 28/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "EventsViewController.h"

@interface EventsViewController ()
@property (weak, nonatomic) IBOutlet UIView *dayViewContainer;
@property (weak, nonatomic) IBOutlet UIView *weekViewContainer;
@property (weak, nonatomic) IBOutlet UIView *monthViewContainer;
@property(nonatomic,strong)NSMutableArray* friendsArr;
@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dayViewContainer.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)goToEventDetail
{
    [self performSegueWithIdentifier:@"event_detail" sender:self];
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
