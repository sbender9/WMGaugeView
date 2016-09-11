//
//  Theme.h
//  Wilhelm
//
//  Created by Scott Bender on 8/24/16.
//  Copyright © 2016 Scott Bender. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Theme : NSObject

@property (strong, atomic) UIColor *backgroundColor;
@property (strong, atomic) UIColor *textColor;
@property (strong, atomic) UIColor *needleColor;
@property (strong, atomic) UIColor *secondNeedleColor;
@property (strong, atomic) UIColor *thirdNeedleColor;
@property (strong, atomic) UIColor *scaleDivisionColor;
@property (strong, atomic) UIColor *scaleSubDivisionColor;
@property (strong, atomic) UIColor *unitOfMeasurementColor;
@property (strong, atomic) UIColor *valueLabelColor;

#ifndef FOR_WATCH
#ifndef FOR_TV
@property UIStatusBarStyle preferredStatusBarStyle;
#endif
@property (strong, atomic) NSString *refreshButtonImageName;
@property (strong, atomic) NSString *settingsButtonImageName;
#endif

+ (instancetype)defaultTheme;
+ (instancetype)darkTheme;
+ (instancetype)lightTheme;

@end
