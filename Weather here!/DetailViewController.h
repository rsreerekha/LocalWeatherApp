//
//  DetailViewController.h
//  Weather here!
//
//  Created by testadmin on 6/20/15.
//  Copyright (c) 2015 testadmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"
#import "dayTableViewCell.h"

@interface DetailViewController : UIViewController
//@property dayTableViewCell* weatherDetails;
@property (weak, nonatomic) IBOutlet UILabel *monrningTemp;
@property (weak, nonatomic) IBOutlet UILabel *noonTemp;
@property (weak, nonatomic) IBOutlet UILabel *eveningTemp;
@property (weak, nonatomic) IBOutlet UILabel *nightTemp;
@property (weak, nonatomic) IBOutlet UILabel *humidityTemp;
@property (weak, nonatomic) IBOutlet UILabel *pressureTemp;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property(nonatomic,strong) NSString *unitselected;
@property NSDictionary *weatherDetails;
@end
