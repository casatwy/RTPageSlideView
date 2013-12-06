## RTPageSlideView

This is a slide page componenet for iOS development.

It works just like `UITableView`.

This component consists of three objects like `RTPageSlideView`, `RTPageSlideViewCell`, `RTPageSlideViewSpot`.

You use `RTPageSlideView` like `UITableView`, use `RTPageSlideViewCell` like `UITableCell`. 

You won't use `RTPageSlideViewSpot` anywhere in your project, this object is used in `RTPageSlideView` as a container to hold `RTPageSlideViewCell`.


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

### Delegates

your controller should implement some delegate methods so that `RTPageSlideView` can make itself well defined;

#### RTPageSlideViewConfigurationDelegate 

##### - (CGRect)pageFrame:(RTPageSlideView *)pageSlideView

```
    -----------------------------------------------------------------
    |this view's frame == pageSlideView.frame                       |
    |                                                               |
    |   ---------------------------------------------------------   |
    |   | RTPageSlideView need to know this page's frame        |   |
    |   |                                                       |   |
    |   | and this frame is returned by this delegate method    |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   |                                                       |   |
    |   ---------------------------------------------------------   |
    |                                                               |
    -----------------------------------------------------------------
```

`RTPageSlideView` asks its `RTPageSlideViewConfigurationDelegate` for the inner page frame to set the position.




##### - (NSInteger)pageCount:(RTPageSlideView *)pageSlideView;

this is just like `- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section`, and we don't have sections.




##### - (CGFloat)pageGap:(RTPageSlideView *)pageSlideView;

```
    ------------------------------------------------------------
    |                                                          |
    |----         --------------------------------         ----| 
    |   |  this   |                              |  this   |   |
    |   |  is     |                              |  is     |   |
    |   |<- the ->|                              |<- the ->|   |
    |   |  page   |                              |  page   |   |
    |   |  gap    |                              |  gap    |   |
    |   |         |                              |         |   |
    |   |         |                              |         |   |
    |   |         |                              |         |   |
    |   |         |                              |         |   |
    |   |         |                              |         |   |
    |   |         |                              |         |   |
    |   |         |                              |         |   |
    |   |         |                              |         |   |
    |   |         |                              |         |   |
    |   |         |                              |         |   |
    |   |         |                              |         |   |
    |   |         |                              |         |   |
    |----         --------------------------------         ----|
    |                                                          |
    ------------------------------------------------------------
```




##### asdfasdfasdf 








