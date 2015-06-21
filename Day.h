//
//  Day.h
//  
//
//  Created by testadmin on 6/19/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Day : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * maxTemperature;
@property (nonatomic, retain) NSNumber * minTemperature;
@property (nonatomic, retain) NSString * weatherImage;

@end
