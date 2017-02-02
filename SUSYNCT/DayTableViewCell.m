//
//  DayTableViewCell.m
//  SUSYNCT
//
//  Created by Attique Ullah on 02/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "DayTableViewCell.h"

@implementation DayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.eventType.layer.masksToBounds = true;
    self.eventType.layer.cornerRadius = self.eventType.frame.size.width/2;
    self.eventType.layer.borderColor = [UIColor blackColor].CGColor;
    self.eventType.layer.borderWidth = 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 5;
    
}

-(LabelCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttendiesCell" forIndexPath:indexPath];
    cell.lblInput2.layer.masksToBounds = true;
    cell.lblInput2.layer.cornerRadius = cell.lblInput2.frame.size.width/2;
    cell.lblInput2.layer.borderColor = [UIColor blackColor].CGColor;
    cell.lblInput2.layer.borderWidth = 2.0;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(30, 30);
}

@end
