//
//  BaseCenterViewController.h
//  DDSliderControllerDemo
//
//  Created by handaer on 14-8-13.
//
//

#import <UIKit/UIKit.h>

@protocol BaseCenterDelegate <NSObject>

- (void)leftButtonClicked:(UIButton *)button;
//- (void)rightButtonClicked:(UIButton *)button;

@end

@interface BaseCenterViewController : UIViewController

@property (weak, nonatomic) id <BaseCenterDelegate>delegate;

@end


