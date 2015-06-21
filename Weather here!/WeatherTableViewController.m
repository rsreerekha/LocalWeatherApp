//
//  WeatherTableViewController.m
//  Weather here!
//
//  Created by testadmin on 6/18/15.
//  Copyright (c) 2015 testadmin. All rights reserved.
//

#import "WeatherTableViewController.h"
#import "Day.h"
#import "dayTableViewCell.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "DetailViewController.h"


@interface WeatherTableViewController ()

@property AFHTTPSessionManager *sessionManager;
@property NSDictionary *parameters;
@property CLLocationManager *locationManager;
@property (nonatomic,strong) NSString*latitude;
@property(nonatomic,strong)NSString*longitude;
@property NSArray *temperatureInfoList;
@property(nonatomic,strong) NSString*minTemp;
@property(nonatomic,strong) NSString*cityName;
@property(nonatomic,strong) NSString *unitselected;


@end

static NSString* WeatherCell = @"WeatherCell";
static NSString *const BASE_URL_STRING = @"http://api.openweathermap.org/data/2.5/forecast/daily";
static NSString *const SETTING_IMPERIAL = @"imperial";
static NSString *const SETTING_METRIC = @"metric";
@implementation WeatherTableViewController

- (void)viewDidLoad {

    
    [super viewDidLoad];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                                                [UIImage imageNamed:@"backgroundImage"]];
    self.tableView.backgroundView.alpha = 0.55;
    self.tableView.backgroundColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.9 alpha:0.55];
    
    [self pinpointLocation];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // self.tableView.backgroundColor = [UIColor clearColor]; // if this is not here, cell background image is covered with a white rectangle
}


- (void)pinpointLocation {
    // Determine whether location services are enabled on the device
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];// initializing locationManager
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;// setting the accuracy

        self.locationManager.delegate = self;//we set the delegate of locationManager to self
        
        [self.locationManager startUpdatingLocation]; //requesting location updates
    } else {
        NSLog(@"Location services are not enabled.");
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    
    CLLocation *crnLoc = [locations lastObject];
    
    //self.addressLabel.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    self.latitude =[NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
    
    //speed.text = [NSString stringWithFormat:@"%.1f m/s", crnLoc.speed];
    [self reverseGeocoder:self.latitude :self.longitude];
    
    [manager stopUpdatingLocation];
    
}
    
-(void)reverseGeocoder:(NSString*)latitude :(NSString*)longitude{
   
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSString * city;
        for (CLPlacemark * placemark in placemarks) {
           // NSString * addressName = [placemark name];
             city = [placemark locality]; // locality means "city"
            // NSString * administrativeArea = [placemark administrativeArea];
        }
        
        self.cityName = [NSString stringWithFormat: @"%@ ", city];
        self.addressLabel.text = [NSString stringWithFormat: @"%@ ", city];
        [self reloadWeatherData: city];
    }];
    
}

-(void) reloadWeatherData: (NSString*) cityName{
    NSURL *baseurl = [NSURL URLWithString:   BASE_URL_STRING];
    
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseurl];
    
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    self.unitselected = [userPreferences valueForKey:@"units"];
    if ([self.unitselected isEqualToString:@"0"]) {
        self.parameters = @{@"q":cityName,@"units":@"imperial"};
    
    }
    else if ([self.unitselected isEqualToString:@"1"]) {
        self.parameters = @{@"q":cityName,@"units":@"metric"};

    }
    
    
    
    //self.parameters  = @{@"q": cityName, @"units": @"imperial"};
    
    [self.sessionManager GET:BASE_URL_STRING parameters:self.parameters success:^(NSURLSessionDataTask *task,
                                                                                  id responseObject) {
        NSError *error;
        NSDictionary *weatherData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                    options:kNilOptions
                                                                      error:&error];
        
        if (!error) {
            
            NSLog(@"%@",weatherData);
            self.addressLabel.text = [[weatherData objectForKey:@"city"] objectForKey:@"name" ];
            self.temperatureInfoList = [weatherData objectForKey:@"list"];
            
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"i am here tooo");
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)datesonCell : (NSInteger) day{
   
    NSDate*currentDate = [NSDate date];
    currentDate = [currentDate dateByAddingTimeInterval: 60*60*24* (int)day];
    NSDateFormatter*formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"MM-dd-yyyy"  ];
    NSString*dateString = [formattedDate stringFromDate:currentDate];
    
    return dateString;
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.temperatureInfoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    dayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WeatherCell forIndexPath:indexPath];
   
    
    //list  has 7 dictionaries. assign first dictionary and retrieve needed datas from it.
    NSDictionary *firstdictionary = self.temperatureInfoList[indexPath.row];
    
    if ([self.unitselected isEqualToString:@"0"]) {
        cell.minTemperature.text = [NSString stringWithFormat:@"%@ \u00B0F ", [[firstdictionary objectForKey:@"temp"]
                                                                       objectForKey:@"min"]];
        cell.maxTemperature.text = [NSString stringWithFormat:@"%@ \u00B0F", [[firstdictionary objectForKey:@"temp"]
                                                                      objectForKey:@"max"]];

    }
    else if ([self.unitselected isEqualToString:@"1"]){
        cell.minTemperature.text = [NSString stringWithFormat:@"%@ \u00B0C ", [[firstdictionary objectForKey:@"temp"]
                                                                              objectForKey:@"min"]];
        cell.maxTemperature.text = [NSString stringWithFormat:@"%@ \u00B0C", [[firstdictionary objectForKey:@"temp"]
                                                                             objectForKey:@"max"]];
    }
    //the weather itself has an arry in it with just 1 object at index0
    NSArray *arrayWeather = [firstdictionary objectForKey:@"weather"];
    NSDictionary *weather = arrayWeather[0];
    NSString *icon = [NSString stringWithFormat:@"%@", [weather objectForKey:@"icon"]];
    //take url of the image and add the icon to it
    NSURL *imageURL = [NSURL URLWithString:[@"http://openweathermap.org/img/w/" stringByAppendingString:
                                            [icon stringByAppendingString: @".png"] ]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    
    cell.weatherImage.image  = [UIImage imageWithData:imageData];
    // taking date from the api
    NSNumber *interval = (NSNumber*) [firstdictionary objectForKey:@"dt"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: (float)interval.intValue];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MMM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    cell.dayName.text = dateString;
    
    //cell.backgroundColor = [UIColor  ];
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     static  NSString* WEATHER_DETAILS = @"WeatherDetails";
    
    DetailViewController *viewController = [segue destinationViewController];
    if ([[segue identifier] isEqualToString:WEATHER_DETAILS])    {
        
        NSInteger row = [self.tableView indexPathForSelectedRow].row;
        
       NSDictionary *selectedTemperatureInfo = [self.temperatureInfoList objectAtIndex:row];
        viewController.weatherDetails = selectedTemperatureInfo;
        
        
       

        
        
        
    }
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
