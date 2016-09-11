/*
 * WMGaugeView.h
 *
 * Copyright (C) 2014 William Markezana <william.markezana@me.com>
 *
 */

#import "WMWatchGaugeView.h"

/* Scale conversion macro from [0-1] range to view  real size range */
#define FULL_SCALE(x,y)    (x)*self.bounds.size.width, (y)*self.bounds.size.height

@implementation WMWatchGaugeView
{
    /* Drawing rects */
    CGRect fullRect;
    CGRect innerRimRect;
    CGRect innerRimBorderRect;
    CGRect faceRect;
    CGRect rangeLabelsRect;
    CGRect scaleRect;

    /* View center */
    CGPoint center;

    /* Scale variables */
    CGFloat scaleRotation;    
    CGFloat divisionValue;
    CGFloat subdivisionValue;
    CGFloat subdivisionAngle;
    
    /* Background image */
    UIImage *background;
  
    /* Annimation completion */
    void (^animationCompletion)(BOOL);
}

#pragma mark - Initialization

- (UIImage *)getImage
{
  return background;
}

- (id)initWithConfig:(GraphicGaugeConfig *)config
{
  self = [super init];
  self.config = config;
  //self = [super initWithFrame:frame];
  //self.bounds = frame;
  if (self)
  {
	[self initialize];
  }
  return self;
}

- (void)awakeFromNib
{
    [self initialize];
}

/**
 *  Set all properties to default values
 *  Set all private variables to default values
 */
- (void)initialize;
{
  _style = nil;
  
  _value = 0.0;
  
  background = nil;
  
  animationCompletion = nil;
  
  [self initDrawingRects];
  [self initScale];
}

/**
 *  Initialize all drawing rects and center point
 */
- (void)initDrawingRects
{
    center = CGPointMake(0.5, 0.5);
    fullRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    
    self.config.innerRimBorderWidth = self.config.showInnerRim ? self.config.innerRimBorderWidth : 0.0;
    self.config.innerRimWidth = self.config.showInnerRim ? self.config.innerRimWidth : 0.0;
    
    innerRimRect = fullRect;
    innerRimBorderRect = CGRectMake(innerRimRect.origin.x + self.config.innerRimBorderWidth,
                                    innerRimRect.origin.y + self.config.innerRimBorderWidth,
                                    innerRimRect.size.width - 2 * self.config.innerRimBorderWidth,
                                    innerRimRect.size.height - 2 * self.config.innerRimBorderWidth);
    faceRect = CGRectMake(innerRimRect.origin.x + self.config.innerRimWidth,
                          innerRimRect.origin.y + self.config.innerRimWidth,
                          innerRimRect.size.width - 2 * self.config.innerRimWidth,
                          innerRimRect.size.height - 2 * self.config.innerRimWidth);
    rangeLabelsRect = CGRectMake(faceRect.origin.x + (self.config.showRangeLabels ? self.config.rangeLabelsWidth : 0.0),
                                 faceRect.origin.y + (self.config.showRangeLabels ? self.config.rangeLabelsWidth : 0.0),
                                 faceRect.size.width - 2 * (self.config.showRangeLabels ? self.config.rangeLabelsWidth : 0.0),
                                 faceRect.size.height - 2 * (self.config.showRangeLabels ? self.config.rangeLabelsWidth : 0.0));
    scaleRect = CGRectMake(rangeLabelsRect.origin.x + self.config.scalePosition,
                           rangeLabelsRect.origin.y + self.config.scalePosition,
                           rangeLabelsRect.size.width - 2 * self.config.scalePosition,
                           rangeLabelsRect.size.height - 2 * self.config.scalePosition);
}

#pragma mark - Drawing

/**
 * Main drawing entry point 
 */
- (void)drawRect:(CGRect)rect background:(UIColor *)backgrounColor
{
  // Create image context
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);//[UIScreen mainScreen].scale);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  //[backgrounColor setFill];
  //CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));

  
  [self drawNeedle:rect context:context];
  
  if ( self.config.numberOfNeedles > 1 )
	[self drawSecondNeedle:rect context:context];
  
  if ( self.config.numberOfNeedles > 2 )
	[self drawThirdNeedle:rect context:context];
  
  // Scale context for [0-1] drawings
  CGContextScaleCTM(context, rect.size.width , rect.size.height);
  
  // Draw gauge background in image context
  [self drawGauge:context];
	
  
  // Save background
  background = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  

    // Drawing background in view
  //[background drawInRect:rect];
 
  /*
    if (rootNeedleLayer == nil)
    {
        // Initialize needle layer
        rootNeedleLayer = [CALayer new];

        // For performance puporse, the needle layer is not scaled to [0-1] range
        rootNeedleLayer.frame = self.bounds;
        [self.layer addSublayer:rootNeedleLayer];
        
        // Draw needle
        [self drawNeedle];
        
        // Set needle current value
        [self setValue:_value animated:NO];
    }    

    if (_hasTwoNeedles && secondRootNeedleLayer == nil)
    {
        // Initialize needle layer
        secondRootNeedleLayer = [CALayer new];

        // For performance puporse, the needle layer is not scaled to [0-1] range
        secondRootNeedleLayer.frame = self.bounds;
        [self.layer addSublayer:secondRootNeedleLayer];
        
        // Draw needle
        [self drawSecondNeedle];
        
        // Set needle current value
        [self setSecondValue:_secondValue animated:NO];
    } 
   */
}

/**
 *  Gauge background drawing
 */
- (void)drawGauge:(CGContextRef)context
{
    [self drawRim:context];

    if (self.config.showInnerBackground)
        [self drawFace:context];

    if (self.config.showUnitOfMeasurement)
        [self drawText:context];
  
  if ( self.config.showValueLabel )
	[self drawLabelText:context];

    if (self.config.showScale)
        [self drawScale:context];

    if (self.config.showRangeLabels)
        [self drawRangeLabels:context];
}

/**
 *  Gauge external rim drawing
 */
- (void)drawRim:(CGContextRef)context
{
    // TODO
}

/**
 *  Gauge inner background drawing
 */
- (void)drawFace:(CGContextRef)context
{
    if ([_style conformsToProtocol:@protocol(WMWatchGaugeViewStyle)]) {
        [_style drawFaceWithContext:context inRect:faceRect];
    }
}

/**
 *  Unit of measurement drawing
 */
- (void)drawText:(CGContextRef)context
{
    CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
    UIFont* font = self.config.unitOfMeasurementFont ? self.config.unitOfMeasurementFont : [UIFont fontWithName:@"Helvetica" size:0.04];
    UIColor* color = self.config.unitOfMeasurementColor ? self.config.unitOfMeasurementColor : [UIColor whiteColor];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:self.config.unitOfMeasurement attributes:stringAttrs];
    CGSize fontWidth;
    fontWidth = [self.config.unitOfMeasurement sizeWithAttributes:stringAttrs];

    [attrStr drawAtPoint:CGPointMake(0.5 - fontWidth.width / 2.0, self.config.unitOfMeasurementVerticalOffset)];
}

- (void)drawLabelText:(CGContextRef)context
{
  CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
  CGFloat fsize = self.config.valueLabelFontSize != 0 ? self.config.valueLabelFontSize : 0.04;
  UIFont* font = self.config.valueLabelFont ? self.config.valueLabelFont : [UIFont fontWithName:@"Helvetica" size:fsize];
  UIColor* color = self.config.valueLabelColor ? self.config.valueLabelColor : [UIColor whiteColor];
  NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
  NSString *str;
  
  CGFloat value = _labelValue != nil ? _labelValue.floatValue : _value;

  if ( self.config.valueLabelFormat )
	str = [NSString stringWithFormat:self.config.valueLabelFormat, value];
  else
	str = [NSString stringWithFormat:@"%f", value];
  NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:str attributes:stringAttrs];
  CGSize fontWidth;
  fontWidth = [str sizeWithAttributes:stringAttrs];
  
  [attrStr drawAtPoint:CGPointMake(0.5 - fontWidth.width / 2.0, self.config.valueLabelVerticalOffset)];
}


/**
 * Scale drawing
 */
- (void)drawScale:(CGContextRef)context
{
    CGContextSaveGState(context);
    [self rotateContext:context fromCenter:center withAngle:DEGREES_TO_RADIANS(180 + self.config.scaleStartAngle)];
    
    int totalTicks = self.config.scaleDivisions * self.config.scaleSubdivisions + 1;
    for (int i = 0; i < totalTicks; i++)
    {
        CGFloat offset = 0.0;
        if (self.config.scalesubdivisionsAligment == GaugeConfigAlignmentCenter) offset = (self.config.scaleDivisionsLength - self.config.scaleSubdivisionsLength) / 2.0;
        if (self.config.scalesubdivisionsAligment == GaugeConfigAlignmentBottom) offset = self.config.scaleDivisionsLength - self.config.scaleSubdivisionsLength;
        
        CGFloat y1 = scaleRect.origin.y;
        CGFloat y2 = y1 + self.config.scaleSubdivisionsLength;
        CGFloat y3 = y1 + self.config.scaleDivisionsLength;
        
        float value = [self valueForTick:i];
        float div = (self.config.maxValue - self.config.minValue) / self.config.scaleDivisions;
        float mod = (int)value % (int)div;
        
        // Division
        if ((fabsf(mod - 0) < 0.000001) || (fabsf(mod - div) < 0.000001))
        {
		  if ( self.config.drawLastNumber == YES || i != (totalTicks-1) )
			  {
				// Initialize Core Graphics settings
				UIColor *color = (self.config.rangeValues && self.config.rangeColors) ? [self rangeColorForValue:value] : self.config.scaleDivisionColor;
				CGContextSetStrokeColorWithColor(context, color.CGColor);
				CGContextSetLineWidth(context, self.config.scaleDivisionsWidth);
				CGContextSetShadow(context, CGSizeMake(0.05, 0.05), self.config.showScaleShadow ? 2.0 : 0.0);
				
				// Draw tick
				CGContextMoveToPoint(context, 0.5, y1);
				CGContextAddLineToPoint(context, 0.5, y3);
				CGContextStrokePath(context);
				
				if ( value < 0 )
				  value = value * -1;
				
				// Draw label
				NSString *valueString = [NSString stringWithFormat:@"%0.0f",value];
				CGFloat fsize = self.config.scaleFontSize != 0 ? self.config.scaleFontSize : 0.05;
				UIFont* font = self.config.scaleFont ? self.config.scaleFont : [UIFont fontWithName:@"Helvetica" size:fsize];
				NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
				NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:valueString attributes:stringAttrs];
				CGSize fontWidth;
				fontWidth = [valueString sizeWithAttributes:stringAttrs];
				
				[attrStr drawAtPoint:CGPointMake(0.5 - fontWidth.width / 2.0, y3 + 0.005)];
			  }
        }
        // Subdivision
        else
        {
            // Initialize Core Graphics settings
            UIColor *color = (self.config.rangeValues && self.config.rangeColors) ? [self rangeColorForValue:value] : self.config.scaleSubDivisionColor;
            CGContextSetStrokeColorWithColor(context, color.CGColor);
            CGContextSetLineWidth(context, self.config.scaleSubdivisionsWidth);
            CGContextMoveToPoint(context, 0.5, y1);
            if (self.config.showScaleShadow) CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
            
            // Draw tick
            CGContextMoveToPoint(context, 0.5, y1 + offset);
            CGContextAddLineToPoint(context, 0.5, y2 + offset);
            CGContextStrokePath(context);
        }
        
        // Rotate to next tick
        [self rotateContext:context fromCenter:center withAngle:DEGREES_TO_RADIANS(subdivisionAngle)];
    }
    CGContextRestoreGState(context);
}

/**
 * scale range labels drawing 
 */
- (void)drawRangeLabels:(CGContextRef)context
{
    CGContextSaveGState(context);
    [self rotateContext:context fromCenter:center withAngle:DEGREES_TO_RADIANS(90 + self.config.scaleStartAngle)];
    CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 0.0);
    
    CGFloat maxAngle = self.config.scaleEndAngle - self.config.scaleStartAngle;
    CGFloat lastStartAngle = 0.0f;

    for (int i = 0; i < self.config.rangeValues.count; i ++)
    {
        // Range value
        float value = ((NSNumber*)[self.config.rangeValues objectAtIndex:i]).floatValue;
        float valueAngle = (value - self.config.minValue) / (self.config.maxValue - self.config.minValue) * maxAngle;
        
        // Range curved shape
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center radius:rangeLabelsRect.size.width / 2.0 startAngle:DEGREES_TO_RADIANS(lastStartAngle) endAngle:DEGREES_TO_RADIANS(valueAngle) - 0.01 clockwise:YES];
	  
        UIColor *color = self.config.rangeColors[i];
        [color setStroke];
        path.lineWidth = self.config.rangeLabelsWidth;
        [path stroke];
        
        // Range curved label
        [self drawStringAtContext:context string:(NSString*)self.config.rangeLabels[i] withCenter:center radius:rangeLabelsRect.size.width / 2.0 startAngle:DEGREES_TO_RADIANS(lastStartAngle) endAngle:DEGREES_TO_RADIANS(valueAngle)];
        
        lastStartAngle = valueAngle;
    }
    
    CGContextRestoreGState(context);
}

/**
 * Needle drawing 
 */
- (void)drawNeedle:(CGRect)rect context:(CGContextRef)context
{
    if ([_style conformsToProtocol:@protocol(WMWatchGaugeViewStyle)]) {
	  [_style drawNeedleInRect:rect
						 color:self.config.needleColor
					   atAngle:[self needleAngleForValue:_value]
					   inContext:context];

    }
}

- (void)drawSecondNeedle:(CGRect)rect context:(CGContextRef)context
{
    if ([_style conformsToProtocol:@protocol(WMWatchGaugeViewStyle)]) {
	  [_style drawNeedleInRect:rect color:self.config.secondNeedleColor atAngle:[self needleAngleForValue:_secondValue] inContext:context];

    }
}

- (void)drawThirdNeedle:(CGRect)rect context:(CGContextRef)context
{
  if ([_style conformsToProtocol:@protocol(WMWatchGaugeViewStyle)]) {
	[_style drawNeedleInRect:rect color:self.config.thirdNeedleColor atAngle:[self needleAngleForValue:_thirdValue] inContext:context];
	
  }
}


#pragma mark - Tools

/**
 * Core Graphics rotation in context
 */
- (void)rotateContext:(CGContextRef)context fromCenter:(CGPoint)center_ withAngle:(CGFloat)angle
{
    CGContextTranslateCTM(context, center_.x, center_.y);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, -center_.x, -center_.y);
}

/**
 * Needle angle computation
 */
- (CGFloat)needleAngleForValue:(double)value
{
  double angle = self.config.scaleStartAngle + (value - self.config.minValue) / (self.config.maxValue - self.config.minValue) * (self.config.scaleEndAngle - self.config.scaleStartAngle);
  return DEGREES_TO_RADIANS(angle) + M_PI;
}

/**
 * Initialize scale helper values
 */
- (void)initScale
{
    scaleRotation = (int)(self.config.scaleStartAngle + 180) % 360;
    divisionValue = (self.config.maxValue - self.config.minValue) / self.config.scaleDivisions;
    subdivisionValue = divisionValue / self.config.scaleSubdivisions;
    subdivisionAngle = (self.config.scaleEndAngle - self.config.scaleStartAngle) / (self.config.scaleDivisions * self.config.scaleSubdivisions);
}

/**
 * Scale tick value computation
 */
- (float)valueForTick:(int)tick
{
    return tick * (divisionValue / self.config.scaleSubdivisions) + self.config.minValue;
}

/**
 * Scale range label color for value
 */
- (UIColor*)rangeColorForValue:(float)value
{
    NSInteger length = self.config.rangeValues.count;
    for (int i = 0; i < length - 1; i++)
    {
        if (value < [self.config.rangeValues[i] floatValue])
            return self.config.rangeColors[i];
    }
    if (value <= [self.config.rangeValues[length - 1] floatValue])
        return self.config.rangeColors[length - 1];
    return nil;
}

/**
 * Draw curved NSSring in context
 */
- (void)drawStringAtContext:(CGContextRef) context string:(NSString*)text withCenter:(CGPoint)center_ radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    CGContextSaveGState(context);
    
    UIFont* font = self.config.rangeLabelsFont ? self.config.rangeLabelsFont : [UIFont fontWithName:@"Helvetica" size:0.05];
    UIColor* color = self.config.rangeLabelsFontColor ? self.config.rangeLabelsFontColor : [UIColor whiteColor];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    CGSize textSize;
    textSize = [text sizeWithAttributes:stringAttrs];
    
    float perimeter = 2 * M_PI * radius;
    float textAngle = textSize.width / perimeter * 2 * M_PI * self.config.rangeLabelsFontKerning;
    float offset = ((endAngle - startAngle) - textAngle) / 2.0;

    float letterPosition = 0;
    NSString *lastLetter = @"";
    
    [self rotateContext:context fromCenter:center withAngle:startAngle + offset];
    for (int index = 0; index < [text length]; index++)
    {
        NSRange range = {index, 1};
        NSString* letter = [text substringWithRange:range];
        NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:letter attributes:stringAttrs];
        CGSize charSize = [letter sizeWithAttributes:stringAttrs];
        float totalWidth = [[NSString stringWithFormat:@"%@%@",lastLetter, letter] sizeWithAttributes:stringAttrs].width;
        float currentLetterWidth = [letter sizeWithAttributes:stringAttrs].width;
        float lastLetterWidth = [lastLetter sizeWithAttributes:stringAttrs].width;
        float kerning = (lastLetterWidth) ? 0.0 : ((currentLetterWidth + lastLetterWidth) - totalWidth);
        
        letterPosition += (charSize.width / 2) - kerning;
        float angle = (letterPosition / perimeter * 2 * M_PI) * self.config.rangeLabelsFontKerning;
        CGPoint letterPoint = CGPointMake((radius - charSize.height / 2.0) * cos(angle) + center_.x, (radius - charSize.height / 2.0) * sin(angle) + center_.y);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, letterPoint.x, letterPoint.y);
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(angle + M_PI_2);
        CGContextConcatCTM(context, rotationTransform);
        CGContextTranslateCTM(context, -letterPoint.x, -letterPoint.y);

        [attrStr drawAtPoint:CGPointMake(letterPoint.x - charSize.width/2 , letterPoint.y - charSize.height)];
        
        CGContextRestoreGState(context);
        
        letterPosition += charSize.width / 2;
        lastLetter = letter;
    }
    CGContextRestoreGState(context);
}

/**
 * Invalidate background
 * Background will be regenerated during next draw rect
 */

- (void)invalidateBackground
{
    background = nil;
    [self initDrawingRects];
    [self initScale];
    //[self setNeedsDisplay];
}

/**
 * Invalidate Needle
 * Needle will be regenerated during next draw rect
 */
- (void)invalidateNeedle
{
  /*
    [rootNeedleLayer removeAllAnimations];
    rootNeedleLayer.sublayers = nil;
    rootNeedleLayer = nil;
    
    [self setNeedsDisplay];
   */
}
#pragma mark - Value update

/**
 * Update gauge value
 */
- (void)updateValue:(float)value
{
    // Clamp value if out of range
    if (value > self.config.maxValue)
        value = self.config.maxValue;
    else if (value < self.config.minValue)
        value = self.config.minValue;
    else
        value = value;
    
    // Set value
    _value = value;
}

- (void)updateSecondValue:(float)value
{
    // Clamp value if out of range
    if (value > self.config.maxValue)
        value = self.config.maxValue;
    else if (value < self.config.minValue)
        value = self.config.minValue;
    else
        value = value;
    
    // Set value
    _secondValue = value;
}

- (void)updateThirdValue:(float)value
{
  // Clamp value if out of range
  if (value > self.config.maxValue)
	value = self.config.maxValue;
  else if (value < self.config.minValue)
	value = self.config.minValue;
  else
	value = value;
  
  // Set value
  _thirdValue = value;
}


/**
 * Update gauge value with animation
 */
- (void)setValue:(float)value animated:(BOOL)animated
{
    [self setValue:value animated:animated duration:0.8];
}

- (void)setSecondValue:(float)value animated:(BOOL)animated
{
    [self setSecondValue:value animated:animated duration:0.8];
}

- (void)setThirdValue:(float)value animated:(BOOL)animated
{
  [self setThirdValue:value animated:animated duration:0.8];
}


/**
 * Update gauge value with animation and fire a completion block
 */
- (void)setValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [self setValue:value animated:animated duration:0.8 completion:completion];
}

- (void)setSecondValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [self setSecondValue:value animated:animated duration:0.8 completion:completion];
}

- (void)setThirdValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
  [self setThirdValue:value animated:animated duration:0.8 completion:completion];
}


/**
 * Update gauge value with animation and duration
 */
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setValue:value animated:animated duration:duration completion:nil];
}

- (void)setSecondValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setSecondValue:value animated:animated duration:duration completion:nil];
}

- (void)setThirdValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration
{
  [self setThirdValue:value animated:animated duration:duration completion:nil];
}

/**
 * Update gauge value with animation, duration and fire a completion block
 */
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
  /*
  if ( _value == value && !completion )
    return;
   */
  [self updateValue:value];

  /*
    animationCompletion = completion;
    
    double lastValue = _value;
    
    [self updateValue:value];
    double middleValue = lastValue + (((lastValue + (_value - lastValue) / 2.0) >= 0) ? (_value - lastValue) / 2.0 : (lastValue - _value) / 2.0);
    
  
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    animation.duration = animated ? duration : 0.0;
    animation.delegate = self;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:lastValue]  , 0, 0, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:middleValue], 0, 0, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:_value]     , 0, 0, 1.0)]];
    
    if ([_style conformsToProtocol:@protocol(WMGaugeViewStyle)] == NO || [_style needleLayer:rootNeedleLayer willMoveAnimated:animated duration:duration animation:animation] == NO)
    {
        rootNeedleLayer.transform = [[animation.values lastObject] CATransform3DValue];
        [rootNeedleLayer addAnimation:animation forKey:kCATransition];
    }
   */
}


- (void)setSecondValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
  [self updateSecondValue:value];
}

- (void)setThirdValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
  [self updateThirdValue:value];
}


#pragma mark - CAAnimation delegate

/*
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (animationCompletion)
        animationCompletion(flag);
    
    animationCompletion = nil;
}
 */

#pragma mark - Properties

- (void)setValue:(float)value
{
    [self setValue:value animated:YES];
}

- (void)setShowInnerBackground:(bool)showInnerBackground
{
    self.config.showInnerBackground = showInnerBackground;
    [self invalidateBackground];
}

- (void)setShowInnerRim:(bool)showInnerRim
{
    self.config.showInnerRim = showInnerRim;
    [self invalidateBackground];
}

- (void)setInnerRimWidth:(CGFloat)innerRimWidth
{
    self.config.innerRimWidth = innerRimWidth;
    [self invalidateBackground];
}

- (void)setInnerRimBordeWidth:(CGFloat)innerRimBorderWidth
{
    self.config.innerRimBorderWidth = innerRimBorderWidth;
    [self invalidateBackground];
}

- (void)setScalePosition:(CGFloat)scalePosition
{
    self.config.scalePosition = scalePosition;
    [self invalidateBackground];
}

- (void)setScaleStartAngle:(CGFloat)scaleStartAngle
{
    self.config.scaleStartAngle = scaleStartAngle;
    [self invalidateBackground];
}

- (void)setScaleEndAngle:(CGFloat)scaleEndAngle
{
    self.config.scaleEndAngle = scaleEndAngle;
    [self invalidateBackground];
}

- (void)setScaleDivisions:(CGFloat)scaleDivisions
{
    self.config.scaleDivisions = scaleDivisions;
    [self invalidateBackground];
}

- (void)setScaleSubdivisions:(CGFloat)scaleSubdivisions
{
    self.config.scaleSubdivisions = scaleSubdivisions;
    [self invalidateBackground];
}

- (void)setShowScaleShadow:(bool)showScaleShadow
{
    self.config.showScaleShadow = showScaleShadow;
    [self invalidateBackground];
}

- (void)setShowScale:(bool)showScale
{
    self.config.showScale = showScale;
    [self invalidateBackground];
}

- (void)setScalesubdivisionsAligment:(GaugeConfigAlignment)scalesubdivisionsAligment
{
    self.config.scalesubdivisionsAligment = scalesubdivisionsAligment;
    [self invalidateBackground];
}

- (void)setScaleDivisionsLength:(CGFloat)scaleDivisionsLength
{
    self.config.scaleDivisionsLength = scaleDivisionsLength;
    [self invalidateBackground];
}

- (void)setScaleDivisionsWidth:(CGFloat)scaleDivisionsWidth
{
    self.config.scaleDivisionsWidth = scaleDivisionsWidth;
    [self invalidateBackground];
}

- (void)setScaleSubdivisionsLength:(CGFloat)scaleSubdivisionsLength
{
    self.config.scaleSubdivisionsLength = scaleSubdivisionsLength;
    [self invalidateBackground];
}

- (void)setScaleSubdivisionsWidth:(CGFloat)scaleSubdivisionsWidth
{
    self.config.scaleSubdivisionsWidth = scaleSubdivisionsWidth;
    [self invalidateBackground];
}

- (void)setScaleDivisionColor:(UIColor *)scaleDivisionColor
{
    self.config.scaleDivisionColor = scaleDivisionColor;
    [self invalidateBackground];
}

- (void)setScaleSubDivisionColor:(UIColor *)scaleSubDivisionColor
{
    self.config.scaleSubDivisionColor = scaleSubDivisionColor;
    [self invalidateBackground];
}

- (void)setScaleFont:(UIFont *)scaleFont
{
    self.config.scaleFont = scaleFont;
    [self invalidateBackground];
}

- (void)setRangeLabelsWidth:(CGFloat)rangeLabelsWidth
{
    self.config.rangeLabelsWidth = rangeLabelsWidth;
    [self invalidateBackground];
}

- (void)setMinValue:(float)minValue
{
    self.config.minValue = minValue;
    [self invalidateBackground];
}

- (void)setMaxValue:(float)maxValue
{
    self.config.maxValue = maxValue;
    [self invalidateBackground];
}

- (void)setRangeValues:(NSArray *)rangeValues
{
    self.config.rangeValues = rangeValues;
    [self invalidateBackground];
}

- (void)setRangeColors:(NSArray *)rangeColors
{
    self.config.rangeColors = rangeColors;
    [self invalidateBackground];
}

- (void)setRangeLabels:(NSArray *)rangeLabels
{
    self.config.rangeLabels = rangeLabels;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurement:(NSString *)unitOfMeasurement
{
    self.config.unitOfMeasurement = unitOfMeasurement;
    [self invalidateBackground];
}

- (void)setShowUnitOfMeasurement:(bool)showUnitOfMeasurement
{
    self.config.showUnitOfMeasurement = showUnitOfMeasurement;
    [self invalidateBackground];
}

- (void)setShowRangeLabels:(bool)showRangeLabels
{
    self.config.showRangeLabels = showRangeLabels;
    [self invalidateBackground];
}

- (void)setRangeLabelsFontKerning:(CGFloat)rangeLabelsFontKerning
{
    self.config.rangeLabelsFontKerning = rangeLabelsFontKerning;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurementFont:(UIFont *)unitOfMeasurementFont
{
    self.config.unitOfMeasurementFont = unitOfMeasurementFont;
    [self invalidateBackground];
}

- (void)setRangeLabelsFont:(UIFont *)rangeLabelsFont
{
    self.config.rangeLabelsFont = rangeLabelsFont;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurementVerticalOffset:(CGFloat)unitOfMeasurementVerticalOffset
{
    self.config.unitOfMeasurementVerticalOffset = unitOfMeasurementVerticalOffset;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurementColor:(UIColor *)unitOfMeasurementColor
{
    self.config.unitOfMeasurementColor = unitOfMeasurementColor;
    [self invalidateBackground];
}

- (void)setRangeLabelsFontColor:(UIColor *)rangeLabelsFontColor
{
    self.config.rangeLabelsFontColor = rangeLabelsFontColor;
    [self invalidateBackground];
}

- (void)setStyle:(id<WMWatchGaugeViewStyle>)style {
    _style = style;
    [self invalidateBackground];
    [self invalidateNeedle];
}

@end
