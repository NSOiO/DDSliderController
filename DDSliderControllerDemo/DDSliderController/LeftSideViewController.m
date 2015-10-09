//
//  LeftSideViewController.m
//  DDSliderControllerDemo
//
//  Created by handaer on 14-8-13.
//
//

#import "LeftSideViewController.h"
#import "DDSliderController.h"
#import "ClassMode.h"

@interface LeftSideViewController ()


@end

@implementation LeftSideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.classNamesArray = @[@"MainViewController",@"LocalSourceViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


const int tagOffset = 1000;
- (IBAction)showViewControllerButtonClicked:(UIButton *)button
{
    DDSliderController *slider = [DDSliderController sharedController];
    NSInteger offset = button.tag - tagOffset;
    
    if (offset < self.classNamesArray.count) {
        ClassMode *mode = [[ClassMode alloc] initWithTitle:button.titleLabel.text className:self.classNamesArray[offset]];
        
        [slider showCenterControllerWithClassMode:mode];
    }
    
}

- (IBAction)modeSegmentedControll:(UISegmentedControl *)sender
{
    DDSliderController *slider = [DDSliderController sharedController];
    switch (sender.selectedSegmentIndex) {
        case 0:
            slider.sliderMode = NormalMode;
            break;
        case 1:
            slider.sliderMode = NetEaseMode;
            break;
        case 2:
            slider.sliderMode = ZhiHuMode;
        default:
            break;
    }
    
    [slider performSelector:@selector(closeSide)];
}

@end
