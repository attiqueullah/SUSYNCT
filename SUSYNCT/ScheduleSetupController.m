//
//  ScheduleSetupController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 13/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "ScheduleSetupController.h"
#import "LabelCollectionCell.h"
#import "NewScheduleControllerViewController.h"

@interface ScheduleSetupController ()

@property (weak, nonatomic) IBOutlet UICollectionView *dayCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *termCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *coursesCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *courseCollectionView;
@property(nonatomic,strong)NSArray* currentTerms;
@property(nonatomic,strong)NSMutableArray* termsArr;
@property(nonatomic,strong)NSMutableArray* departments;
@property(nonatomic,strong)NSArray* filterDepartments;
@property(nonatomic,strong)NSArray* filterCourses;
@property(nonatomic,strong)NSArray* semesterTerms;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *txtSemesterTerms;
@property(nonatomic)NSUInteger indSemesterIndex;
@property (weak, nonatomic) IBOutlet UISearchBar *courseSearch;
@property (weak, nonatomic) IBOutlet UISearchBar *departmentSearch;
@property (weak, nonatomic) IBOutlet UITableView *tblDepartments;
@property(nonatomic,strong)NSString* session;
@property(nonatomic,strong)NSMutableArray* coursesArr;
@property(nonatomic,strong)TermsInfo* termSelected;
@property(nonatomic,strong)NSArray* subCoursesSection;
@property(nonatomic,strong)NSMutableArray* weekDays;
@property (weak, nonatomic) IBOutlet UIView *departmentView;
@property(nonatomic,strong)NSMutableArray* selWeekDays;
@property(nonatomic,strong)EventInfo* event;
@end


@implementation ScheduleSetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.termsArr = [NSMutableArray new];
    self.departments = [NSMutableArray new];
    self.selWeekDays = [NSMutableArray new];
    self.event = [EventInfo new];
    self.indSemesterIndex = 1;
    [self.tblDepartments setHidden:YES];
    self.departmentView.hidden = YES;
   // self.departmentCollectionView.layer.borderColor =[UIColor blackColor].CGColor;
   // self.departmentCollectionView.layer.borderWidth = 2.0;
    [self getWeekDays];
    [self getTerms];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"new_schedule"]) {
        NewScheduleControllerViewController*vc = segue.destinationViewController;
        vc.str_title = @"Setup Class";
        self.event.term = self.termSelected;
        self.event.course = sender;
        self.event.type = Course;
        vc.event = self.event;
    }
}

#pragma mark Get Week Days
-(void)getWeekDays
{
    self.weekDays = [NSMutableArray new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.weekDays = [[dateFormatter veryShortWeekdaySymbols] mutableCopy];
    [self.weekDays removeObjectAtIndex:0];
    [self.weekDays removeLastObject];
     self.selWeekDays = [NSMutableArray arrayWithArray:self.weekDays];
}
#pragma mark WEBAPI CALLS
-(void)getTerms
{
    [DATAMANAGER getTermsWithCompletionBlock:^(NSArray* terms, NSError* error){
        self.currentTerms = terms;
        for (NSString* term in terms) {
            TermsInfo* trm = [TermsInfo new];
            NSString* season = [term substringFromIndex:[term length] - 1];
            if ([season isEqualToString:@"1"]) {
                trm.term = term;
                trm.season = @"Spring";
            }
            else if ([season isEqualToString:@"2"]) {
                trm.term = term;
                trm.season = @"Summer";
            }
            else if ([season isEqualToString:@"3"]) {
                trm.term = term;
                trm.season = @"Fall";
            }
            [self.termsArr addObject:trm ];
        }
        [self.termCollectionView reloadData];
        [self getDepartments:self.termsArr[0]];
        
    }];

}
-(void)getDepartments:(TermsInfo*)terminfo
{
    self.termSelected = terminfo;
    [DATAMANAGER getDepartmentsWithId:terminfo.term WithCompletionBlock:^(NSArray* deparments , NSError* error){
        [self.departments removeAllObjects];
        self.departments = [deparments mutableCopy];

    }];
    
}
-(void)getClasses:(DepartmentInfo*)dep
{
    self.event.department = dep;
    NSString* classe = [NSString stringWithFormat:@"%@/%@",dep.department_code,self.termSelected.term];
    [DATAMANAGER getClassesWithId:classe WithCompletionBlock:^(NSArray* courses , NSError* error){
        if (courses.count>0) {
            self.departmentView.hidden = false;
        }
        self.coursesArr = [courses mutableCopy];
        [self.coursesCollection reloadData];
    }];
}

#pragma mark CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == self.courseCollectionView)
    {
        return self.filterCourses.count;
    }
    if(collectionView == self.dayCollectionView)
    {
        return self.weekDays.count;
    }
    return self.coursesArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView == self.courseCollectionView)
    {
        LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LabelCollectionCell4" forIndexPath:indexPath];
        
        SubCourseInfo* info = self.filterCourses[indexPath.row];
        if (self.filterCourses==nil) {
            info = self.subCoursesSection[indexPath.row];
        }
        cell.lblInput2.text = info.title;
        cell.lblInput3.text = [NSString stringWithFormat:@"%@",info.day];
        cell.lblInput4.text = [NSString stringWithFormat:@"%@-%@",info.start_time,info.end_time];
        return cell;
    }
    else if(collectionView == self.dayCollectionView)
    {
        LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCollectionCell" forIndexPath:indexPath];
        cell.lblInput2.text = self.weekDays[indexPath.row];
        cell.lblInput2.layer.borderColor = [UIColor blackColor].CGColor;
        cell.lblInput2.layer.borderWidth = 1.0;
        cell.lblInput2.backgroundColor = [UIColor blackColor];
        cell.lblInput2.textColor = [UIColor whiteColor];

        return cell;
    }
    else
    {
        LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LabelCollectionCell3" forIndexPath:indexPath];
        CourseInfo* info = self.coursesArr[indexPath.row];
        cell.lblInput1.text = info.scheduledCourseId;
        if (indexPath.row==0) {
            cell.lblInput1.backgroundColor = [UIColor blackColor];
            cell.lblInput1.textColor = [UIColor whiteColor];
            [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        else
        {
            cell.lblInput1.backgroundColor = [UIColor clearColor];
            cell.lblInput1.textColor = [UIColor blackColor];

        }
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(collectionView == self.courseCollectionView)
    {
        [self performSegueWithIdentifier:@"new_schedule" sender:self.filterCourses[indexPath.row]];
    }
    else if(collectionView == self.dayCollectionView)
    {
        LabelCollectionCell *cell = (LabelCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if ([self.selWeekDays containsObject:self.weekDays[indexPath.row]]) {
            [self.selWeekDays removeObject:self.weekDays[indexPath.row]];
            cell.lblInput2.backgroundColor = [UIColor whiteColor];
            cell.lblInput2.textColor = [UIColor blackColor];
        }
        else
        {
            [self.selWeekDays addObject:self.weekDays[indexPath.row]];
            cell.lblInput2.backgroundColor = [UIColor blackColor];
            cell.lblInput2.textColor = [UIColor whiteColor];
        }
        
        [self filterCourses:self.courseSearch.text];
    }
    else
    {
        CourseInfo* info = self.coursesArr[indexPath.row];
        LabelCollectionCell *cell = (LabelCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.lblInput1.backgroundColor = [UIColor blackColor];
        cell.lblInput1.textColor = [UIColor whiteColor];
        self.subCoursesSection = info.sectionData;
        self.filterCourses = info.sectionData;
        [self.courseCollectionView reloadData];
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == self.courseCollectionView)
    {
        
    }
    else if(collectionView == self.dayCollectionView)
    {
       
    }
    else
    {
        LabelCollectionCell *cell = (LabelCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.lblInput1.backgroundColor = [UIColor clearColor];
        cell.lblInput1.textColor = [UIColor blackColor];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == self.courseCollectionView)
    {
        return CGSizeMake(160,76);
    }
    if(collectionView == self.dayCollectionView)
    {
        return CGSizeMake(40,40);
    }

    return CGSizeMake(100, 40);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.termCollectionView) {
         return self.termsArr.count;
    }
    return self.filterDepartments.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.termCollectionView) {
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TermsCell" forIndexPath:indexPath];
        TermsInfo* trm = self.termsArr[indexPath.row];;
        cell.lblNTitle.text = trm.season;
        if (indexPath.row==0) {
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK colors:@[[UIColor blackColor]]];
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        }
        return cell;
    }
    else
    {
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentCell" forIndexPath:indexPath];
        DepartmentInfo* trm = self.filterDepartments[indexPath.row];;
        cell.lblNTitle.text = trm.department_name;
        return cell;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.termCollectionView) {
        LeftTableViewCell *cell = (LeftTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK colors:@[[UIColor blackColor]]];
        TermsInfo* trm = self.termsArr[indexPath.row];
        self.departmentView.hidden = true;
        self.departmentSearch.text = @"";
        [self getDepartments:trm];
    }
    else
    {
        DepartmentInfo* trm = self.filterDepartments[indexPath.row];
        [self.departmentSearch endEditing:YES];
        [self.tblDepartments setHidden:YES];
        self.departmentSearch.text = trm.department_name;
        [self getClasses:trm];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTableViewCell *cell = (LeftTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = nil;
}

#pragma mark UISearchbar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar == self.departmentSearch) {
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(SELF.department_name CONTAINS[cd] %@) OR (SELF.department_code CONTAINS[cd] %@) ", searchText,searchText];
        NSArray *filteredArray = [self.departments filteredArrayUsingPredicate:namePredicate];
        self.filterDepartments = filteredArray;
        if (filteredArray.count>0) {
            [UIView animateWithDuration:3.0f animations:^{
                [self.tblDepartments setHidden:NO];
            }];
            
        }
        [self.tblDepartments reloadData];
    }
    else
    {
        [self filterCourses:searchText];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == self.departmentSearch) {
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(SELF.department_name CONTAINS[cd] %@) OR (SELF.department_code CONTAINS[cd] %@) ", searchBar.text,searchBar.text];
        NSArray *filteredArray = [self.departments filteredArrayUsingPredicate:namePredicate];
        self.filterDepartments = filteredArray;
        if (filteredArray.count>0) {
            [self.tblDepartments setHidden:NO];
        }
        [self.tblDepartments reloadData];
    }
    else
    {
        [self filterCourses:searchBar.text];
    }
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.tblDepartments setHidden:YES];
}

-(void)filterCourses:(NSString*)searchText
{
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(SELF.title CONTAINS[cd] %@) OR (SELF.dclass_code CONTAINS[cd] %@) ", searchText,searchText];
    NSArray *filteredArray = [self.subCoursesSection filteredArrayUsingPredicate:namePredicate];
    
    NSMutableArray* arrPredicates = [NSMutableArray new];
    
    for (NSString* strDay in self.selWeekDays) {
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(SELF.day CONTAINS[cd] %@)", strDay];
        [arrPredicates addObject:namePredicate];
    }
    NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:arrPredicates];
    NSArray *filteredDayArray = [searchText.length>0?filteredArray:self.subCoursesSection filteredArrayUsingPredicate:predicate ];
    
    self.filterCourses = filteredDayArray;
    [self.courseCollectionView reloadData];
}
@end
