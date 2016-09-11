//
//  WMGaugeViewStyleFlatThin.m
//  WMGaugeView
//
//  Created by Markezana, William on 25/10/15.
//  Copyright © 2015 Will™. All rights reserved.
//

#import "WMWatchGaugeViewStyleFlatThin.h"

#define kNeedleWidth        0.012
#define kNeedleHeight       0.4
#define kNeedleScrewRadius  0.05

#define kCenterX            0.5
#define kCenterY            0.5

#define kNeedleColor        CGRGB(255, 104, 97)
#define kNeedleScrewColor   CGRGB(68, 84, 105)

@interface WMWatchGaugeViewStyleFlatThin ()

//@property (nonatomic) CAShapeLayer *needleLayer;

@end

@implementation WMWatchGaugeViewStyleFlatThin

- (void)drawNeedleInRect:(CGRect)rect
				   color:(UIColor *)color
				 atAngle:(CGFloat)angle
				 inContext:(CGContextRef)context
{
  CGContextSaveGState(context);
  
  CGContextTranslateCTM(context, rect.size.width/2, rect.size.height/2);
  CGContextRotateCTM(context, angle);
  CGContextTranslateCTM(context, -(rect.size.width/2), -(rect.size.height/2));

  /*
  [self rotateContext:context fromCenter:center withAngle:DEGREES_TO_RADIANS(90 + _scaleStartAngle)];
   */
  //CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 0.0);

  
  UIBezierPath *needlePath = [UIBezierPath bezierPath];
  [needlePath moveToPoint:CGPointMake(FULLSCALE(kCenterX - kNeedleWidth, kCenterY))];
  [needlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX + kNeedleWidth, kCenterY))];
  [needlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY - kNeedleHeight))];
  [needlePath closePath];

  if ( color == nil )
	color = [UIColor redColor];
  
  [color setFill];
  [color setStroke];
  
  needlePath.lineWidth = 1.2;
  
  [needlePath fill];
  [needlePath stroke];

  UIBezierPath *screwPath =
  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(FULLSCALE(kCenterX - kNeedleScrewRadius, kCenterY - kNeedleScrewRadius), FULLSCALE(kNeedleScrewRadius * 2.0, kNeedleScrewRadius * 2.0))];
  
  UIColor *scolor = [UIColor colorWithCGColor:kNeedleScrewColor];
  [scolor setFill];
  [screwPath fill];

  CGContextRestoreGState(context);
}

- (void)drawFaceWithContext:(CGContextRef)context inRect:(CGRect)rect
{
#define EXTERNAL_RING_RADIUS    0.24
#define INTERNAL_RING_RADIUS    0.1
    /*
    // External circle
    CGContextAddEllipseInRect(context, CGRectMake(kCenterX - EXTERNAL_RING_RADIUS, kCenterY - EXTERNAL_RING_RADIUS, EXTERNAL_RING_RADIUS * 2.0, EXTERNAL_RING_RADIUS * 2.0));
    CGContextSetFillColorWithColor(context, CGRGB(255, 104, 97));
    CGContextFillPath(context);
    // Inner circle
    CGContextAddEllipseInRect(context, CGRectMake(kCenterX - INTERNAL_RING_RADIUS, kCenterY - INTERNAL_RING_RADIUS, INTERNAL_RING_RADIUS * 2.0, INTERNAL_RING_RADIUS * 2.0));
    CGContextSetFillColorWithColor(context, CGRGB(242, 99, 92));
    CGContextFillPath(context);
	 */

}
/*
- (BOOL)needleLayer:(CALayer*)layer willMoveAnimated:(BOOL)animated duration:(NSTimeInterval)duration animation:(CAKeyframeAnimation*)animation
{
    layer.transform = [[animation.values objectAtIndex:0] CATransform3DValue];
    CGAffineTransform affineTransform1 = [layer affineTransform];
    layer.transform = [[animation.values objectAtIndex:1] CATransform3DValue];
    CGAffineTransform affineTransform2 = [layer affineTransform];
    layer.transform = [[animation.values lastObject] CATransform3DValue];
    CGAffineTransform affineTransform3 = [layer affineTransform];
    
    _needleLayer.shadowOffset = CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform3);
    
    [layer addAnimation:animation forKey:kCATransition];
    
    CAKeyframeAnimation * animationShadowOffset = [CAKeyframeAnimation animationWithKeyPath:@"shadowOffset"];
    animationShadowOffset.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationShadowOffset.removedOnCompletion = YES;
    animationShadowOffset.duration = animated ? duration : 0.0;
    animationShadowOffset.values = @[[NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform1)],
                                     [NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform2)],
                                     [NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform3)]];
    [_needleLayer addAnimation:animationShadowOffset forKey:kCATransition];
    
    return YES;
}
*/
@end
