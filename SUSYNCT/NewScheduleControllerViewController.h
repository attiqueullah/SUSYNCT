//
//  NewScheduleControllerViewController.h
//  SUSYNCT
//
//  Created by Attique Ullah on 28/01/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "BaseViewController.h"
#import "SubCourseInfo.h"

@interface NewScheduleControllerViewController : BaseViewController
@property(nonatomic,strong)NSString* str_title;
@property(nonatomic,strong)SubCourseInfo* course;
@end
