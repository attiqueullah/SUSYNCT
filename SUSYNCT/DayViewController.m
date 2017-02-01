//
//  DayViewController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 01/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "DayViewController.h"
#import "LNICoverFlowLayout-Swift.h"
@interface DayViewController ()
{
    CGSize originalItemSize;
    CGSize originalCollectionViewSize;
}
@property (weak, nonatomic) IBOutlet LNICoverFlowLayout *customLayout;
@property(nonatomic,strong)NSMutableArray* weekDays;
@end

@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    originalItemSize = self.customLayout.itemSize;
    originalCollectionViewSize = self.tableView.bounds.size;
    [self getWeekDays];
    
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
    self.customLayout.maxCoverDegree = 53.01;
    self.customLayout.coverDensity = 0.28;
    self.customLayout.minCoverScale = 0.85;
    self.customLayout.minCoverOpacity = 0.80;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Get Week Days
-(void)getWeekDays
{
    self.weekDays = [NSMutableArray new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.weekDays = [[dateFormatter weekdaySymbols] mutableCopy];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.weekDays.count;
    
}

-(LabelCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayViewCell" forIndexPath:indexPath];
    cell.lblInput2.text = self.weekDays[indexPath.row];
    cell.lblInput2.layer.borderColor = [UIColor blackColor].CGColor;
    cell.lblInput2.layer.borderWidth = 2.0;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
}


@end
