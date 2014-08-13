//
//  DDSliderController.m
//  DDSliderControllerDemo
//
//  Created by handaer on 14-8-13.
//
//

#import "DDSliderController.h"

@interface DDSliderController ()

@property (strong, nonatomic) UIView *leftSideView;
@property (strong, nonatomic) UIView *centerView;

@property (strong, nonatomic) NSMutableDictionary *controllersDic;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation DDSliderController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)init{
    if (self = [super init]) {
        //init property
        _controllersDic = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+(instancetype)sharedController{
    static DDSliderController * controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
