//
//  WeatherTableViewController.h
//  Weather here!
//
//  Created by testadmin on 6/18/15.
//  Copyright (c) 2015 testadmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherTableViewController : UITableViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
