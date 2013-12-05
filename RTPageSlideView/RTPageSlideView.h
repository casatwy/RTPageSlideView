//
//  RTPageScrollView.h
//  com.anjuke.scrollView
//
//  Created by casa on 13-10-23.
//  Copyright (c) 2013年 casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTPageSlideViewCell.h"

@protocol RTPageSlideViewConfigurationDelegate;
@protocol RTPageSlideViewContentDelegate;
@protocol RTPageSlideViewEventDelegate;

typedef NS_ENUM (NSUInteger, RTSlideViewSlideDirection){
    RTSlideViewSlideDirectionLeft = 0,
    RTSlideViewSlideDirectionRight = 1
};


#pragma mark - RTPageSlideView


@interface RTPageSlideView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<RTPageSlideViewConfigurationDelegate> configurationDelegate;
@property (nonatomic, weak) id<RTPageSlideViewContentDelegate> contentDelegate;
@property (nonatomic, weak) id<RTPageSlideViewEventDelegate> eventDelegate;

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) NSInteger currentPageNumber;

@property (nonatomic, weak) RTPageSlideViewCell *pageViewForReuse;
@property (nonatomic, weak) RTPageSlideViewCell *nextPageViewCell;

@property (nonatomic) RTSlideViewSlideDirection direction;

- (void)setCurrentPageNumber:(NSInteger)currentPageNumber animated:(BOOL)isAnimated;
- (void)reloadSlideViewsWithCurrentPageNumber:(NSInteger)currentPageNumber;
- (RTPageSlideViewCell *)cellForSlideViewAtPageNumber:(NSInteger)pageNumber;//不适用尚未进入缓存的页面

@end


#pragma mark - RTPageSlideViewConfigurationDelegate


@protocol RTPageSlideViewConfigurationDelegate <NSObject>

@required

- (CGRect)pageFrame:(RTPageSlideView *)pageSlideView;
- (NSInteger)pageCount:(RTPageSlideView *)pageSlideView;

@optional

- (CGFloat)pageGap:(RTPageSlideView *)pageSlideView;

@end


#pragma mark - RTPageSlideViewContentDelegate


@protocol RTPageSlideViewContentDelegate <NSObject>

@required

- (RTPageSlideViewCell *)slideView:(RTPageSlideView *)slideView pageViewAtPageNumber:(NSInteger)pageNumber;

@end


#pragma mark - RTPageSlideViewEventDelegate


@protocol RTPageSlideViewEventDelegate <NSObject>

@optional

- (void)RTSlideViewDidChangedPage:(RTPageSlideView *)slideView;

@end