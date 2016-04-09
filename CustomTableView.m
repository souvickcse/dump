//
//  CustomTableView.m
//  Fusion
//
//  Created by Souvick Ghosh on 05/04/16.
//  Copyright © 2016 Fusion. All rights reserved.
//

#import "CustomTableView.h"
@interface CustomTableView () <UITableViewDelegate>
@property (nonatomic, weak) id<UITableViewDelegate> realDelegate;
@property (nonatomic, strong) UIView *footerView;
@property BOOL isBottomLoading;
@property BOOL isTopLoading;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSString *strTotalNumberOfRow;
@end
@implementation CustomTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}



- (void)setUpTableView:(BOOL)shouldShowTopLoader shouldShowBottomLoader:(BOOL)shouldShowBottomLoader shouldShowNoDataLabel:(BOOL)shouldShowNoDataLabel backGroundColor:(UIColor *)colorBackGround
{
    
    [super setDelegate:self];
    if(colorBackGround)
        self.backgroundColor = colorBackGround;
    
    
    if(shouldShowNoDataLabel) {
        UIFont * customFont = [UIFont systemFontOfSize:22.0]; //custom font
        NSString * text = @"";
        self.lblNoData = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 40.0)];
        self.lblNoData.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.lblNoData.text = text;
        self.lblNoData.font = customFont;
        self.lblNoData.numberOfLines = 1;
        self.lblNoData.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
        self.lblNoData.adjustsFontSizeToFitWidth = YES;
        self.lblNoData.minimumScaleFactor = 10.0f/12.0f;
        self.lblNoData.clipsToBounds = YES;
        self.lblNoData.backgroundColor = [UIColor clearColor];
        self.lblNoData.textColor = [UIColor blackColor];
        self.lblNoData.textAlignment = NSTextAlignmentCenter;
        self.backgroundView = self.lblNoData;
    }
    
    
    if(shouldShowBottomLoader) {
        //Bottom Loader
        [self initBottomLoader];
        self.tableFooterView = self.footerView;
    }
    
    if(shouldShowTopLoader) {
        //Pull To Refresh
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UIColor clearColor];
        self.refreshControl.tintColor = [UIColor whiteColor];
        [self.refreshControl addTarget:self
                                action:@selector(pullToRefreshCalled)
                      forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.refreshControl];
    }
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
        [super setDelegate:nil];
        self.realDelegate = delegate != self ? delegate : nil;
        [super setDelegate:delegate ? self : nil];
}

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark - Bottom Loader -

- (void)initBottomLoader {
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 40.0)];
    self.footerView.backgroundColor = [UIColor clearColor];
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    actInd.tag = 10;
    actInd.frame = self.footerView.bounds;
    actInd.hidesWhenStopped = YES;
    actInd.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    actInd.backgroundColor = [UIColor clearColor];
    [self.footerView addSubview:actInd];
    actInd = nil;
}

- (void)hideBottomLoader {
    [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] stopAnimating];
    self.isBottomLoading = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    id<UITableViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    
    if(scrollView.contentSize.height>scrollView.frame.size.height) {
        if (maximumOffset - currentOffset <= 10.0) {
            [(UIActivityIndicatorView *)[self.footerView viewWithTag:10] startAnimating];
            if(!self.loadMoreDelegate)
                self.loadMoreDelegate = (id)self.realDelegate;
            if(!self.isBottomLoading) {
                if ([self.loadMoreDelegate respondsToSelector:@selector(bottomLoadMoreCalled)])
                {
                    self.isBottomLoading = YES;
                    [self.loadMoreDelegate bottomLoadMoreCalled];
                }
            }
        }
    }
}

#pragma mark - Pull To Refresh -

- (void)pullToRefreshCalled {
    
    if(!self.loadMoreDelegate)
        self.loadMoreDelegate = (id)self.realDelegate;
    if(!self.isTopLoading) {
        if ([self.loadMoreDelegate respondsToSelector:@selector(topLoadMoreCalled)])
        {
            self.isTopLoading = YES;
            [self.loadMoreDelegate topLoadMoreCalled];
        }
    }
    
}

- (void)hideTopLoader {
    self.isTopLoading = NO;
    [self.refreshControl endRefreshing];
}

#pragma mark - No Data Label -

- (void)reloadData {
     [super reloadData];
    if([self numberOfRowsInSection:0]==0) {
        self.lblNoData.text = self.strNoData;
    } else {
        self.lblNoData.text = @"";
    }
    
   
}

@end
