//
//  BlockView.h
//  Breakout
//
//  Created by Nicolas Semenas on 01/08/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BlockView : UIView
@property (nonatomic, assign) int hardness;


- (instancetype)initWithFrame:(CGRect)frame ;

@end
