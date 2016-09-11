//
//  GaugeConfig.h
//  Wilhelm
//
//  Created by Scott Bender on 8/19/16.
//  Copyright © 2016 Scott Bender. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GaugeConfig.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


@class Boat;

@interface GraphicGaugeConfig : GaugeConfig

@property (nonatomic, readwrite, assign) bool showInnerBackground;
@property (nonatomic, readwrite, assign) bool showInnerRim;
@property (nonatomic, readwrite, assign) CGFloat innerRimWidth;
@property (nonatomic, readwrite, assign) CGFloat innerRimBorderWidth;
@property (nonatomic, readwrite, assign) CGFloat scalePosition;
@property (nonatomic, readwrite, assign) CGFloat scaleStartAngle;
@property (nonatomic, readwrite, assign) CGFloat scaleEndAngle;
@property (nonatomic, readwrite, assign) CGFloat scaleDivisions;
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisions;
@property (nonatomic, readwrite, assign) bool showScaleShadow;
@property (nonatomic, readwrite, assign) bool showScale;
@property (nonatomic, readwrite, assign) GaugeConfigAlignment scalesubdivisionsAligment;
@property (nonatomic, readwrite, assign) CGFloat scaleDivisionsLength;
@property (nonatomic, readwrite, assign) CGFloat scaleDivisionsWidth;
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisionsLength;
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisionsWidth;
@property (nonatomic, readwrite, strong) UIColor *scaleDivisionColor;
@property (nonatomic, readwrite, strong) UIColor *scaleSubDivisionColor;
@property (nonatomic, readwrite, strong) UIFont *scaleFont;
@property (nonatomic, readwrite, assign) CGFloat scaleFontSize;
@property (nonatomic, readwrite, assign) float minValue;
@property (nonatomic, readwrite, assign) float maxValue;
@property (nonatomic, readwrite, assign) bool showRangeLabels;
@property (nonatomic, readwrite, assign) CGFloat rangeLabelsWidth;
@property (nonatomic, readwrite, strong) UIFont *rangeLabelsFont;
@property (nonatomic, readwrite, strong) UIColor *rangeLabelsFontColor;
@property (nonatomic, readwrite, assign) CGFloat rangeLabelsFontKerning;
@property (nonatomic, readwrite, strong) NSArray *rangeValues;
@property (nonatomic, readwrite, strong) NSArray *rangeColors;
@property (nonatomic, readwrite, strong) NSArray *rangeLabels;
@property (nonatomic, readwrite, strong) UIColor *unitOfMeasurementColor;
@property (nonatomic, readwrite, assign) CGFloat unitOfMeasurementVerticalOffset;
@property (nonatomic, readwrite, strong) UIFont *unitOfMeasurementFont;
@property (nonatomic, readwrite, strong) NSString *unitOfMeasurement;
@property (nonatomic, readwrite, assign) bool showUnitOfMeasurement;
@property (nonatomic, readwrite, assign) bool drawLastNumber;
@property (nonatomic, readwrite, strong) UIColor *needleColor;

@property (nonatomic, readwrite, assign) NSInteger numberOfNeedles;
@property (nonatomic, readwrite, strong) UIColor *secondNeedleColor;
@property (nonatomic, readwrite, strong) UIColor *thirdNeedleColor;


@property (nonatomic, readwrite, strong) UIColor *valueLabelColor;
@property (nonatomic, readwrite, assign) CGFloat valueLabelVerticalOffset;
@property (nonatomic, readwrite, strong) UIFont *valueLabelFont;
@property (nonatomic, readwrite, assign) CGFloat valueLabelFontSize;
@property (nonatomic, readwrite, strong) NSString *valueLabelFormat;
@property (nonatomic, readwrite, assign) bool showValueLabel;

- (NSNumber *)getValue:(Boat *)boat;
- (NSNumber *)getValueLabel:(Boat *)boat;

- (NSNumber *)getSecondValue:(Boat *)boat;
- (NSNumber *)getThirdValue:(Boat *)boat;


@end
