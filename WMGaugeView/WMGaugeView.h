/*
 * WMGaugeView.h
 *
 * Copyright (C) 2014 William Markezana <william.markezana@me.com>
 *
 */

#import <UIKit/UIKit.h>
#import "GraphicGaugeConfig.h"
#import "WMGaugeViewStyle.h"
#import "WMGaugeViewStyleFlatThin.h"
#import "WMGaugeViewStyle3D.h"

/**
 * WMGaugeView class
 */
@interface WMGaugeView : UIView

@property (nonatomic, readwrite, strong) GraphicGaugeConfig *config;

@property (nonatomic, readwrite, assign) float value;
@property (nonatomic, readwrite, assign) float secondValue;
@property (nonatomic, readwrite, assign) float thirdValue;

@property (nonatomic, readwrite, strong) NSNumber *labelValue;
@property (nonatomic, readwrite, strong) id<WMGaugeViewStyle> style;


/**
 * WMGaugeView public functions
 */

- (instancetype)initWithFrame:(CGRect)frame andConfig:(GraphicGaugeConfig *)config;

- (void)setLabelValue:(NSNumber *)value;
- (void)setValue:(float)value animated:(BOOL)animated;
- (void)setValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)setSecondValue:(float)value animated:(BOOL)animated;
- (void)setSecondValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)setSecondValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)setSecondValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)setThirdValue:(float)value animated:(BOOL)animated;
- (void)setThirdValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)setThirdValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)setThirdValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)invalidateNeedle;
- (void)invalidateBackground;

- (void)moveNeedleToNewFrame:(CGRect)frame oldFrame:(CGRect)oldFrame;

@end
