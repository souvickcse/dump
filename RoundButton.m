//
//  RoundButton.m
//  BubbleList
//
//  Created by souvick on 19/07/17.
//  Copyright © 2017 souvick. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIDynamicItemCollisionBoundsType)collisionBoundsType {
    return UIDynamicItemCollisionBoundsTypeEllipse;
}
@end
