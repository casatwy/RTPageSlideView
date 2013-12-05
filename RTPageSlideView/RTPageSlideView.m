//
//  RTPageScrollView.m
//  com.anjuke.scrollView
//
//  Created by casa on 13-10-23.
//  Copyright (c) 2013年 casa. All rights reserved.
//

#import "RTPageSlideView.h"
#import "RTPageSlideViewSpot.h"

@interface RTPageSlideView ()

@property (nonatomic, readwrite) NSInteger currentPageNumber;
@property (nonatomic) NSInteger lastPageIndex;

@property (nonatomic, readwrite, strong) UIScrollView *scrollView;

@property (nonatomic, strong) RTPageSlideViewSpot *leftLeftPageView;
@property (nonatomic, strong) RTPageSlideViewSpot *leftPageView;
@property (nonatomic, strong) RTPageSlideViewSpot *centerPageView;
@property (nonatomic, strong) RTPageSlideViewSpot *rightPageView;
@property (nonatomic, strong) RTPageSlideViewSpot *rightRightPageView;

@property (nonatomic) NSInteger lastPageNumber;

@end

@implementation RTPageSlideView

#pragma mark - getters and setters
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.tag = NSIntegerMax;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (RTPageSlideViewSpot *)leftLeftPageView
{
    if (_leftLeftPageView == nil) {
        _leftLeftPageView = [[RTPageSlideViewSpot alloc] init];
    }
    return _leftLeftPageView;
}

- (RTPageSlideViewSpot *)leftPageView
{
    if (_leftPageView == nil) {
        _leftPageView = [[RTPageSlideViewSpot alloc] init];
    }
    return _leftPageView;
}

- (RTPageSlideViewSpot *)centerPageView
{
    if (_centerPageView == nil) {
        _centerPageView = [[RTPageSlideViewSpot alloc] init];
    }
    return _centerPageView;
}

- (RTPageSlideViewSpot *)rightPageView
{
    if (_rightPageView == nil) {
        _rightPageView = [[RTPageSlideViewSpot alloc] init];
    }
    return _rightPageView;
}

- (RTPageSlideViewSpot *)rightRightPageView
{
    if (_rightRightPageView == nil) {
        _rightRightPageView = [[RTPageSlideViewSpot alloc] init];
    }
    return _rightRightPageView;
}

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentPageNumber = 0;
        self.lastPageNumber = 0;
        self.pageViewForReuse = nil;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self reloadSlideViewsWithCurrentPageNumber:self.currentPageNumber];
}

#pragma mark - self method
- (void)configuration
{
    CGFloat pageGap = 0.0f;
    if ([self.configurationDelegate respondsToSelector:@selector(pageGap:)]) {
        pageGap = [self.configurationDelegate pageGap:self];
    }

    CGRect pageFrame = [self.configurationDelegate pageFrame:self];
    self.scrollView.frame = CGRectMake(pageFrame.origin.x, pageFrame.origin.y, pageFrame.size.width+pageGap, pageFrame.size.height);
    
    NSInteger pageCount = [self.configurationDelegate pageCount:self];
    NSInteger size = pageCount;
    if (size > 5) {
        size = 5;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*size, self.scrollView.frame.size.height);
    
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    CGFloat width = pageFrame.size.width;
    CGFloat height = pageFrame.size.height;
    
    //A
    self.leftLeftPageView.frame = CGRectMake(xOffset, yOffset, width, height);
    self.pageViewForReuse = self.leftLeftPageView.contentView;
    self.leftLeftPageView.contentView = [self.contentDelegate slideView:self pageViewAtPageNumber:0];
    self.leftLeftPageView.contentView.frame = self.leftLeftPageView.bounds;
    [self.leftLeftPageView addSubview:self.leftLeftPageView.contentView];
    [self.scrollView addSubview:self.leftLeftPageView];
    
    //B
    xOffset = self.leftLeftPageView.frame.origin.x + width + pageGap;
    self.leftPageView.frame = CGRectMake(xOffset, yOffset, width, height);
    self.pageViewForReuse = self.leftPageView.contentView;
    self.leftPageView.contentView = [self.contentDelegate slideView:self pageViewAtPageNumber:0];
    self.leftPageView.contentView.frame = self.leftPageView.bounds;
    [self.leftPageView addSubview:self.leftPageView.contentView];
    [self.scrollView addSubview:self.leftPageView];

    //C
    xOffset = self.leftPageView.frame.origin.x + width + pageGap;
    self.centerPageView.frame = CGRectMake(xOffset, yOffset, width, height);
    self.pageViewForReuse = self.centerPageView.contentView;
    self.centerPageView.contentView = [self.contentDelegate slideView:self pageViewAtPageNumber:0];
    self.centerPageView.contentView.frame = self.centerPageView.bounds;
    [self.centerPageView addSubview:self.centerPageView.contentView];
    [self.scrollView addSubview:self.centerPageView];

    //D
    xOffset = self.centerPageView.frame.origin.x + width + pageGap;
    self.rightPageView.frame = CGRectMake(xOffset, yOffset, width, height);
    self.pageViewForReuse = self.rightPageView.contentView;
    self.rightPageView.contentView = [self.contentDelegate slideView:self pageViewAtPageNumber:0];
    self.rightPageView.contentView.frame = self.rightPageView.bounds;
    [self.rightPageView addSubview:self.rightPageView.contentView];
    [self.scrollView addSubview:self.rightPageView];
    
    //E
    xOffset = self.rightPageView.frame.origin.x + width + pageGap;
    self.rightRightPageView.frame = CGRectMake(xOffset, yOffset, width, height);
    self.pageViewForReuse = self.rightRightPageView.contentView;
    self.rightRightPageView.contentView = [self.contentDelegate slideView:self pageViewAtPageNumber:0];
    self.rightRightPageView.contentView.frame = self.rightRightPageView.bounds;
    [self.rightRightPageView addSubview:self.rightRightPageView.contentView];
    [self.scrollView addSubview:self.rightRightPageView];
    
    self.leftLeftPageView.previousSpot = nil;
    self.leftLeftPageView.nextSpot = self.leftPageView;
    
    self.leftPageView.previousSpot = self.leftLeftPageView;
    self.leftPageView.nextSpot = self.centerPageView;
    
    self.centerPageView.previousSpot = self.leftPageView;
    self.centerPageView.nextSpot = self.rightPageView;
    
    self.rightPageView.previousSpot = self.centerPageView;
    self.rightPageView.nextSpot = self.rightRightPageView;
    
    self.rightRightPageView.previousSpot = self.rightPageView;
    self.rightPageView.nextSpot = nil;
}

- (void)loadPageView:(RTPageSlideViewSpot *)pageView withPageNumber:(NSInteger)pageNumber
{
    NSInteger pageCount = [self.configurationDelegate pageCount:self];
    
    if (pageNumber < pageCount) {
        self.pageViewForReuse = pageView.contentView;
        [self.pageViewForReuse prepareForReuse];
        pageView.tag = pageNumber;
        pageView.contentView = [self.contentDelegate slideView:self pageViewAtPageNumber:pageNumber];
    } else {
        [pageView.contentView removeFromSuperview];
    }
}

#pragma mark - method for outer objects
- (void)reloadSlideViewsWithCurrentPageNumber:(NSInteger)currentPageNumber
{
    self.currentPageNumber = currentPageNumber;
    self.lastPageNumber = currentPageNumber;
    
    [self configuration];
    
    NSInteger pageCount = [self.configurationDelegate pageCount:self];
    if (currentPageNumber >= pageCount || pageCount == 0) {
        return;
    }
    
    [self setCurrentPageNumber:self.currentPageNumber animated:NO];
}

- (void)setCurrentPageNumber:(NSInteger)currentPageNumber animated:(BOOL)isAnimated
{
    
    CGFloat pageCount = [self.configurationDelegate pageCount:self];
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
    NSInteger size = pageCount;
    if (size > 5) {
        size = 5;
    }
    self.scrollView.contentSize = CGSizeMake(pageWidth*size, CGRectGetHeight(self.scrollView.frame));
    
    if (currentPageNumber >= pageCount || currentPageNumber < 0) {
        return;
    }
    
    self.currentPageNumber = currentPageNumber;
    self.lastPageNumber = currentPageNumber;
    
    if (currentPageNumber == 0) {
        
        self.lastPageIndex = 0;
        self.scrollView.contentOffset = CGPointZero;
        
        [self loadPageView:self.leftLeftPageView withPageNumber:currentPageNumber];
        [self loadPageView:self.leftPageView withPageNumber:(currentPageNumber + 1)];
        [self loadPageView:self.centerPageView withPageNumber:(currentPageNumber + 2)];
        [self loadPageView:self.rightPageView withPageNumber:(currentPageNumber + 3)];
        [self loadPageView:self.rightRightPageView withPageNumber:(currentPageNumber + 4)];
        
        return;
        
    } else if (currentPageNumber == 1) {
        
        self.lastPageIndex = 1;
        self.scrollView.contentOffset = CGPointMake(pageWidth, 0);
        
        [self loadPageView:self.leftLeftPageView withPageNumber:(currentPageNumber - 1)];
        [self loadPageView:self.leftPageView withPageNumber:currentPageNumber];
        [self loadPageView:self.centerPageView withPageNumber:(currentPageNumber + 1)];
        [self loadPageView:self.rightPageView withPageNumber:(currentPageNumber + 2)];
        [self loadPageView:self.rightRightPageView withPageNumber:(currentPageNumber + 3)];
        
        return;
        
    } else if (currentPageNumber == pageCount - 2) {
        
        if (currentPageNumber < 4) {
            self.lastPageIndex = currentPageNumber;
            self.scrollView.contentOffset = CGPointMake(pageWidth * currentPageNumber, 0);
                              
            [self loadPageView:self.leftLeftPageView withPageNumber:(currentPageNumber - currentPageNumber)];
            [self loadPageView:self.leftPageView withPageNumber:(currentPageNumber - currentPageNumber + 1)];
            [self loadPageView:self.centerPageView withPageNumber:(currentPageNumber - currentPageNumber + 2)];
            [self loadPageView:self.rightPageView withPageNumber:(currentPageNumber - currentPageNumber + 3)];
            [self loadPageView:self.rightRightPageView withPageNumber:(currentPageNumber - currentPageNumber + 4)];
        } else {
            self.lastPageIndex = 3;
            self.scrollView.contentOffset = CGPointMake(pageWidth * 3, 0);
                   
            [self loadPageView:self.leftLeftPageView withPageNumber:(currentPageNumber - 3)];
            [self loadPageView:self.leftPageView withPageNumber:(currentPageNumber - 2)];
            [self loadPageView:self.centerPageView withPageNumber:(currentPageNumber - 1)];
            [self loadPageView:self.rightPageView withPageNumber:currentPageNumber];
            [self loadPageView:self.rightRightPageView withPageNumber:(currentPageNumber + 1)];
        }
        
               
        return;
        
    } else if (currentPageNumber == pageCount - 1) {
        
        if (currentPageNumber < 5) {
            self.lastPageIndex = currentPageNumber;
            self.scrollView.contentOffset = CGPointMake(pageWidth * currentPageNumber, 0);
            
            [self loadPageView:self.leftLeftPageView withPageNumber:(currentPageNumber - currentPageNumber)];
            [self loadPageView:self.leftPageView withPageNumber:(currentPageNumber - currentPageNumber + 1)];
            [self loadPageView:self.centerPageView withPageNumber:currentPageNumber - currentPageNumber + 2];
            [self loadPageView:self.rightPageView withPageNumber:(currentPageNumber - currentPageNumber + 3)];
            [self loadPageView:self.rightRightPageView withPageNumber:(currentPageNumber - currentPageNumber + 4)];
            
        } else {
            self.lastPageIndex = 4;
            self.scrollView.contentOffset = CGPointMake(pageWidth * 4, 0);
                   
            [self loadPageView:self.leftLeftPageView withPageNumber:(currentPageNumber - 4)];
            [self loadPageView:self.leftPageView withPageNumber:(currentPageNumber - 3)];
            [self loadPageView:self.centerPageView withPageNumber:(currentPageNumber - 2)];
            [self loadPageView:self.rightPageView withPageNumber:(currentPageNumber - 1)];
            [self loadPageView:self.rightRightPageView withPageNumber:currentPageNumber];
        }
        
        return;
        
    } else {
        
        self.lastPageIndex = 2;
        self.scrollView.contentOffset = CGPointMake(pageWidth * 2, 0);
               
        [self loadPageView:self.leftLeftPageView withPageNumber:(currentPageNumber - 2)];
        [self loadPageView:self.leftPageView withPageNumber:(currentPageNumber - 1)];
        [self loadPageView:self.centerPageView withPageNumber:currentPageNumber];
        [self loadPageView:self.rightPageView withPageNumber:(currentPageNumber + 1)];
        [self loadPageView:self.rightRightPageView withPageNumber:(currentPageNumber + 2)];
        
        return;
        
    }
    
}

- (RTPageSlideViewCell *)cellForSlideViewAtPageNumber:(NSInteger)pageNumber
{
    RTPageSlideViewSpot *spot = (RTPageSlideViewSpot *)[self.scrollView viewWithTag:pageNumber];
    if (spot) {
        return spot.contentView;
    } else {
        return nil;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageCount = [self.configurationDelegate pageCount:self];
    
    NSInteger pageIndex = floor( scrollView.contentOffset.x / scrollView.frame.size.width );
    
    if (pageIndex == self.lastPageIndex) {
        return;
    }
    //show right
    if (pageIndex > self.lastPageIndex) {
        
        self.currentPageNumber = self.currentPageNumber + (pageIndex - self.lastPageIndex);
        
        if (pageIndex >= 3 && (self.currentPageNumber < pageCount - 2) && pageCount > 5) {
            
            RTPageSlideViewCell *cellForReuse = self.leftLeftPageView.contentView;
            
            self.leftLeftPageView.tag = self.leftPageView.tag;
            self.leftLeftPageView.contentView = self.leftPageView.contentView;
            [self.leftLeftPageView addSubview:self.leftLeftPageView.contentView];
            
            self.leftPageView.tag = self.centerPageView.tag;
            self.leftPageView.contentView = self.centerPageView.contentView;
            [self.leftPageView addSubview:self.leftPageView.contentView];
            
            self.centerPageView.tag = self.rightPageView.tag;
            self.centerPageView.contentView = self.rightPageView.contentView;
            [self.centerPageView addSubview:self.centerPageView.contentView];
            
            self.rightPageView.tag = self.rightRightPageView.tag;
            self.rightPageView.contentView = self.rightRightPageView.contentView;
            [self.rightPageView addSubview:self.rightPageView.contentView];
            
            [cellForReuse prepareForReuse];
            self.pageViewForReuse = cellForReuse;
            self.rightRightPageView.tag = self.currentPageNumber + 2;
            cellForReuse = [self.contentDelegate slideView:self pageViewAtPageNumber:(self.currentPageNumber + 2)];
            self.rightRightPageView.contentView = cellForReuse;
            [self.rightRightPageView addSubview:self.rightRightPageView.contentView];
            
            self.lastPageIndex = 2;
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*2, 0);
            
        } else {
            self.lastPageIndex = pageIndex;
        }
        return;
    }
    
    pageIndex = ceil( scrollView.contentOffset.x / scrollView.frame.size.width );
    if (pageIndex == self.lastPageIndex) {
        return;
    }
    //show left
    if (pageIndex < self.lastPageIndex) {
        
        self.currentPageNumber = self.currentPageNumber - (self.lastPageIndex - pageIndex);
        
        if (pageIndex <= 1 && (self.currentPageNumber > 1) && pageCount > 5) {
            
            RTPageSlideViewCell *cellForReuse = self.rightRightPageView.contentView;
            
            self.rightRightPageView.tag = self.rightPageView.tag;
            self.rightRightPageView.contentView = self.rightPageView.contentView;
            [self.rightRightPageView addSubview:self.rightRightPageView.contentView];
            
            self.rightPageView.tag = self.centerPageView.tag;
            self.rightPageView.contentView = self.centerPageView.contentView;
            [self.rightPageView addSubview:self.rightPageView.contentView];
            
            self.centerPageView.tag = self.leftPageView.tag;
            self.centerPageView.contentView = self.leftPageView.contentView;
            [self.centerPageView addSubview:self.centerPageView.contentView];
            
            self.leftPageView.tag = self.leftLeftPageView.tag;
            self.leftPageView.contentView = self.leftLeftPageView.contentView;
            [self.leftPageView addSubview:self.leftPageView.contentView];
            
            [cellForReuse prepareForReuse];
            self.pageViewForReuse = cellForReuse;
            self.leftLeftPageView.tag = self.currentPageNumber - 2;
            cellForReuse = [self.contentDelegate slideView:self pageViewAtPageNumber:(self.currentPageNumber - 2)];
            self.leftLeftPageView.contentView = cellForReuse;
            [self.leftLeftPageView addSubview:self.leftLeftPageView.contentView];
            
            self.lastPageIndex = 2;
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*2, 0);
            
        } else {
            self.lastPageIndex = pageIndex;
        }
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageCount = [self.configurationDelegate pageCount:self];
    NSUInteger currentPageNumber = self.currentPageNumber;
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    
    if (currentPageNumber == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, width, height) animated:YES];
    } else if (currentPageNumber == 1) {
        [self.scrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:YES];
    } else if (currentPageNumber == pageCount - 1 && pageCount > 5) {
        [self.scrollView scrollRectToVisible:CGRectMake(width * 4, 0, width, height) animated:YES];
    } else if (currentPageNumber == pageCount - 2 && pageCount > 5) {
        [self.scrollView scrollRectToVisible:CGRectMake(width * 3, 0, width, height) animated:YES];
    } else if (pageCount <= 5) {
        [self.scrollView scrollRectToVisible:CGRectMake(width * currentPageNumber, 0, width, height) animated:YES];
    } else {
        [self.scrollView scrollRectToVisible:CGRectMake(width * 2, 0, width, height) animated:YES];
    }
    
    if (self.currentPageNumber != self.lastPageNumber) {
        
        RTPageSlideViewCell *cell = [self cellForSlideViewAtPageNumber:self.currentPageNumber];
        RTPageSlideViewSpot *spot = (RTPageSlideViewSpot *)cell.superview;
        
        if (self.lastPageNumber > self.currentPageNumber) {
            self.nextPageViewCell = spot.previousSpot.contentView;
            self.direction = RTSlideViewSlideDirectionLeft;
        } else {
            self.nextPageViewCell = spot.nextSpot.contentView;
            self.direction = RTSlideViewSlideDirectionRight;
        }
        
        [self.eventDelegate RTSlideViewDidChangedPage:self];
        self.lastPageNumber = self.currentPageNumber;
    }
    
}

@end
