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
    ZhiHuMode
};

@interface DDSliderController : UIViewController

@property (assign, nonatomic) SliderMode sliderMode;


+(instancetype)sharedController;

@end
