//
//  TextGauge.m
//  Wilhelm
//
//  Created by Scott Bender on 8/12/16.
//  Copyright © 2016 Scott Bender. All rights reserved.
//

#import "TextGaugeConfig.h"

@implementation TextGaugeConfig

- (NSNumber *)getValue:(Boat *)boat
{
  return nil;
}

- (NSString *)getStringValue:(Boat *)boat
{
  return nil;
}

- (NSString *)viewClassName
{
  return @"TextGaugeView";
}


+ (NSString *)watchInterfaceController
{
  return @"TextGauge";
}


@end
