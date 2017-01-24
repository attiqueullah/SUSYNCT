//
//  ScheduleSetupController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 13/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "ScheduleSetupController.h"
#import "LabelCollectionCell.h"
#import "NewClassController.h"
@interface ScheduleSetupController ()
@property (weak, nonatomic) IBOutlet UICollectionView *termCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *departmentCollectionView;
@property(nonatomic,strong)NSArray* currentTerms;
@property(nonatomic,strong)NSMutableArray* termsArr;
@property(nonatomic,strong)NSMutableArray* departments;
@property(nonatomic,strong)NSArray* semesterTerms;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *txtSemesterTerms;
@property(nonatomic)NSUInteger indSemesterIndex;
@property(nonatomic,strong)NSString* session;
@end

@implementation ScheduleSetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.termsArr = [NSMutableArray new];
    self.departments = [NSMutableArray new];
    self.indSemesterIndex = 1;
    [DATAMANAGER getTermsWithCompletionBlock:^(NSArray* terms, NSError* error){
        self.currentTerms = terms;
        
        NSUInteger currentYear = [[NSDate date] year];   /////2016
        NSUInteger lastYear = 2011;
        NSUInteger dist = (currentYear - lastYear)+1;
        for (int i = 0; i<=dist; i++) {
            
            NSUInteger cYear = lastYear+i;
            if (cYear < currentYear) {
                [self.termsArr addObject:[NSString stringWithFormat:@"%d",(int)lastYear+i]];
            }
            else
            {
                for (NSString* str in self.currentTerms) {
                    NSString* years = [str substringToIndex:4];
                    if (years.integerValue == cYear) {
                        [self.termsArr addObject:[NSString stringWithFormat:@"%d",(int)cYear]];
                        break;
                    }
                }
            }
            
            
        }
        [self.termCollectionView reloadData];
        
    }];
    self.txtSemesterTerms.isOptionalDropDown = NO;
    self.semesterTerms = @[@"Fall",@"Spring",@"Summer"];
    [self.txtSemesterTerms setItemList:self.semesterTerms];
    
    self.departmentCollectionView.layer.borderColor =[UIColor blackColor].CGColor;
    self.departmentCollectionView.layer.borderWidth = 2.0;
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
    if ([segue.identifier isEqualToString:@"classSetup"]) {
        NewClassController* vc = segue.destinationViewController;
        vc.depID = sender;
    }
}

#pragma mark WEBAPI CALLS
-(void)getDepartments
{
    [DATAMANAGER getDepartmentsWithId:[NSString stringWithFormat:@"%@%d",self.session,(int)self.indSemesterIndex] WithCompletionBlock:^(NSArray* deparments , NSError* error){
        [self.departments removeAllObjects];
        self.departments = [deparments mutableCopy];
        [self.departmentCollectionView reloadData];
    }];
    
}
#pragma CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == self.departmentCollectionView)
    {
        return self.departments.count;
    }
    return self.termsArr.count;
    
}

-(LabelCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView == self.departmentCollectionView)
    {
        LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LabelCollectionCell2" forIndexPath:indexPath];
        DepartmentInfo* deparment = self.departments[indexPath.row];
        cell.lblInput1.text = deparment.department_code;
        return cell;
    }
    else
    {
        LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LabelCollectionCell" forIndexPath:indexPath];
        cell.lblInput1.text = self.termsArr[indexPath.row];
        if (indexPath.row==0) {
            cell.lblInput1.backgroundColor = [UIColor blackColor];
            cell.lblInput1.textColor = [UIColor whiteColor];
            [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == self.departmentCollectionView)
    {
        DepartmentInfo* deparment = self.departments[indexPath.row];
        NSString* classe = [NSString stringWithFormat:@"%@/%@%d",deparment.department_code,self.session,(int)self.indSemesterIndex];
        [self performSegueWithIdentifier:@"classSetup" sender:classe];
        
    }
    else
    {
        LabelCollectionCell *cell = (LabelCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.lblInput1.backgroundColor = [UIColor blackColor];
        cell.lblInput1.textColor = [UIColor whiteColor];
        self.session = self.termsArr[indexPath.row];
        [self getDepartments];
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == self.departmentCollectionView)
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
    
    return CGSizeMake(70, 40);
}

#pragma mark  IQDropDownTextField Delegate
-(void)textField:(nonnull IQDropDownTextField*)textField didSelectItem:(nullable NSString*)item
{
    self.indSemesterIndex = [self.semesterTerms indexOfObject:item] + 1;
    if (self.session==nil) {
        [DATAMANAGER showWithStatus:@"Please Select Session" withType:ERROR];
        return;
    }
    [self getDepartments];
}
@end
