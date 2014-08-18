//
//  BaseCenterViewController.m
//  DDSliderControllerDemo
//
//  Created by handaer on 14-8-13.
//
//

#import "BaseCenterViewController.h"

@interface BaseCenterViewController ()

@end

@implementation BaseCenterViewController

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
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.bounds = CGRectMake(0, 0, 44, 44);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"top_navigation_menuicon.png"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"top_navigation_menuicon_highlighted.png"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.bounds = CGRectMake(0, 0, 44, 44);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_navigation_infoicon"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_navigation_infoicon_highlighted"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    //self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)leftItemClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(leftButtonClicked:)]) {
        [self.delegate leftButtonClicked:button];
    }
}

- (void)rightItemClick:(UIButton *)button{
    /*
    if ([self.delegate respondsToSelector:@selector(rightButtonClicked:)]) {
        [self.delegate rightButtonClicked:button];
    }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
