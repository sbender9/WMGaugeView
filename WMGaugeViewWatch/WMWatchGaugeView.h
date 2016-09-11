/*
 * WMGaugeView.h
 *
 * Copyright (C) 2014 William Markezana <william.markezana@me.com>
 *
 */

#import <UIKit/UIKit.h>
#import "WMWatchGaugeViewStyle.h"
#import "WMWatchGaugeViewStyleFlatThin.h"
#import "GraphicGaugeConfig.h"
//#import "WMWatchGaugeViewStyle3D.h"


/**
 * WMGaugeView class
 */
@interface WMWatchGaugeView : NSObject

/**
 * WMGaugeView properties
 */

@property (nonatomic, readwrite, strong) GraphicGaugeConfig *config;

@property (nonatomic, readwrite, assign) float value;
@property (nonatomic, readwrite, assign) float secondValue;
@property (nonatomic, readwrite, assign) float thirdValue;
@property (nonatomic, readwrite, strong) NSNumber *labelValue;
@property (nonatomic, readwrite, strong) id<WMWatchGaugeViewStyle> style;




/**
 * WMGaugeView public functions
 */
- (id)initWithConfig:(GraphicGaugeConfig *)config;

- (void)setLabelValue:(NSNumber *)value;

- (void)setValue:(float)value animated:(BOOL)animated;
- (void)setValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)setSecondValue:(float)value animated:(BOOL)animated;
- (void)setSecondValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)setSecondValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)setSecondValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)drawRect:(CGRect)rect background:(UIColor *)backgrounColor;

- (UIImage *)getImage;

@end
