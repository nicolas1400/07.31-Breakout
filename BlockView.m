//
//  BlockView.m
//  Breakout
//
//  Created by Nicolas Semenas on 01/08/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import "BlockView.h"



@implementation BlockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame = frame;
        self.hardness = arc4random()%3;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
        if (self.hardness == 0){
            self.backgroundColor = [UIColor yellowColor];
        } else
            if (self.hardness == 1) {
                self.backgroundColor = [UIColor blueColor];
            } else
                if (self.hardness == 2) {
                    self.backgroundColor = [UIColor redColor];
                } 
        
    }
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
