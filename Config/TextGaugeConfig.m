//
//  TextGauge.h
//  Wilhelm
//
//  Created by Scott Bender on 8/12/16.
//  Copyright © 2016 Scott Bender. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Boat.h"
#import "GaugeConfig.h"

@interface TextGaugeConfig : GaugeConfig

@property (strong, atomic) NSString *valueFormat;

- (NSNumber *)getValue:(Boat *)boat;
- (NSString *)getStringValue:(Boat *)boat;

@end
