#WCAlertView 2.0

A highly customizable subclass of UIAlertView.

Forked from [m1entus / WCAlertView](https://github.com/m1entus/WCAlertView) and refactored.

![WCAlertView Screenshot 1][img1] &nbsp;&nbsp;&nbsp;&nbsp; ![WCAlertView Screenshot 2][img2]

### Notable changes

* iOS 6.0+
* Removed completion block in favor of inheriting `UIAlertViewDelegate` functionality directly from `UIAlertView`
* A more 'proper' subclass of `UIAlertView`
* Refactored to be much cleaner, better organized
* New/improved demo project

## Installation

### From [CocoaPods](http://www.cocoapods.org)

    pod `WCAlertView`

### From Source

* Drag the `WCAlertView/` folder to your project (make sure you copy all files/folders)
* `#import "WCAlertView.h"`

## How To Use

Use provided WCAlertViewStyle or customize your own

* `WCAlertViewStyleDefault`
* `WCAlertViewStyleWhite`
* `WCAlertViewStyleWhiteHatched`
* `WCAlertViewStyleBlack`
* `WCAlertViewStyleBlackHatched`
* `WCAlertViewStyleViolet`
* `WCAlertViewStyleVioletHatched`
* `WCAlertViewStyleCustomizationBlock`

Set default style or customization for all `WCAlertView` with the following class methods

* `+ (void)setDefaultStyle:(WCAlertViewStyle)style`
* `+ (void)setDefaultCustomiaztonBlock:(CustomizationBlock)block`
* See appearance methods in `WCAlertView.m` for examples of how to customize (e.g. `- (void)violetAlertHetched:(BOOL)hatched`)

Show an alert:

``` objective-c

    WCAlertView *alert = [WCAlertView alertWithTitle:@"Alert Title"
                                             message:@"This is a message body. This is a message body."
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                                  customizationBlock:^(WCAlertView *alertView) {
                                      
                                      // customize here
                                      alertView.style = WCAlertViewStyleWhiteHatched
                                  }
                                   otherButtonTitles:@"Other1", @"Other2", nil];
    
    [alert show];

````

Implement the [UIAlertViewDelegate Protocol](http://developer.apple.com/library/ios/#documentation/uikit/reference/UIAlertViewDelegate_Protocol/UIAlertViewDelegate/UIAlertViewDelegate.html) methods

**See the included demo project `WCAlertViewDemo.xcodeproj`**

## [MIT License](http://opensource.org/licenses/MIT)

Edited and refactored by Jesse Squires, April 2013.

Copyright &copy; 2012 Michal Zaborowski

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Credits

Forked from [Michal Zaborowski](http://github.com/m1entus) 

Inspired by [Aaron Crabtree - UIAlertView Custom Graphics](http://mobile.tutsplus.com), borrowing some general approaches in drawing `UIAlertView`.

Simple block extension got from [wannabegeek](http://github.com/wannabegeek/UIAlertViewExtentsions).

[img1]:https://raw.github.com/jessesquires/WCAlertView/master/Screenshots/screenshot1.png
[img2]:https://raw.github.com/jessesquires/WCAlertView/master/Screenshots/screenshot2.png
