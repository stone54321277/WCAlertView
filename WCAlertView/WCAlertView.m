//
//  WCAlertView.m
//
//  Created by Michał Zaborowski on 18/07/12.
//  Copyright (c) 2012 Michał Zaborowski. All rights reserved.
//
//  https://github.com/m1entus/WCAlertView
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  -----------------------------------------
//  Edited and refactored by Jesse Squires on 13 April, 2013.
//
//  https://github.com/jessesquires/WCAlertView
//
//  http://hexedbits.com
//

#import "WCAlertView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface WCAlertView()

- (void)defaultStyle;
- (void)customizeAlertViewStyle:(WCAlertViewStyle)newStyle;
- (void)violetAlertHetched:(BOOL)hatched;
- (void)whiteAlertHatched:(BOOL)hatched;
- (void)blackAlertHatched:(BOOL)hatched;

- (void)drawGradientWithContext:(CGContextRef)context activeBounds:(CGRect)activeBounds;
- (void)drawHatchedBackgroundWithContext:(CGContextRef)context buttonOffset:(CGFloat)buttonOffset activeBounds:(CGRect)activeBounds;
- (void)drawHorizontalLineWithContext:(CGContextRef)context buttonOffset:(CGFloat)buttonOffset activeBounds:(CGRect)activeBounds;
- (void)strokeOuterFrameWithContext:(CGContextRef)context path:(CGPathRef)path;
- (void)drawButtonLabelsWithContext:(CGContextRef)context;

@end



@implementation WCAlertView

@synthesize style;

static WCAlertViewStyle kDefaultAlertStyle = WCAlertViewStyleDefault;
static CustomizationBlock kDefauldCustomizationBlock = nil;

#pragma mark - Class defaults
+ (void)setDefaultStyle:(WCAlertViewStyle)style
{
    kDefaultAlertStyle = style;
}

+ (void)setDefaultCustomiaztonBlock:(CustomizationBlock)block
{
    kDefauldCustomizationBlock = block;
}

#pragma mark - Initialization
+ (WCAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
                       delegate:(id<UIAlertViewDelegate>)del
              cancelButtonTitle:(NSString *)cancelButtonTitle
             customizationBlock:(void (^)(WCAlertView *alertView))customizationBlock
              otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    WCAlertView *alertView = [[self alloc] initWithTitle:title
                                                  message:message
                                                 delegate:del
                                        cancelButtonTitle:cancelButtonTitle
                                        otherButtonTitles:nil];
    
    if(otherButtonTitles) {
        [alertView addButtonWithTitle:otherButtonTitles];
        
        id eachObject;
        va_list argumentList;
        
        va_start(argumentList, otherButtonTitles);
        while ((eachObject = va_arg(argumentList, id))) {
            [alertView addButtonWithTitle:eachObject];
        }
        va_end(argumentList);
    }
    
	if(cancelButtonTitle) {
		alertView.cancelButtonIndex = alertView.numberOfButtons - 1;
	}
    
    if(customizationBlock) {
        customizationBlock(alertView);
    }
    
    return alertView;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)del
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title
                        message:message
                       delegate:del
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:nil];
    
    if(self) {
        [self defaultStyle];
        
        if(kDefauldCustomizationBlock) {
            self.style = WCAlertViewStyleCustomizationBlock;
        }
        
        va_list args;
        va_start(args, otherButtonTitles);
        for(NSString *anOtherButtonTitle = otherButtonTitles; anOtherButtonTitle != nil; anOtherButtonTitle = va_arg(args, NSString*)) {
            [self addButtonWithTitle:anOtherButtonTitle];
        }
    }
    
    return self;
}

#pragma mark - Setters
- (void)setStyle:(WCAlertViewStyle)newStyle
{
    if(style != newStyle) {
        style = newStyle;
        [self customizeAlertViewStyle:newStyle];
    }
}

#pragma mark - Appearance
- (void)defaultStyle
{
    self.buttonShadowBlur = 2.0f;
    self.buttonShadowOffset = CGSizeMake(0.5f, 0.5f);
    self.labelShadowOffset = CGSizeMake(0.0f, 1.0f);
    self.gradientLocations = @[ @0.0f, @0.57f, @1.0f];
    self.cornerRadius = 10.0f;
    self.labelTextColor = [UIColor whiteColor];
    self.outerFrameLineWidth = 2.0f;
    self.outerFrameShadowBlur = 6.0f;
    self.outerFrameShadowColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    self.outerFrameShadowOffset = CGSizeMake(0.0f, 1.0f);
    self.style = kDefaultAlertStyle;
}

- (void)customizeAlertViewStyle:(WCAlertViewStyle)newStyle
{
    switch (newStyle) {
        case WCAlertViewStyleWhite:
            [self whiteAlertHatched:NO];
            break;
        case WCAlertViewStyleWhiteHatched:
            [self whiteAlertHatched:YES];
            break;
        case WCAlertViewStyleBlack:
            [self blackAlertHatched:NO];
            break;
        case WCAlertViewStyleBlackHatched:
            [self blackAlertHatched:YES];
            break;
        case WCAlertViewStyleViolet:
            [self violetAlertHetched:NO];
            break;
        case WCAlertViewStyleVioletHatched:
            [self violetAlertHetched:YES];
            break;
        case WCAlertViewStyleCustomizationBlock:
            if(kDefauldCustomizationBlock) {
                kDefauldCustomizationBlock(self);
            }
            break;
        case WCAlertViewStyleDefault:
            default:
            break;
    }
}

- (void)violetAlertHetched:(BOOL)hatched
{
    self.labelTextColor = [UIColor whiteColor];
    self.labelShadowColor = [UIColor colorWithRed:0.004f green:0.003f blue:0.006f alpha:0.70f];
    
    UIColor *topGradient = [UIColor colorWithRed:0.66f green:0.63f blue:1.00f alpha:1.00f];
    UIColor *middleGradient = [UIColor colorWithRed:0.508f green:0.498f blue:0.812f alpha:1.0f];
    UIColor *bottomGradient = [UIColor colorWithRed:0.419f green:0.405f blue:0.654f alpha:1.0f];
    self.gradientColors = [NSArray arrayWithObjects:topGradient, middleGradient, bottomGradient, nil];
    
    self.outerFrameColor = [UIColor whiteColor];
    self.innerFrameStrokeColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.41f alpha:1.00f];
    self.innerFrameShadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
    
    self.buttonTextColor = [UIColor whiteColor];
    self.buttonShadowBlur = 2.0f;
    self.buttonShadowColor = [UIColor colorWithRed:0.004f green:0.003f blue:0.006f alpha:1.0f];
    
    if(hatched) {
        self.outerFrameColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.41f alpha:1.00f];
        self.outerFrameShadowOffset = CGSizeMake(0.0f, 0.0f);
        self.outerFrameShadowBlur = 0.0f;
        self.outerFrameShadowColor = [UIColor clearColor];
        self.outerFrameLineWidth = 0.5f;
        self.horizontalLineColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
        self.hatchedLinesColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
    }
}

- (void)whiteAlertHatched:(BOOL)hatched
{
    self.labelTextColor = [UIColor colorWithRed:0.11f green:0.08f blue:0.39f alpha:1.00f];
    self.labelShadowColor = [UIColor whiteColor];
    
    UIColor *topGradient = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    UIColor *middleGradient = [UIColor colorWithRed:0.93f green:0.94f blue:0.96f alpha:1.0f];
    UIColor *bottomGradient = [UIColor colorWithRed:0.89f green:0.89f blue:0.92f alpha:1.00f];
    self.gradientColors = [NSArray arrayWithObjects:topGradient, middleGradient, bottomGradient, nil];
    
    self.outerFrameColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
    
    self.buttonTextColor = [UIColor colorWithRed:0.11f green:0.08f blue:0.39f alpha:1.00f];
    self.buttonShadowColor = [UIColor whiteColor];
    
    if(hatched) {
        self.horizontalLineColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
        self.hatchedLinesColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
    }
}

- (void)blackAlertHatched:(BOOL)hatched
{
    self.labelTextColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
    self.labelShadowColor = [UIColor blackColor];
    self.labelShadowOffset = CGSizeMake(0.0f, 1.0f);
    
    UIColor *topGradient = [UIColor colorWithRed:0.27f green:0.27f blue:0.27f alpha:1.0f];
    UIColor *middleGradient = [UIColor colorWithRed:0.21f green:0.21f blue:0.21f alpha:1.0f];
    UIColor *bottomGradient = [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f];
    self.gradientColors = [NSArray arrayWithObjects:topGradient, middleGradient, bottomGradient, nil];
    
    self.outerFrameColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
    
    self.buttonTextColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
    self.buttonShadowColor = [UIColor blackColor];
    
    if(hatched) {
        self.horizontalLineColor = [UIColor blackColor];
        self.innerFrameShadowColor = [UIColor blackColor];
        self.hatchedLinesColor = [UIColor blackColor];
    }
}

#pragma mark - View layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(!self.style)
        return;
    
    for (UIView *subview in self.subviews) {
        
        if([subview isMemberOfClass:[UIImageView class]]) { // find and hide UIImageView containing blue background
            if(subview.frame.origin.x == 0 || subview.frame.origin.y == 0) { // prevent hiding UITextFiled for UIAlertViewStyleLoginAndPasswordInput
                subview.hidden = YES;
            }
        }
        else if([subview isMemberOfClass:[UILabel class]]) { // find and get styles of UILabels
            UILabel *label = (UILabel *)subview;	
            label.textColor = self.labelTextColor;
            label.shadowColor = self.labelShadowColor;
            label.shadowOffset = self.labelShadowOffset;
            
            if(self.titleFont && [label.text isEqualToString:self.title]) {
                label.font = self.titleFont;
            }
            
            if(self.messageFont && [label.text isEqualToString:self.message]) {
                label.font = self.messageFont;
            }
        }
        else if([subview isKindOfClass:[UIButton class]]) { // hide button title labels
            ((UIButton *)subview).titleLabel.alpha = 0.0f;
        }
    }
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect 
{
    [super drawRect:rect];
    
    if(!self.style)
        return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // create base shape with rounded corners from bounds
    CGRect activeBounds = self.bounds;
    CGFloat cornerRadius = self.cornerRadius;
    CGFloat inset = 5.5f;
    CGFloat originX = activeBounds.origin.x + inset;
    CGFloat originY = activeBounds.origin.y + inset;
    CGFloat width = activeBounds.size.width - (inset * 2.0f);
    CGFloat height = activeBounds.size.height - ((inset + 2.0) * 2.0f);
    
    CGFloat buttonOffset = self.bounds.size.height - 50.5f;
    
    CGRect bPathFrame = CGRectMake(originX, originY, width, height);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:bPathFrame cornerRadius:cornerRadius].CGPath;
    
    // create base shape with fill and shadow
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
    CGContextSetShadowWithColor(context, self.outerFrameShadowOffset, self.outerFrameShadowBlur, self.outerFrameShadowColor.CGColor);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    [self drawGradientWithContext:context activeBounds:activeBounds];
    
    if(self.hatchedLinesColor || self.hatchedBackgroundColor) {
        CGContextSaveGState(context);
        [self drawHatchedBackgroundWithContext:context buttonOffset:buttonOffset activeBounds:activeBounds];
        CGContextRestoreGState(context);
    }
    
    if(self.horizontalLineColor) {
        [self drawHorizontalLineWithContext:context buttonOffset:buttonOffset activeBounds:activeBounds];
    }
    
    if(self.innerFrameShadowColor || self.innerFrameStrokeColor) {
        [self strokeInnerFrameWithContext:context path:path];
    }
    
    CGContextRestoreGState(context);
    
    [self strokeOuterFrameWithContext:context path:path];
    
    [self drawButtonLabelsWithContext:context];
}

- (void)drawGradientWithContext:(CGContextRef)context activeBounds:(CGRect)activeBounds
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t count = [self.gradientLocations count];
    
    CGFloat *locations = malloc(count * sizeof(CGFloat));
    [self.gradientLocations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        locations[idx] = [((NSNumber *)obj) floatValue];
    }];
    
    CGFloat *components = malloc([self.gradientColors count] * 4 * sizeof(CGFloat));
    
    [self.gradientColors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIColor *color = (UIColor *)obj;
        
        NSInteger startIndex = (idx * 4);
        
        if([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
            [color getRed:&components[startIndex]
                    green:&components[startIndex + 1]
                     blue:&components[startIndex + 2]
                    alpha:&components[startIndex + 3]];
        }
        else {
            const CGFloat *colorComponent = CGColorGetComponents(color.CGColor);
            components[startIndex] = colorComponent[0];
            components[startIndex + 1] = colorComponent[1];
            components[startIndex + 2] = colorComponent[2];
            components[startIndex + 3] = colorComponent[3];
        }
    }];
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
    CGPoint startPoint = CGPointMake(activeBounds.size.width * 0.5f, 0.0f);
    CGPoint endPoint = CGPointMake(activeBounds.size.width * 0.5f, activeBounds.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0.0f);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    free(locations);
    free(components);
}

- (void)drawHatchedBackgroundWithContext:(CGContextRef)context buttonOffset:(CGFloat)buttonOffset activeBounds:(CGRect)activeBounds
{
    CGRect hatchFrame = CGRectMake(0.0f,
                                   buttonOffset - 15.0f,
                                   activeBounds.size.width,
                                   (activeBounds.size.height - buttonOffset + 1.0f) + 15.0f);
    CGContextClipToRect(context, hatchFrame);
    
    if(self.hatchedBackgroundColor) {
        CGFloat red,green,blue,alpha;
        
        if([self.hatchedBackgroundColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
            [self.hatchedBackgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
        }
        else {
            const CGFloat *colorComponent = CGColorGetComponents(self.hatchedBackgroundColor.CGColor);
            red = colorComponent[0];
            green = colorComponent[1];
            blue = colorComponent[2];
            alpha = colorComponent[3];
        }
        
        CGContextSetRGBFillColor(context, red,green, blue, alpha);
        CGContextFillRect(context, hatchFrame);
    }
    
    if(self.hatchedLinesColor) {
        CGFloat spacer = 4.0f;
        int rows = (activeBounds.size.width + activeBounds.size.height/spacer);
        CGFloat padding = 0.0f;
        CGMutablePathRef hatchPath = CGPathCreateMutable();
        
        for(int i = 1; i <= rows; i++) {
            CGPathMoveToPoint(hatchPath, NULL, spacer * i, padding);
            CGPathAddLineToPoint(hatchPath, NULL, padding, spacer * i);
        }
        
        CGContextAddPath(context, hatchPath);
        CGPathRelease(hatchPath);
        
        CGContextSetLineWidth(context, 1.0f);
        CGContextSetLineCap(context, kCGLineCapButt);
        CGContextSetStrokeColorWithColor(context, self.hatchedLinesColor.CGColor);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)drawHorizontalLineWithContext:(CGContextRef)context buttonOffset:(CGFloat)buttonOffset activeBounds:(CGRect)activeBounds
{
    CGMutablePathRef linePath = CGPathCreateMutable();
    CGFloat linePathY = (buttonOffset - 1.0f) - 15.0f;
    CGPathMoveToPoint(linePath, NULL, 0.0f, linePathY);
    CGPathAddLineToPoint(linePath, NULL, activeBounds.size.width, linePathY);
    CGContextAddPath(context, linePath);
    CGPathRelease(linePath);
    CGContextSetLineWidth(context, 1.0f);
    
    CGContextSaveGState(context);
    
    CGContextSetStrokeColorWithColor(context, self.horizontalLineColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 0.0f, [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.2f].CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}

- (void)strokeInnerFrameWithContext:(CGContextRef)context path:(CGPathRef)path
{
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, 3.0f);
    
    if (self.innerFrameStrokeColor) {
        CGContextSetStrokeColorWithColor(context, self.innerFrameStrokeColor.CGColor);
    }
    if (self.innerFrameShadowColor) {
        CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 6.0f, self.innerFrameShadowColor.CGColor);
    }
    
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)strokeOuterFrameWithContext:(CGContextRef)context path:(CGPathRef)path
{
    // stroke path to cover up pixialation on corners from clipping
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, self.outerFrameLineWidth);
    CGContextSetStrokeColorWithColor(context, self.outerFrameColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 0.0f, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.1f].CGColor);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)drawButtonLabelsWithContext:(CGContextRef)context
{
    for (UIView *subview in self.subviews){
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            
            CGContextSetTextDrawingMode(context, kCGTextFill);
            CGContextSetFillColorWithColor(context, self.buttonTextColor.CGColor);
            CGContextSetShadowWithColor(context, self.buttonShadowOffset, self.buttonShadowBlur, self.buttonShadowColor.CGColor);
            
            UIFont *btnFont = button.titleLabel.font;
            if(self.buttonFont)
                btnFont = self.buttonFont;
            
            // Calculate the font size to make sure large text is rendered correctly
            CGFloat neededFontSize;
            [button.titleLabel.text sizeWithFont:btnFont
                                     minFontSize:8.0f
                                  actualFontSize:&neededFontSize
                                        forWidth:button.frame.size.width - 6.0f
                                   lineBreakMode:NSLineBreakByWordWrapping];
            
            if (neededFontSize < btnFont.pointSize) {
                btnFont = [UIFont fontWithName:btnFont.fontName
                                          size:neededFontSize];
            }
            
            [button.titleLabel.text drawInRect:CGRectMake(button.frame.origin.x,
                                                          button.frame.origin.y + 10.0f,
                                                          button.frame.size.width,
                                                          button.frame.size.height - 10.0f)
                                      withFont:btnFont
                                 lineBreakMode:NSLineBreakByWordWrapping
                                     alignment:NSTextAlignmentCenter];
        }
    }
}

@end