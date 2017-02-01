//
//  NewScheduleControllerViewController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 28/01/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "NewScheduleControllerViewController.h"

@interface NewScheduleControllerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtStartDate;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *txtStartTime;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *txtEndTime;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;

@end

@implementation NewScheduleControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.str_title;
    [self configureView];
    [self loadCourseDetails];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ConfigureView
-(void)configureView
{
    self.txtStartTime.dropDownMode = IQDropDownModeTimePicker;
    self.txtEndTime.dropDownMode = IQDropDownModeTimePicker;
}

#pragma mark Load Course Details
-(void)loadCourseDetails
{
    self.txtName.text = self.event.course.title;
    self.txtStartDate.text = self.event.course.day;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate * startTimeFormatted = [dateFormatter dateFromString:self.event.course.start_time];
     NSDate * endTimeFormatted = [dateFormatter dateFromString:self.event.course.end_time];
    [self.txtStartTime setDate:startTimeFormatted animated:YES];
    [self.txtEndTime   setDate:endTimeFormatted animated:YES];
    self.txtLocation.text = self.event.course.location;
    
    [self isEnableCourseDetails:YES];
    
}
#pragma mark Disable Course Details
-(void)isEnableCourseDetails:(BOOL)enabled
{
    self.txtName.userInteractionEnabled = enabled;
    self.txtStartDate.userInteractionEnabled = enabled;
    self.txtStartTime.userInteractionEnabled = enabled;
    self.txtEndTime.userInteractionEnabled = enabled;
}
#pragma mark IBActions
- (IBAction)btnSavePressed:(id)sender {
    PFObject* eventClass = [PFObject objectWithClassName:PARSE_EVENTS];
    
    //[eventClass setObject:PARSE_USER forKey:@"user"];
    [eventClass setObject:self.event.course.title forKey:@"name"];
    [eventClass setObject:self.event.course.start_time forKey:@"startTime"];
    [eventClass setObject:self.event.course.location forKey:@"location"];
    [eventClass setObject:self.event.course.day forKey:@"day"];
    [eventClass setObject:[NSNumber numberWithInteger:self.event.type] forKey:@"type"];
    [eventClass setObject:self.event.course.end_time forKey:@"end_time"];
    [eventClass setObject:self.event.department.depDic forKey:@"department"];
    [eventClass setObject:self.event.course.subCourseDic forKey:@"subCourse"];
    [eventClass setObject:self.event.term.term forKey:@"term"];
    
    [PARSEMANAGER saveParseDataWithObject:eventClass WithAcknowledgment:YES inController:self withCompletionBlock:^(BOOL success, NSError* error){
        
    }];
    
}
- (IBAction)btnCancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
