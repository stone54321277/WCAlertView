//
//  WCAlertView.h
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

#import <UIKit/UIKit.h>

@class WCAlertView;

typedef enum {
    WCAlertViewStyleDefault = 0,
    WCAlertViewStyleWhite,
    WCAlertViewStyleWhiteHatched,
    WCAlertViewStyleBlack,
    WCAlertViewStyleBlackHatched,
    WCAlertViewStyleViolet,
    WCAlertViewStyleVioletHatched,
    WCAlertViewStyleCustomizationBlock,
} WCAlertViewStyle;


typedef void(^CustomizationBlock)(WCAlertView *alertView);


@interface WCAlertView : UIAlertView

@property (assign, nonatomic) WCAlertViewStyle style;

@property (strong, nonatomic) UIColor *labelTextColor;
@property (strong, nonatomic) UIColor *labelShadowColor;
@property (assign, nonatomic) CGSize labelShadowOffset;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *messageFont;

@property (strong, nonatomic) UIColor *buttonTextColor;
@property (strong, nonatomic) UIFont *buttonFont;
@property (strong, nonatomic) UIColor *buttonShadowColor;
@property (assign, nonatomic) CGSize buttonShadowOffset;
@property (assign, nonatomic) CGFloat buttonShadowBlur;

@property (strong, nonatomic) NSArray *gradientLocations;
@property (strong, nonatomic) NSArray *gradientColors;

@property (assign, nonatomic) CGFloat cornerRadius;

@property (strong, nonatomic) UIColor *innerFrameShadowColor;
@property (strong, nonatomic) UIColor *innerFrameStrokeColor;

@property (strong, nonatomic) UIColor *horizontalLineColor;

@property (strong, nonatomic) UIColor *hatchedLinesColor;
@property (strong, nonatomic) UIColor *hatchedBackgroundColor;

@property (strong, nonatomic) UIColor *outerFrameColor;
@property (assign, nonatomic) CGFloat outerFrameLineWidth;
@property (strong, nonatomic) UIColor *outerFrameShadowColor;
@property (assign, nonatomic) CGSize outerFrameShadowOffset;
@property (assign, nonatomic) CGFloat outerFrameShadowBlur;

#pragma mark - Class defaults
+ (void)setDefaultStyle:(WCAlertViewStyle)style;
+ (void)setDefaultCustomiaztonBlock:(CustomizationBlock)block;

#pragma mark - Initialization
+ (WCAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
                       delegate:(id<UIAlertViewDelegate>)del
              cancelButtonTitle:(NSString *)cancelButtonTitle
             customizationBlock:(void (^)(WCAlertView *alertView))customizationBlock
              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end