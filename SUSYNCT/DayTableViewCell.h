//
//  DayTableViewCell.h
//  SUSYNCT
//
//  Created by Attique Ullah on 02/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblEventName;
@property (weak, nonatomic) IBOutlet UIButton *eventType;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UICollectionView *attendiesCollectionView;

@end
