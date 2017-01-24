//
//  DataManger.m
//  SUSYNCT
//
//  Created by Attique Ullah on 09/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "DataManger.h"
#import "Reachability.h"

@interface DataManger ()
@end

@implementation DataManger

#pragma mark - ShareInstance Method Implementation
+(id)sharedInstance
{
    static DataManger *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[DataManger alloc] init];
    });
    return _sharedManager;
}
- (id)init
{
    if ((self = [super init])) {
        
    }
    return self;
}

#pragma mark GET Terms Service
-(void)getTermsWithCompletionBlock:(void (^)(NSArray*, NSError *))completionBlock
{
    
    [API requestWithMethod:@"GET" path:TERMS parameters:nil withCompletionBlock:^(NSURLSessionTask* task, NSDictionary* responseObject){
        if (responseObject) {
            completionBlock(responseObject[@"term"],nil);
        }
        
    }andFailureBlock:^(NSURLSessionTask *task, NSError *error){
        
    }];
}
#pragma mark GET Departmetns Service
-(void)getDepartmentsWithId:(NSString*)sessionId WithCompletionBlock:(void (^)(NSArray*, NSError *))completionBlock
{
    
    [API requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@/%@",DEPARTMENTS,sessionId] parameters:nil withCompletionBlock:^(NSURLSessionTask* task, NSDictionary* responseObject){
        NSMutableArray* departments = [NSMutableArray new];
        if (responseObject) {
        
            
            NSArray* array = responseObject[@"department"];
            for (NSDictionary* dic in array) {
                DepartmentInfo* dep = [DepartmentInfo new];
                dep.department_name = dic[@"name"];
                dep.department_type = dic[@"type"];
                dep.department_code = dic[@"code"];
                [departments addObject:dep];
            }
            completionBlock(departments,nil);
        }
        else
        {
            completionBlock(departments,nil);
        }
        
    }andFailureBlock:^(NSURLSessionTask *task, NSError *error){
        
    }];
}
#pragma mark GET CLASSES Service
-(void)getClassesWithId:(NSString*)Id WithCompletionBlock:(void (^)(NSArray*, NSError *))completionBlock
{
    
    [API requestWithMethod:@"GET" path:@"classes/phys/20143" parameters:nil withCompletionBlock:^(NSURLSessionTask* task, NSDictionary* responseObject){
        NSMutableArray* courses = [NSMutableArray new];
        if (responseObject) {
            
            
            NSArray* array = responseObject[@"OfferedCourses"][@"course"];
            for (NSDictionary* dic in array) {
                CourseInfo* course = [CourseInfo new];
                course.courseData = dic[@"CourseData"];
                course.scheduledCourseId = dic[@"ScheduledCourseID"];
                course.isCrossListed = dic[@"IsCrossListed"];
                course.publishedCourseId = dic[@"PublishedCourseID"];
                NSMutableArray* sections = [NSMutableArray new];
                id courseData  = course.courseData[@"SectionData"];
                if ([courseData isKindOfClass:[NSArray class]]) {
                    for (NSDictionary* subDic in course.courseData[@"SectionData"]) {
                        SubCourseInfo* subInfo = [SubCourseInfo new];
                        subInfo.courseData = course.courseData;
                        subInfo.dclass_code = subDic[@"dclass_code"];
                        subInfo.location = subDic[@"location"];
                        subInfo.title = subDic[@"title"];
                        subInfo.number_registered = subDic[@"number_registered"];
                        subInfo.day = subDic[@"day"];
                        subInfo.blackboard = subDic[@"blackboard"];
                        subInfo.type = subDic[@"type"];
                        subInfo.wait_qty = subDic[@"wait_qty"];
                        subInfo.session = subDic[@"session"];
                        subInfo.subCourse_id = subDic[@"id"];
                        subInfo.units = subDic[@"units"];
                        subInfo.instructor = subDic[@"instructor"];
                        subInfo.syllabus = subDic[@"syllabus"];
                        subInfo.isDistanceLearning = subDic[@"isDistanceLearning"];
                        subInfo.start_time = subDic[@"start_time"];
                        subInfo.notes = subDic[@"notes"];
                        subInfo.spaces_available = subDic[@"spaces_available"];
                        subInfo.section_title = subDic[@"section_title"];
                        subInfo.canceled = subDic[@"canceled"];
                        subInfo.comment = subDic[@"comment"];
                        subInfo.end_time = subDic[@"end_time"];
                        subInfo.course_description = subDic[@"description"];
                        
                        [sections addObject:subInfo];
                    }
                }
                else
                {
                    NSDictionary* subDic = courseData;
                    SubCourseInfo* subInfo = [SubCourseInfo new];
                    subInfo.courseData = course.courseData;
                    subInfo.dclass_code = subDic[@"dclass_code"];
                    subInfo.location = subDic[@"location"];
                    subInfo.title = subDic[@"title"];
                    subInfo.number_registered = subDic[@"number_registered"];
                    subInfo.day = subDic[@"day"];
                    subInfo.blackboard = subDic[@"blackboard"];
                    subInfo.type = subDic[@"type"];
                    subInfo.wait_qty = subDic[@"wait_qty"];
                    subInfo.session = subDic[@"session"];
                    subInfo.subCourse_id = subDic[@"id"];
                    subInfo.units = subDic[@"units"];
                    subInfo.instructor = subDic[@"instructor"];
                    subInfo.syllabus = subDic[@"syllabus"];
                    subInfo.isDistanceLearning = subDic[@"isDistanceLearning"];
                    subInfo.start_time = subDic[@"start_time"];
                    subInfo.notes = subDic[@"notes"];
                    subInfo.spaces_available = subDic[@"spaces_available"];
                    subInfo.section_title = subDic[@"section_title"];
                    subInfo.canceled = subDic[@"canceled"];
                    subInfo.comment = subDic[@"comment"];
                    subInfo.end_time = subDic[@"end_time"];
                    subInfo.course_description = subDic[@"description"];
                    
                    [sections addObject:subInfo];

                }
                
                course.sectionData = sections;
                [courses addObject:course];
            }
            completionBlock(courses,nil);
        }
        else
        {
            completionBlock(courses,nil);
        }
        
    }andFailureBlock:^(NSURLSessionTask *task, NSError *error){
        
    }];
}

#pragma mark SVProgressHud
-(void)showWithStatus:(NSString*)text withType:(ProgressHUDType)type
{
    if (type == STATUS) {
         [SVProgressHUD showWithStatus:text];
    }
   else if (type == ERROR)
   {
       [SVProgressHUD showErrorWithStatus:text];
   }
   else if (type == SUCESS)
   {
       [SVProgressHUD showSuccessWithStatus:text];
   }
   else if (type == INFO)
   {
       [SVProgressHUD showInfoWithStatus:text];
   }
}
#pragma mak Custom Methods
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
#pragma mark Check Internet Availability
-(void)checkInterneConnectivitywithCompletionBlock:(void(^)( BOOL connect))completionBlock
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == NotReachable) {
        completionBlock(NO);
    }
    else if (status == ReachableViaWiFi) {
        completionBlock(YES);
    }
    else{
        completionBlock(YES);
    }
}

@end
