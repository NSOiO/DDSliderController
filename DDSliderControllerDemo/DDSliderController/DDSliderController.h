//
//  DDSliderController.h
//  DDSliderControllerDemo
//
//  Created by handaer on 14-8-13.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SliderMode) {
    NetEaseMode = 0,
    ZhiHuMode,
    NormalMode
};

@class ClassMode;
@interface DDSliderController : UIViewController

@property (assign, nonatomic) SliderMode sliderMode;
@property (strong, nonatomic) UIViewController *leftSideViewController;
@property (strong, nonatomic) ClassMode *mainClassMode;

+(instancetype)sharedController;
- (void)showCenterControllerWithClassMode:(ClassMode *)mode;

@end

