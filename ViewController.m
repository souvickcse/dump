//
//  ViewController.m
//  BubbleList
//
//  Created by souvick on 18/07/17.
//  Copyright © 2017 souvick. All rights reserved.
//

#import "ViewController.h"
#import "RoundButton.h"
#define MAXLENGTH 140
#define MINLENGTH 100


@interface ViewController ()
{
    float latestYValue;
}
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    latestYValue = 0.0;
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:_viewBuubleHolder];
    self.animator.delegate = (id)self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addCircularButtons];
    });
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator; {
    NSLog(@"Will resume");
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator;{
    NSLog(@"Did pause");
    _constViewBubbleHolderHeight.constant = 0.0;
    [_viewBuubleHolder layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
    _constViewBubbleHolderWIdth.constant = self.view.frame.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCircularButtons {
    
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];
    
    CGVector vector = CGVectorMake(0.0, -1.0);
    gravityBehavior.gravityDirection = vector;
    [self.animator addBehavior:gravityBehavior];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collisionBehavior];
    
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
    ballBehavior.elasticity = 0.7;
    ballBehavior.resistance = 0.0;
    ballBehavior.friction = 0.0;
    ballBehavior.allowsRotation = NO;
    [self.animator addBehavior:ballBehavior];

    
    float currentX = 10.0;
    float currentY = 0.0;
    float maxY = 0.0;

    for(int i=0;i<100;i++) {
        RoundButton *button = [RoundButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0]];
        
        float originX = currentX ;
        float originY = currentY;
        float width = [self generateRandomNumberWithlowerBound:MINLENGTH upperBound:MAXLENGTH];
        float height = width;
        
        if(originX+width>self.scrollView.frame.size.width) {
            /*Add New Line*/
            currentY = maxY;
            currentX = 0.0;
            originY = currentY;
            originX = currentX+[self generateRandomNumberWithlowerBound:10 upperBound:40];
        }
        
        if(originY+height>maxY) {
            maxY = originY+height;
        }
        
        currentX = originX+width;
        button.frame = CGRectMake(originX, originY, width, height);
        button.layer.cornerRadius = (float)width/2.0;
        button.layer.masksToBounds = YES;
        [_viewBuubleHolder addSubview:button];
        [gravityBehavior addItem:button];
        [collisionBehavior addItem:button];
        [ballBehavior addItem:button];
        
        _constViewBubbleHolderHeight.constant = maxY+height;
        [_viewBuubleHolder layoutIfNeeded];
    }
    
}

-(int) generateRandomNumberWithlowerBound:(int)lowerBound
                               upperBound:(int)upperBound
{
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    return rndValue;
}

@end
