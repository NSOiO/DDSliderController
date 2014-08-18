//
//  ClassMode.m
//  DDSliderControllerDemo
//
//  Created by handaer on 14-8-13.
//
//

#import "ClassMode.h"

@implementation ClassMode

- (id)init{
    
    if (self = [super init]) {
        
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title className:(NSString *)className{
    self = [self init];
    if (self) {
        self.title = title;
        self.className = className;
    }
    
    return self;
}

@end
