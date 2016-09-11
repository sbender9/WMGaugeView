//
//  GaugeConfig.h
//  Wilhelm
//
//  Created by Scott Bender on 8/19/16.
//  Copyright © 2016 Scott Bender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Boat.h"
#import "Theme.h"

typedef enum
{
  GaugeConfigAlignmentTop,
  GaugeConfigAlignmentCenter,
  GaugeConfigAlignmentBottom
}
GaugeConfigAlignment;

typedef enum
{
  GaugeConfigPhone,
  GaugeConfigPad,
  GaugeConfigWatch
}
GaugeConfigDeviceType;

@interface GaugeConfig : NSObject

@property (nonatomic, readwrite, assign) NSString *title;
@property (atomic, readwrite, strong) NSAttributedString *attributedTitle;
@property (atomic, readwrite, strong) Theme *theme;
@property BOOL thumbnailDisplay;


- (instancetype)initWIthTheme:(Theme *)theme;

- (void)configure;

- (GaugeConfigDeviceType)deviceType;

- (NSString *)viewClassName;
+ (NSString *)watchInterfaceController;

@end
