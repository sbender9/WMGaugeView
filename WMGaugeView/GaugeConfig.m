//
//  GaugeConfig.m
//  Wilhelm
//
//  Created by Scott Bender on 8/19/16.
//  Copyright © 2016 Scott Bender. All rights reserved.
//

#import "GaugeConfig.h"
#import <UIKit/UIKit.h>

@implementation GaugeConfig

- (instancetype)initWIthTheme:(Theme *)theme
{
  self = [super init];
  self.theme = theme;
  [self configure];
  return self;
}

- (void)configure
{
}

- (NSString *)viewClassName
{
  return nil;
}

+ (NSString *)watchInterfaceController
{
  return nil;
}

- (GaugeConfigDeviceType)deviceType
{
#ifdef UI_USER_INTERFACE_IDIOM
  return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? GaugeConfigPad : GaugeConfigPhone;
#else
  return GaugeConfigWatch;
#endif
}

@end
