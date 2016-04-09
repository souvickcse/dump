//
//  CustomTableView.h
//  Fusion
//
//  Created by Souvick Ghosh on 05/04/16.
//  Copyright © 2016 Fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableView.h"
@protocol CustomTableViewDelegate <NSObject>
- (void)bottomLoadMoreCalled;//Called when bottom loader starts
- (void)topLoadMoreCalled;//Called when top loader starts
@end
@interface CustomTableView : UITableView

@property (nonatomic, weak) id<CustomTableViewDelegate> loadMoreDelegate;
@property (strong, nonatomic) UILabel *lblNoData;
@property (strong, nonatomic) NSString *strNoData;

- (void)hideBottomLoader;//Call it to stop bottom loader
- (void)hideTopLoader;//Call it to stop top loader

- (void)reloadData;
- (void)setUpTableView:(BOOL)shouldShowTopLoader shouldShowBottomLoader:(BOOL)shouldShowBottomLoader shouldShowNoDataLabel:(BOOL)shouldShowNoDataLabel backGroundColor:(UIColor *)colorBackGround;
@end
