//
//  GaugeConfig.m
//  Wilhelm
//
//  Created by Scott Bender on 8/19/16.
//  Copyright © 2016 Scott Bender. All rights reserved.
//

#import "GraphicGaugeConfig.h"

@implementation GraphicGaugeConfig

- (void)configure
{
  _showInnerRim = NO;
  _showInnerBackground = YES;
  _innerRimWidth = 0.05;
  _innerRimBorderWidth = 0.005;
  
  _scalePosition = 0.025;
  _scaleStartAngle = 30.0;
  _scaleEndAngle = 330.0;
  _scaleDivisions = 12.0;
  _scaleSubdivisions = 10.0;
  _showScale = YES;
  _showScaleShadow = YES;
  _scalesubdivisionsAligment = GaugeConfigAlignmentTop;
  _scaleDivisionsLength = 0.045;
  _scaleDivisionsWidth = 0.01;
  _scaleSubdivisionsLength = 0.015;
  _scaleSubdivisionsWidth = 0.01;
  
  _minValue = 0.0;
  _maxValue = 240.0;
  
  _showRangeLabels = NO;
  _rangeLabelsWidth = 0.05;
  _rangeLabelsFont = [UIFont fontWithName:@"Helvetica" size:0.05];
  _rangeLabelsFontColor = self.theme.textColor;
  _rangeLabelsFontKerning = 1.0;
  _rangeValues = nil;
  _rangeColors = nil;
  _rangeLabels = nil;
  
  _scaleDivisionColor = RGB(68, 84, 105);
  _scaleSubDivisionColor = RGB(217, 217, 217);
  
  _scaleFont = nil;
  
  _unitOfMeasurementVerticalOffset = 0.6;
  _unitOfMeasurementColor = self.theme.unitOfMeasurementColor;
  _unitOfMeasurementFont = [UIFont fontWithName:@"Helvetica" size:0.04];
  _unitOfMeasurement = @"";
  _showUnitOfMeasurement = NO;
  
  _drawLastNumber = YES;
  
  _numberOfNeedles = 1;

  
  self.showScaleShadow = YES;
  self.scalesubdivisionsAligment = GaugeConfigAlignmentCenter;
  self.scaleSubdivisionsWidth = 0.002;
  self.scaleSubdivisionsLength = 0.04;
  self.scaleDivisionsWidth = 0.007;
  self.scaleDivisionsLength = 0.07;
  self.scaleDivisionColor = self.theme.scaleDivisionColor;
  self.scaleSubDivisionColor = self.theme.scaleSubDivisionColor;
  self.unitOfMeasurementFont = [UIFont fontWithName:@"Helvetica" size:0.06];
  self.unitOfMeasurementVerticalOffset = 0.555;
  self.valueLabelColor = self.theme.valueLabelColor;
  
  self.valueLabelVerticalOffset = 0.655;
  self.valueLabelFontSize = [self deviceType] == GaugeConfigPad ? 0.095 : 0.075;
  
  if ( [self deviceType] == GaugeConfigPad )
  {/*
	self.scaleFont = [UIFont fontWithName:@"Helvetica-Bold"
										   size:0.065];
	*/
	self.scaleFontSize = 0.050;
  }
  else
  {
	/*
	self.scaleFont = [UIFont fontWithName:@"Helvetica-Bold"
										   size:0.090];
	 */
	self.scaleFontSize = 0.075;
  }

}

- (NSNumber *)getValue:(Boat *)boat
{
  return 0;
}

- (NSNumber *)getValueLabel:(Boat *)boat
{
  return [self getValue:boat];
}

- (NSNumber *)getSecondValue:(Boat *)boat
{
  return 0;
}

- (NSNumber *)getThirdValue:(Boat *)boat
{
  return 0;
}

- (NSString *)viewClassName
{
  return @"GraphicGaugeView";
}

+ (NSString *)watchInterfaceController
{
  return @"GraphicGauge";
}


@end
