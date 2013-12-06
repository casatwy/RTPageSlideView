## RTPageSlideView

This is a slide page componenet for iOS development.

It works just like `UITableView`.

This component consists of three objects like `RTPageSlideView`, `RTPageSlideViewCell`, `RTPageSlideViewSpot`.

You use `RTPageSlideView` like `UITableView`, use `RTPageSlideViewCell` like `UITableCell`. 

You won't use `RTPageSlideViewSpot` anywhere in your project, this object is used in `RTPageSlideView` as a container to hold `RTPageSlideViewCell`.

the page number is start from 0.

---

### How To Use It

In your ViewController you implement `RTPageSlideView` like this:

controller.h:

```
    @interface CustomViewController : UIViewController <RTPageSlideViewConfigurationDelegate,
                                                        RTPageSlideViewContentDelegate,
                                                        RTPageSlideViewEventDelegate>

        @property (nonatomic, strong) RTPageSlideView *pageSlideView;

    @end
```

controller.m:

```
    RTPageSlideView *pageSlideView = [RTPageSlideView alloc] init];

    pageSlideView.frame = CGRectMake(0, 0, 1024, 768);
    pageSlideView.configurationDelegate = self;
    pageSlideView.contentDelegate = self;
    pageSlideView.eventDelegate = self;

    self.pageSlideView = pageSlideView;

    //you can also set property of pageSlideView just like UIView
    self.pageSlideView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];

    //then you will set current page number for slide view
    //animated always no, because I didn't impelment this feature yet, and I'm working on this feature.:P
    [self.propertyDetailSlideView setCurrentPageNumber:10 animated:NO];

    //now you add this slide view to your ViewController's view
    [self.view addSubview:self.pageSlideView];

```

---

### Delegates

your controller should implement some delegate methods so that `RTPageSlideView` can make itself well defined;

#### RTPageSlideViewConfigurationDelegate 

##### [required] - (CGRect)pageFrame:(RTPageSlideView *)pageSlideView

```
    -----------------------------------------------------------------------------------------------
    |this view's frame == pageSlideView.frame                                                     |
    |                                                                                             |
    |   ---------------------------------------------------------------------------------------   |
    |   | RTPageSlideView need to know this page's frame                                      |   |
    |   |                                                                                     |   |
    |   | and this frame is returned by this delegate method                                  |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   |                                                                                     |   |
    |   ---------------------------------------------------------------------------------------   |
    |                                                                                             |
    -----------------------------------------------------------------------------------------------
```

`RTPageSlideView` asks its `RTPageSlideViewConfigurationDelegate` for the inner page frame to set the position.


##### [required] - (NSInteger)pageCount:(RTPageSlideView *)pageSlideView;

this is just like `- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section`, and we don't have sections.


##### [optional] - (CGFloat)pageGap:(RTPageSlideView *)pageSlideView;

```
    ----------------------------------------------------------------------------------------------
    |                                                                                            |
    |----         ------------------------------------------------------------------         ----| 
    |   |  this   |                                                                |  this   |   |
    |   |  is     |                                                                |  is     |   |
    |   |<- the ->|                                                                |<- the ->|   |
    |   |  page   |                                                                |  page   |   |
    |   |  gap    |                                                                |  gap    |   |
    |   |         |                                                                |         |   |
    |   |         |                                                                |         |   |
    |   |         |                                                                |         |   |
    |   |         |                                                                |         |   |
    |   |         |                                                                |         |   |
    |   |         |                                                                |         |   |
    |   |         |                                                                |         |   |
    |   |         |                                                                |         |   |
    |   |         |                                                                |         |   |
    |   |         |                                                                |         |   |
    |   |         |                                                                |         |   |
    |   |         |                                                                |         |   |
    |----         ------------------------------------------------------------------         ----|
    |                                                                                            |
    ----------------------------------------------------------------------------------------------
```

the default value of page gap is 0.


#### RTPageSlideViewContentDelegate 

##### [required] - (RTPageSlideViewCell *)slideView:(RTPageSlideView *)slideView pageViewAtPageNumber:(NSInteger)pageNumber;

the page number is start from 0.

this method works like `- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath`

and here is a sample code:

```
- (RTPageSlideViewCell *)slideView:(RTPageSlideView *)slideView pageViewAtPageNumber:(NSInteger)pageNumber
{

    //HZSearchPropertyDetailSlidePageCell is inherit from RTPageSlideViewCell
    //we have reuse cell, too. Which comes from RTPageSlideView.pageViewForReuse
    HZSearchPropertyDetailSlidePageCell *cell = (HZSearchPropertyDetailSlidePageCell *)self.propertyDetailSlideView.pageViewForReuse;

    //reuse cell could be nil, so you should check it.
    if (cell == nil) {
        cell = [[HZSearchPropertyDetailSlidePageCell alloc] init];
    }
    [cell configWithData:self.cellData]; 
    return cell;

}
```


#### RTPageSlideViewEventDelegate

##### [required] - (void)RTSlideViewDidChangedPage:(RTPageSlideView *)slideView;

this method intends to tell you that the page did changed, you can do some feature after user slided a page.

But when user slide the page very fast, this method won't be called while page changes. it was triggered only after the anmation stops. 

---

### Objects Related In This Component 

#### RTPageSlideView

###### [property] scrollView

`@property (nonatomic, readonly) UIScrollView *scrollView;`

this is the scrollView in this component, and it is readonly, you can get some `UIScrollView` related properties or feature by using `slidePageView.scrollView`

you won't use this property in normal cases.

###### [property] currentPageNumber

`@property (nonatomic, readonly) NSInteger currentPageNumber;`

the page number is start from 0.

you can get the current page number by this property, and it is readonly.

if you wanna change the current page by changing current page number, use `setCurrentPageNumber:animated:` method.

###### [property] pageViewForReuse

`@property (nonatomic, weak) RTPageSlideViewCell *pageViewForReuse;`

you use this property when `- (RTPageSlideViewCell *)slideView:(RTPageSlideView *)slideView pageViewAtPageNumber:(NSInteger)pageNumber` invokes

###### [property] nextPageViewCell

`@property (nonatomic, weak) RTPageSlideViewCell *nextPageViewCell;`

you can use this property to pre-load your cell when `- (void)RTSlideViewDidChangedPage:(RTPageSlideView *)slideView;` invokes.

when your slide direction is left, the next cell will be the right cell, when your slide direction is right, the next cell will be the left cell.

###### [property] direction

`@property (nonatomic) RTSlideViewSlideDirection direction;`

this property indicates the direction that user slides. It is an enum:

```
typedef NS_ENUM (NSUInteger, RTSlideViewSlideDirection){
    RTSlideViewSlideDirectionLeft = 0,
    RTSlideViewSlideDirectionRight = 1
};
```

###### [method] setCurrentPageNumber:animated:

`- (void)setCurrentPageNumber:(NSInteger)currentPageNumber animated:(BOOL)isAnimated;`

the page number is start from 0.

you can decide which page will be presented using this method. animated is always no, because I haven't implement it yet.

###### [method] reloadSlideViewsWithCurrentPageNumber:

`- (void)reloadSlideViewsWithCurrentPageNumber:(NSInteger)currentPageNumber;`

the page number is start from 0.

you can reload `RTSlidePageView` using this method just like `[tableView reload]`

and you should tell `RTSlidePageView` which page will be shown after reload, you can do this: 

`[slidePageView reloadSlideViewsWithCurrentPageNumber:slidePageView.currentPageNumber]`

to reload pageSlideView without changing its current page content.

###### [method] cellForSlideViewAtPageNumber:

`- (RTPageSlideViewCell *)cellForSlideViewAtPageNumber:(NSInteger)pageNumber;`

the page number is start from 0.

you can get your cell by this method. but you can only get the cell which is in this component.

this compoenent holds 5 pages.

if your current page number is 0. the page number of cell you can reach is 0, 1, 2, 3, 4

if your current page number is 1. the page number of cell you can reach is 0, 1, 2, 3, 4

if your current page number is totalCount - 1, let's say this page number is x, that means this is the last page. the page number of cell you can reach is x-4, x-3, x-2, x-1, x 

if your current page number is totalCount - 2, let's say this page number is x, that means this is the last second page. the page number of cell you can reach is x-3, x-2, x-1, x, x+1 

if your current page number is about the middle of total page count, let's say that x. the page number of cell you can reach is x-2, x-1, x, x+1, x+2.

you can't reach other page cell which page number is out of this range.

Hoping some one to help me optimize this feature, make it more like `UITableView cellForRowAtIndexPath:`, I'm really appreciate with your help. 

#### RTPageSlideViewCell

your own cell should inherit from this object so that page slide view can work correctly.

here is a simple sample to show you how to use this:

CustomPageSlideViewCell.h

```
#import "RTPageSlideViewCell.h"

@interface CustomPageSlideViewCell : RTPageSlideViewCell

//your own method to config your cell
- (void)configWithData:(NSDictionary *)celldata;

@end
```

CustomPageSlideViewCell.m

```
@implementation CustomPageSlideViewCell

- (void)configWithData:(NSDictionary *)celldata
{
    UILabel *label = [[UILabel alloc] init];
    label.text = celldata[@"title"];

    //just add subview will do.
    [self addSubview:label];
}

- (void)prepareForReuse
{
    //do your own staff here, just like UITableViewCell's prepareForReuse.
    //this method is a override.

    [super prepareForReuse];
}

@end
```

##### [method] prepareForReuse

`- (void)prepareForReuse;`

you use this method to clean data or perform something you wanna do before reuse. just like `UITableViewCell`'s `prepareForReuse` method.


## DONE
