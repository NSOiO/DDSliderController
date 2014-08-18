DDSliderController
==================

similar with netease news and zhihu daily controller (类似与网易新闻和知乎日报的滑动控制器)


![input_bar](./gif/DDSilder.gif)


## Usage
==================
···
    DDSliderController *slider = [DDSliderController sharedController];
    LeftSideViewController *leftSideController = [[LeftSideViewController alloc] init];
    leftSideController.classNamesArray = @[@"MainViewController",
                                           @"TopicDailyController",
                                           @"MyCollectionController",
                                           @"APPRecommendController",
                                           @"SettingViewController"];
    
    slider.leftSideViewController = leftSideController;
    slider.sliderMode = NormalMode;
···
