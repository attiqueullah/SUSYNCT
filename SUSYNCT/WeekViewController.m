//
//  WeekViewController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 02/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "WeekViewController.h"
#import "LNICoverFlowLayout-Swift.h"

@interface WeekViewController ()
{
    CGSize originalItemSize;
    CGSize originalCollectionViewSize;
}
@property (weak, nonatomic) IBOutlet LNICoverFlowLayout *customLayout;
@property(nonatomic,strong)NSMutableArray* weeksArray;

@property (weak, nonatomic) IBOutlet UICollectionView *tableView;
@end

@implementation WeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    originalItemSize = self.customLayout.itemSize;
    originalCollectionViewSize = self.tableView.bounds.size;
    
    
    [self getWeekDays];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getCurrentWeekDay:[NSDate date]];
    
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.customLayout invalidateLayout];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.customLayout.itemSize = CGSizeMake(self.tableView.bounds.size.width * originalItemSize.width / originalCollectionViewSize.width, self.tableView.bounds.size.height * originalItemSize.height / originalCollectionViewSize.height);
    
    [self setInitialValues];
    
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    [self.tableView reloadData];
}
-(void)setInitialValues
{
    self.customLayout.maxCoverDegree = 39.28;
    self.customLayout.coverDensity = 0.0;
    self.customLayout.minCoverScale = 0.77;
    self.customLayout.minCoverOpacity = 0.80;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getCurrentWeekDay:(NSDate*)dte
{
    [self.view layoutIfNeeded];
    [self.tableView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[dte weekday] inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}
#pragma mark Get Week Days
-(void)getWeekDays
{
    self.weeksArray = [NSMutableArray new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.weeksArray = [[dateFormatter weekdaySymbols] mutableCopy];
    
}
#pragma mark CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.weeksArray.count;
    
}

-(LabelCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayViewCell" forIndexPath:indexPath];
    cell.lblInput2.text = self.weeksArray[indexPath.row];
    cell.lblInput2.layer.borderColor = [UIColor blackColor].CGColor;
    cell.lblInput2.layer.borderWidth = 2.0;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
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
