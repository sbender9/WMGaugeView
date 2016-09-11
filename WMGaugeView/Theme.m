//
//  Theme.m
//  Wilhelm
//
//  Created by Scott Bender on 8/24/16.
//  Copyright © 2016 Scott Bender. All rights reserved.
//

#import "Theme.h"

@implementation Theme

+ (instancetype)defaultTheme
{
  return [self lightTheme];
}

+ (instancetype)lightTheme
{
  Theme *theme = [[self alloc] init];
  
  theme.backgroundColor = [UIColor whiteColor];;
  theme.textColor = [UIColor blackColor];
  theme.needleColor = [UIColor redColor];
  theme.secondNeedleColor = [UIColor greenColor];
  theme.thirdNeedleColor = [UIColor blueColor];
  theme.scaleDivisionColor = theme.textColor;
  theme.scaleSubDivisionColor = theme.textColor;
  theme.unitOfMeasurementColor = theme.textColor;
  theme.valueLabelColor = theme.textColor;

#ifndef FOR_WATCH
#ifndef FOR_TV
  theme.preferredStatusBarStyle = UIStatusBarStyleDefault;
#endif
  theme.refreshButtonImageName = @"recurring_appointment_black";
  theme.settingsButtonImageName = @"automatic_black";
#endif


  return theme;
}

+ (instancetype)darkTheme
{
  Theme *theme = [[self alloc] init];
  
  theme.backgroundColor = [UIColor blackColor];;
  theme.textColor = [UIColor whiteColor];
  theme.needleColor = [UIColor redColor];
  theme.secondNeedleColor = [UIColor greenColor];
  theme.thirdNeedleColor = [UIColor blueColor];
  theme.scaleDivisionColor = theme.textColor;
  theme.scaleSubDivisionColor = theme.textColor;
  theme.unitOfMeasurementColor = theme.textColor;
  theme.valueLabelColor = theme.textColor;

#ifndef FOR_WATCH
#ifndef FOR_TV
  theme.preferredStatusBarStyle = UIStatusBarStyleLightContent;
#endif
  theme.refreshButtonImageName = @"recurring_appointment_filled";
  theme.settingsButtonImageName = @"automatic";
#endif

  return theme;
}



@end
