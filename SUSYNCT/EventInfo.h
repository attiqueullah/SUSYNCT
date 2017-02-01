//
//  EventInfo.h
//  SUSYNCT
//
//  Created by Attique Ullah on 01/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManger.h"

@class TermsInfo;
@class SubCourseInfo;
@class DepartmentInfo;

@interface EventInfo : NSObject
@property(nonatomic,strong)TermsInfo* term;
@property(nonatomic,strong)SubCourseInfo* course;
@property(nonatomic,strong)DepartmentInfo* department;
@property(nonatomic,assign)EventType type;
@property(nonatomic,assign)Status status;
@property(nonatomic,strong)NSArray* attendies;
@end
