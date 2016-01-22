//
//  ViewController.h
//  SlidingTabDemo
//
//  Created by kevin song on 22/01/2016.
//  Copyright © 2016 NotiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingMenu.h"
#import "MenuItem.h"

@interface ViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView * mainScrollView;
@property (nonatomic, strong) SlidingMenu * slidingMenu;
@property (nonatomic, strong) IBOutlet UIView * tabView;
@property (nonatomic, strong) NSArray * arrayItems;


@end

