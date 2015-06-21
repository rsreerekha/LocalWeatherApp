//
//  dayTableViewCell.h
//  Weather here!
//
//  Created by testadmin on 6/19/15.
//  Copyright (c) 2015 testadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayName;
@property (weak, nonatomic) IBOutlet UILabel *minTemperature;
@property (weak, nonatomic) IBOutlet UILabel *maxTemperature;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

@end
