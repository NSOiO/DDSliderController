//
//  ClassMode.h
//  DDSliderControllerDemo
//
//  Created by handaer on 14-8-13.
//
//

#import <Foundation/Foundation.h>


@interface ClassMode : NSObject


@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *className;

- (instancetype)initWithTitle:(NSString *)title className:(NSString *)className;

@end
