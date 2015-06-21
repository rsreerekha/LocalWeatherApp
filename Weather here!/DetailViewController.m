//
//  DetailViewController.m
//  Weather here!
//
//  Created by testadmin on 6/20/15.
//  Copyright (c) 2015 testadmin. All rights reserved.
//

#import "DetailViewController.h"
#import "WeatherTableViewController.h"
#import "dayTableViewCell.h"


@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    
    NSString *tempUnit = @" \u00B0F";
    NSString *humidUnit = @" %";
    NSString *pressUnit = @" in";

    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.10];
    
    self.unitselected = [userPreferences valueForKey:@"units"];
    if ([self.unitselected isEqualToString:@"1"]) {
        tempUnit = @" \u00B0C";
        pressUnit = @" mb";
    }
    
    self.monrningTemp.text = [[NSString stringWithFormat:@"%@", [[self.weatherDetails objectForKey:@"temp"]
                                                                objectForKey:@"morn"]] stringByAppendingString:tempUnit];
    self.eveningTemp.text = [[NSString stringWithFormat:@"%@", [[self.weatherDetails objectForKey:@"temp"]
                                                              objectForKey:@"eve"]] stringByAppendingString:tempUnit];
    self.noonTemp.text = [[NSString stringWithFormat:@"%@", [[self.weatherDetails objectForKey:@"temp"]
                                                              objectForKey:@"day"]] stringByAppendingString:tempUnit];
    self.nightTemp.text = [[NSString stringWithFormat:@"%@", [[self.weatherDetails objectForKey:@"temp"]
                                                              objectForKey:@"night"]] stringByAppendingString:tempUnit];
    self.humidityTemp.text = [[NSString stringWithFormat:@"%@", [self.weatherDetails objectForKey:@"humidity"]]
                              stringByAppendingString: humidUnit];
    self.pressureTemp.text = [[NSString stringWithFormat:@"%@", [self.weatherDetails objectForKey:@"pressure"]]
                              stringByAppendingString: pressUnit];
                                                              

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
