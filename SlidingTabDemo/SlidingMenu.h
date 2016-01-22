//
//  URSlidingMenu.h
//
//  Created by kevin song on 21/01/2016.
//  Copyright (c) 2016 kevin song
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"


@protocol SlidingMenuDelegate <NSObject>

-(void)MenuItemPressed:(int)page;

@end

@interface SlidingMenu : UIView

@property (nonatomic, weak) id <SlidingMenuDelegate> delegate;

@property (nonatomic, strong) NSArray * allItems;
@property (nonatomic, strong) NSArray * menuItems;
@property (nonatomic, strong) NSMutableArray * menuButtons;
@property (nonatomic, strong) UIScrollView * menuScrollView;
@property (nonatomic, strong) UIView * underLine;

@property (nonatomic, strong) UIFont * menuItemFont;
@property (nonatomic, assign) int menuItemPadding;
@property (nonatomic) UIColor * menuItemTitleColor;
@property (nonatomic, assign) int menuItemHeight;
@property (nonatomic, assign) int paddingTop;
@property (nonatomic, assign) int screenWidth;
@property (nonatomic, assign) int contentWidth;
@property (nonatomic, assign) int underLineHeight;
@property (nonatomic, assign) int currentItem;


-(id)initWithMenuItems:(NSArray *)allItems withFrame:(CGRect)frame;
-(void)setMenuBackGroundColor:(UIColor *)color;
-(void)setCurrentActiveItem:(int)currentPage;


@end
