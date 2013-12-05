//
//  RTPageSlideViewSpot.h
//  AnjukeHD
//
//  Created by casa on 10/30/13.
//  Copyright (c) 2013 anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTPageSlideViewCell.h"

@interface RTPageSlideViewSpot : UIView

@property (nonatomic, strong) RTPageSlideViewCell *contentView;
@property (nonatomic, weak) RTPageSlideViewSpot *previousSpot;
@property (nonatomic, weak) RTPageSlideViewSpot *nextSpot;

@end
