//
//  DDSliderController.m
//  DDSliderControllerDemo
//
//  Created by handaer on 14-8-13.
//
//

#import "DDSliderController.h"
#import "LeftSideViewController.h"
#import "ClassMode.h"
#import "BaseNavigationController.h"
#import "BaseCenterViewController.h"

#define DCloseDuration 0.3f
#define DOpenDuration 0.4f
#define DContentScale 0.83f
#define DContentOffset 220.0f
#define DZhiHuContentOffset 150.0f
#define DJudgeOffset 100.0f

typedef NS_ENUM(NSInteger, DMoveDirection) {
    DMoveDirectionLeft = 0,
    DMoveDirectionRight
};

@interface DDSliderController ()<BaseCenterDelegate>

@property (strong, nonatomic) UIView *leftSideView;
@property (strong, nonatomic) UIView *centerView;
@property (strong, nonatomic) UIViewController *currentViewController;

@property (strong, nonatomic) NSMutableDictionary *controllersDic;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation DDSliderController

#pragma mark -
#pragma mark controller init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        //init property
        _controllersDic = [NSMutableDictionary dictionary];
        _sliderMode = NormalMode;
    }
    
    return self;
}

+(instancetype)sharedController
{
    static DDSliderController * controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    return controller;
}

#pragma mark -
#pragma mark lazy init

- (UIView *)centerView
{
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:self.view.frame];
        _centerView.backgroundColor = [UIColor clearColor];
    }
    return _centerView;
}

- (UIViewController *)leftSideViewController
{
    if (!_leftSideViewController) {
        _leftSideViewController = [[UIViewController alloc] init];
    }
    return _leftSideViewController;
}

- (ClassMode *)mainClassMode
{
    if (!_mainClassMode) {
        _mainClassMode = [[ClassMode alloc] initWithTitle:@"Main" className:@"BaseCenterViewController"];
    }
    return _mainClassMode;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_navigation_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    // init gestrue
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureCallBack:)];
    self.tapGestureRecognizer.enabled = NO;
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallBack:)];
    
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    // init subleftcontroller and show main controller
    [self initSubController];
    NSArray *arr = ((LeftSideViewController *)self.leftSideViewController).classNamesArray;
    if (arr.count > 0) {
        self.mainClassMode = [[ClassMode alloc] initWithTitle:@"首页" className:arr[0]];
    }
    [self showCenterControllerWithClassMode:self.mainClassMode];
}

- (void)initSubController
{
    [self addChildViewController:self.leftSideViewController];
    self.leftSideView = self.leftSideViewController.view;
    [self.view addSubview:self.leftSideView];
    
    [self.view addSubview:self.centerView];
}


- (void)closeSide
{
    if (self.sliderMode == NetEaseMode || self.sliderMode == NormalMode) {
        CGAffineTransform oriT = CGAffineTransformIdentity;
        [UIView animateWithDuration:DCloseDuration
                         animations:^{
                             self.centerView.transform = oriT;
                         }
                         completion:^(BOOL finished) {
                             self.tapGestureRecognizer.enabled = NO;
                         }];
        
    } //end NetEaseMode || NormalMode
    
    else if (self.sliderMode == ZhiHuMode){

        CATransform3D oriT = CATransform3DIdentity;
        [UIView animateWithDuration:DCloseDuration animations:^{
            self.centerView.layer.transform = oriT;
        }completion:^(BOOL finished){
            self.tapGestureRecognizer.enabled = NO;
        }];
        
    } //end ZhiHuMode
}

- (void)showCenterControllerWithClassMode:(ClassMode *)mode
{
    UIViewController *viewController = self.controllersDic[mode.className];
    
    //lazy init controller
    if (!viewController) {
        Class cs = NSClassFromString(mode.className);
        BaseCenterViewController *vc = [[cs alloc] init];
        vc.title = mode.title;
        vc.delegate = self;

        viewController = [[BaseNavigationController alloc] initWithRootViewController:vc];
        
        [self.controllersDic setObject:viewController forKey:mode.className];
    } else {
        //if viewController is on show,close side directly
        if (viewController == self.currentViewController) {
            NSLog(@"show the same,close directly");
            [self closeSide];
            return;
        }
    }
    
    NSArray *arr = self.view.subviews;
    NSLog(@"arr are %@",arr);
    //1. remove currentController and view
    if (self.currentViewController) {
        [self.currentViewController removeFromParentViewController];
    }
    
    if (self.centerView.subviews.count) {
        [[self.centerView.subviews lastObject] removeFromSuperview];
    }
    
    //2. add subview and child controller
    [self addChildViewController:viewController];
    [self.centerView addSubview:viewController.view];
    
    self.currentViewController = viewController;
    //self.centerView = viewController.view;
    
    //3.complete add
    [self.currentViewController.view didMoveToSuperview];
    [self.currentViewController didMoveToParentViewController:self];
    
    [self closeSide];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark gesture

- (void)tapGestureCallBack:(UITapGestureRecognizer *)tap
{
    [self closeSide];
}

- (void)panGestureCallBack:(UIPanGestureRecognizer *)pan
{
    if (self.sliderMode == NetEaseMode || self.sliderMode == NormalMode) {
        [self moveViewInNetEaseModeWithPanGesture:pan];
    } else if (self.sliderMode == ZhiHuMode){
        [self moveViewInZhiHuModeWithPanGesture:pan];
    }
}

- (void)moveViewInNetEaseModeWithPanGesture:(UIPanGestureRecognizer *)pan
{
    static CGFloat currentTranslateX;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        currentTranslateX = self.centerView.transform.tx;
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat transX = [pan translationInView:self.centerView].x;
        transX = transX + currentTranslateX;
       
        
        CGFloat sca;
        if (transX > 0) {
            if (self.centerView.frame.origin.x < DContentOffset) {
                sca = 1 - (self.centerView.frame.origin.x/DContentOffset) * (1-DContentScale);
            }
            else {
                sca = DContentScale;
            }
        }
        else {    //transX < 0
            return;
        }
        CGAffineTransform transS = CGAffineTransformMakeScale(sca, sca);
        CGAffineTransform transT = CGAffineTransformMakeTranslation(transX, 0);

        CGAffineTransform conT = CGAffineTransformConcat(transT, transS);
        if (self.sliderMode == NormalMode) {
            conT = transT;
        }
        
        self.centerView.transform = conT;
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat panX = [pan translationInView:self.centerView].x;
        CGFloat finalX = currentTranslateX + panX;
        if (finalX > DJudgeOffset) {
            
            CGAffineTransform conT = [self transformWithDirection:DMoveDirectionRight andSliderMode:self.sliderMode];
            [UIView beginAnimations:nil context:nil];
            self.centerView.transform = conT;
            [UIView commitAnimations];
            
            self.tapGestureRecognizer.enabled = YES;
            return;
        }
        if (finalX < -DJudgeOffset) {
            return;
            CGAffineTransform conT = [self transformWithDirection:DMoveDirectionLeft andSliderMode:self.sliderMode];
            [UIView beginAnimations:nil context:nil];
            self.centerView.transform = conT;
            [UIView commitAnimations];
            
            self.tapGestureRecognizer.enabled = YES;
            return;
        }
        else {
            CGAffineTransform oriT = CGAffineTransformIdentity;
            [UIView beginAnimations:nil context:nil];
            self.centerView.transform = oriT;
            [UIView commitAnimations];
            
            self.tapGestureRecognizer.enabled = NO;
        }
    }
}

- (void)moveViewInZhiHuModeWithPanGesture:(UIPanGestureRecognizer *)pan{
    //[self moveViewInNetEaseModeWithPanGesture:pan];
    static CGFloat currentTranslateX;
    if (pan.state == UIGestureRecognizerStateBegan) {
        currentTranslateX = self.centerView.layer.transform.m41;
    }
    
    else if (pan.state == UIGestureRecognizerStateChanged){
        
        CATransform3D contentTransform;
        contentTransform = CATransform3DIdentity;
        contentTransform.m34 = -1.0f / 800.0f;
        self.centerView.layer.zPosition = 100;
        
        //not self.centerView
        CGFloat transX = [pan translationInView:self.view].x;
        transX = transX + currentTranslateX;
        CGFloat ss = transX / DZhiHuContentOffset;
        
        
        if (transX > 0) {
            
        }
        else {    //transX < 0
            return;
        }
        
        contentTransform = CATransform3DTranslate(contentTransform, transX, 0.0, 0.0);
        contentTransform = CATransform3DRotate(contentTransform, DEG2RAD(-45 * ss), 0.0, 1.0, 0.0);
        self.centerView.layer.transform = contentTransform;
    }// end UIGestureRecognizerStateChanged
    
    else if (pan.state == UIGestureRecognizerStateEnded){

        CGFloat panX = [pan translationInView:self.view].x;
        CGFloat finalX = currentTranslateX + panX;
        
        if (finalX > DJudgeOffset) {
            //CGAffineTransform conT = [self transformWithDirection:DMoveDirectionRight];
            CATransform3D conT = CATransform3DIdentity;
            conT.m34 = -1.0f / 800.0f;
            conT = CATransform3DTranslate(conT, DZhiHuContentOffset, 0, 0);
            conT = CATransform3DRotate(conT, DEG2RAD(-45), 0.0, 1.0, 0.0);
            
            
            [UIView beginAnimations:nil context:nil];
            self.centerView.layer.zPosition = 100.0;
            self.centerView.layer.transform = conT;
            [UIView commitAnimations];
            
            self.tapGestureRecognizer.enabled = YES;
            return;
        }
        if (finalX < -DJudgeOffset) {
            return;
        }
        else {
            CATransform3D oriT = CATransform3DIdentity;
            [UIView beginAnimations:nil context:nil];
            self.centerView.layer.transform = oriT;
            [UIView commitAnimations];
            
            self.tapGestureRecognizer.enabled = NO;
        }
        
    }//end UIGestureRecognizerStateEnded
}

#pragma mark -
#pragma mark Private

- (CGAffineTransform)transformWithDirection:(DMoveDirection)direction andSliderMode:(SliderMode)mode
{
    CGFloat translateX = 0;
    switch (direction) {
        case DMoveDirectionLeft:
            translateX = -DContentOffset;
            break;
        case DMoveDirectionRight:
            translateX = DContentOffset;
            break;
        default:
            break;
    }

    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(DContentScale, DContentScale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    if (mode == NormalMode) {
        conT = transT;
    }
    return conT;
}

- (void)configureViewShadowWithDirection:(DMoveDirection)direction
{
    CGFloat shadowW;
    switch (direction)
    {
        case DMoveDirectionLeft:
            shadowW = 2.0f;
            break;
        case DMoveDirectionRight:
            shadowW = -2.0f;
            break;
        default:
            break;
    }
    
    self.centerView.layer.shadowOffset = CGSizeMake(shadowW, 1.0);
    self.centerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.centerView.layer.shadowOpacity = 0.8f;
}

#pragma mark -
#pragma mark BaseCenterDelegate

- (void)leftButtonClicked:(UIButton *)button
{
    if (self.tapGestureRecognizer.enabled == YES) {
        [self closeSide];
        return;
    }
    
    if (self.sliderMode == ZhiHuMode) {
        
        [self configureViewShadowWithDirection:DMoveDirectionRight];
        
        CATransform3D contentTransform = CATransform3DIdentity;
        contentTransform.m34 = -1.0f / 800.0f;
        self.centerView.layer.zPosition = 100;
        
        
        //contentTransform = CATransform3DTranslate(contentTransform, DContentOffset - (self.centerView.frame.size.width / 2 * 0.4), 0.0, 0.0);
        contentTransform = CATransform3DTranslate(contentTransform, DZhiHuContentOffset, 0.0, 0.0);
        //contentTransform = CATransform3DScale(contentTransform, 0.6, 0.6, 0.6);
        contentTransform = CATransform3DRotate(contentTransform, DEG2RAD(-45), 0.0, 1.0, 0.0);
        [UIView animateWithDuration:.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.centerView.layer.transform = contentTransform;
                         }
                         completion:^(BOOL finished) {
                             self.tapGestureRecognizer.enabled = YES;
                         }];
    }//end ZhiHuMode
    
    else if (self.sliderMode == NetEaseMode || self.sliderMode == NormalMode) {
        
        CGAffineTransform conT = [self transformWithDirection:DMoveDirectionRight andSliderMode:self.sliderMode];
        
        
        [self configureViewShadowWithDirection:DMoveDirectionRight];
        
        [UIView animateWithDuration:DOpenDuration
                         animations:^{
                             self.centerView.transform = conT;
                         }
                         completion:^(BOOL finished) {
                             self.tapGestureRecognizer.enabled = YES;
                         }];
        
    } //end NetEaseMode || NormalMode
}
/*
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
*/
@end
