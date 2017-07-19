//
//  ViewController.h
//  BubbleList
//
//  Created by souvick on 18/07/17.
//  Copyright © 2017 souvick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewBuubleHolder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constViewBubbleHolderWIdth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constViewBubbleHolderHeight;


@end

