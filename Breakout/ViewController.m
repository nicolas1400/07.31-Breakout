//
//  ViewController.m
//  Breakout
//
//  Created by Nicolas Semenas on 31/07/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"

@interface ViewController () <UICollisionBehaviorDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet PaddleView *paddleView;
@property (weak, nonatomic) IBOutlet BallView *ballView;
@property (weak, nonatomic) IBOutlet UIView *bottom;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel2;

@property UIPanGestureRecognizer *panGestureRecognizer;
@property UIDynamicItemBehavior *paddleDynamicBehavior;
@property UIDynamicItemBehavior *ballDynamicBehavior;
@property UIDynamicItemBehavior *blockDynamicBehavior;
@property UIDynamicAnimator *dynamicAnimator;
@property UIPushBehavior *pushBehavior;
@property UICollisionBehavior *collisionBehavior;

@property NSTimer *timer;
@property int remainingTicks;

@property (nonatomic, strong) BlockView *block1;
@property (nonatomic, strong) BlockView *block2;
@property (nonatomic, strong) BlockView *block3;
@property (nonatomic, strong) BlockView *block4;
@property (nonatomic, strong) BlockView *block5;

@property (nonatomic, strong) BlockView *block6;
@property (nonatomic, strong) BlockView *block7;
@property (nonatomic, strong) BlockView *block8;
@property (nonatomic, strong) BlockView *block9;
@property (nonatomic, strong) BlockView *block10;

@property (nonatomic, strong) BlockView *block11;
@property (nonatomic, strong) BlockView *block12;
@property (nonatomic, strong) BlockView *block13;
@property (nonatomic, strong) BlockView *block14;
@property (nonatomic, strong) BlockView *block15;


@property (nonatomic, strong) NSMutableArray *blocks;

@property int actualPlayer;

@end

@implementation ViewController





- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
   
    NSString *object = (NSString *) identifier;
    if ([object isEqualToString:@"belowPaddle"])
    {
        if (self.actualPlayer == 1){
            self.scoreLabel.text = [NSString stringWithFormat:@"%d",[self.scoreLabel.text intValue] - 200 ];
        } else {
            self.scoreLabel2.text = [NSString stringWithFormat:@"%d",[self.scoreLabel2.text intValue] - 200 ];
        }
        
        self.ballView.center = CGPointMake(160, 250);

        [self.dynamicAnimator removeAllBehaviors];
        
        [self swapPlayer];

        [self startCountdown];
        
    }
}


- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{
    if ([item1 isKindOfClass:[BlockView class]]){
      
        NSLog(@"item 1");

        
    } else
    if ([item2 isKindOfClass:[BlockView class]]){
        
        BlockView *object = (BlockView *) item2;
        
        if (object.hardness == 0 ){
            
            if (self.actualPlayer == 1){
                self.scoreLabel.text = [NSString stringWithFormat:@"%d",[self.scoreLabel.text intValue] + 100 ];}
            else {
                self.scoreLabel2.text = [NSString stringWithFormat:@"%d",[self.scoreLabel2.text intValue] + 100 ];
            }

            object.backgroundColor = [UIColor blackColor];
            
            [UIView animateWithDuration:1.0 animations:^(void) {
                object.alpha = 1;
                object.alpha = 0;
            }];
            
            [self.blocks removeObject:object];
            [self.collisionBehavior removeItem:item2];
        
        } else {
        
            object.hardness --;
            [object setNeedsLayout];

            if (self.actualPlayer == 1){
                self.scoreLabel.text = [NSString stringWithFormat:@"%d",[self.scoreLabel.text intValue] + 10 ];}
            else {
                self.scoreLabel2.text = [NSString stringWithFormat:@"%d",[self.scoreLabel2.text intValue] + 10 ];
            }}



    
            
        
        if (!self.blocks.count){
            
            
            
            [self.dynamicAnimator removeAllBehaviors];
            
            if ([self.scoreLabel.text intValue] > [self.scoreLabel2.text intValue]) {
                
                //PLAYER 1 WINS
                NSString* messageString = [NSString stringWithFormat: @"You scored %@", self.scoreLabel.text];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PLAYER 1 WINS!"
                                                                message:messageString
                                                               delegate:self
                                                      cancelButtonTitle:@"Play Again!"
                                                      otherButtonTitles:nil];
                [alert show];

    
            } else {
                
                //PLAYER 2 WINS
                NSString* messageString = [NSString stringWithFormat: @"You scored %@", self.scoreLabel2.text];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PLAYER 2 WINS!"
                                                                message:messageString
                                                               delegate:self
                                                      cancelButtonTitle:@"Play Again!"
                                                      otherButtonTitles:nil];
                [alert show];


                
            }
            
            
        }
        
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0)
    {
        self.scoreLabel.text = @"0";
        [self loadBlocks];
        [self startCountdown];
        self.scoreLabel.text = @"0";
        self.scoreLabel2.text = @"0";

        
    }

}


-(void)tick {
    

    
    self.countDownLabel.text = [NSString stringWithFormat:@"%d",self.remainingTicks-1];
    
    [UIView animateWithDuration:0.6 animations:^(void) {
        self.countDownLabel.alpha = 1;
        self.countDownLabel.alpha = 0;
    }];
    
    if (--self.remainingTicks == 0) {
        [self.timer invalidate];
        [self startGame];
        self.countDownLabel.hidden = TRUE;
        self.ballView.hidden = NO;
    }
}


-(void) startCountdown{
    
    self.ballView.hidden = YES;
    self.remainingTicks = 3;
    self.countDownLabel.text = @"3";
    self.countDownLabel.hidden = NO;
    

    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(tick)
                                           userInfo:nil
                                            repeats:YES];
    
}

- (void) startGame{
    



    
    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    self.paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
    self.paddleDynamicBehavior.allowsRotation = NO;
    self.paddleDynamicBehavior.density = 1000;
    [self.dynamicAnimator addBehavior:self.paddleDynamicBehavior];
    
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
    self.pushBehavior.active = YES;
    self.pushBehavior.magnitude = 0.2;
    [self.dynamicAnimator addBehavior:self.pushBehavior];
    
    self.blockDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.blocks];
    self.blockDynamicBehavior.allowsRotation = NO;
    self.blockDynamicBehavior.density = 1000;
    [self.dynamicAnimator addBehavior:self.blockDynamicBehavior];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObjectsFromArray:self.blocks];
    [array addObjectsFromArray:@[self.ballView,self.paddleView]];
  

    self.collisionBehavior = [[UICollisionBehavior alloc]initWithItems:array];
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.collisionDelegate = self;
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    
    self.ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
    self.ballDynamicBehavior.allowsRotation = NO;
    self.ballDynamicBehavior.elasticity = 1.0;
    self.ballDynamicBehavior.friction = 0;
    self.ballDynamicBehavior.resistance = 0;
    [self.dynamicAnimator addBehavior:self.ballDynamicBehavior];
    
    
    CGRect frame = self.bottom.frame;
    
    CGPoint bottomLeft = CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame));
    CGPoint bottomRight = CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame));
    
    [self.collisionBehavior addBoundaryWithIdentifier: @"belowPaddle"
                                            fromPoint: CGPointMake(bottomLeft.x, bottomLeft.y)
                                              toPoint: CGPointMake(bottomRight.x, bottomRight.y)];
    


}


-(void) loadBlocks{
    
    self.blocks  = [[NSMutableArray alloc]init];
    self.block1  = [[BlockView alloc]initWithFrame:CGRectMake(0, 120, 64, 25) ];
    self.block2  = [[BlockView alloc]initWithFrame:CGRectMake(64, 120, 64, 25) ];
    self.block3  = [[BlockView alloc]initWithFrame:CGRectMake(128, 120, 64, 25) ];
    self.block4  = [[BlockView alloc]initWithFrame:CGRectMake(192, 120, 64, 25) ];
    self.block5  = [[BlockView alloc]initWithFrame:CGRectMake(256, 120, 64, 25) ];
    
    self.block6  = [[BlockView alloc]initWithFrame:CGRectMake(0, 95, 64, 25) ];
    self.block7  = [[BlockView alloc]initWithFrame:CGRectMake(64, 95, 64, 25) ];
    self.block8  = [[BlockView alloc]initWithFrame:CGRectMake(128, 95, 64, 25) ];
    self.block9  = [[BlockView alloc]initWithFrame:CGRectMake(192, 95, 64, 25) ];
    self.block10 = [[BlockView alloc]initWithFrame:CGRectMake(256, 95, 64, 25) ];
    
    self.block11  = [[BlockView alloc]initWithFrame:CGRectMake(0, 70, 64, 25) ];
    self.block12 = [[BlockView alloc]initWithFrame:CGRectMake(64, 70, 64, 25) ];
    self.block13  = [[BlockView alloc]initWithFrame:CGRectMake(128, 70, 64, 25) ];
    self.block14  = [[BlockView alloc]initWithFrame:CGRectMake(192, 70, 64, 25) ];
    self.block15 = [[BlockView alloc]initWithFrame:CGRectMake(256, 70, 64, 25) ];
 
    [self.blocks addObject:self.block1];
    [self.blocks addObject:self.block2];
    [self.blocks addObject:self.block3];
    [self.blocks addObject:self.block4];
    [self.blocks addObject:self.block5];

    [self.blocks addObject:self.block6];
    [self.blocks addObject:self.block7];
    [self.blocks addObject:self.block8];
    [self.blocks addObject:self.block9];
    [self.blocks addObject:self.block10];
    
    [self.blocks addObject:self.block11];
    [self.blocks addObject:self.block12];
    [self.blocks addObject:self.block13];
    [self.blocks addObject:self.block14];
    [self.blocks addObject:self.block15];
  
    for (BlockView * block in self.blocks){
        [self.view addSubview:block];
    }
    
    [self swapPlayer];
    
    
}


-(void) swapPlayer{
    
    if (self.actualPlayer == 1) {
        self.actualPlayer = 2;
        self.scoreLabel.backgroundColor= [UIColor whiteColor];
        self.scoreLabel2.backgroundColor = [UIColor greenColor];
        
    } else {
        self.actualPlayer = 1;
        self.scoreLabel.backgroundColor = [UIColor greenColor];
        self.scoreLabel2.backgroundColor = [UIColor whiteColor];
    }
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadBlocks];
    
    [self startCountdown];
}



- (IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer {

    self.paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x, self.paddleView.center.y);
    [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
    
}


@end
