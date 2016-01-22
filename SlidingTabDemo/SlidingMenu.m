//
//  SlidingMenu.m
//
//  Created by kevin song on 21/01/2016.
//  Copyright (c) 2016 kevin song
//

#import "SlidingMenu.h"

@implementation SlidingMenu


-(id)initWithMenuItems:(NSArray *)allItems withFrame:(CGRect)frame
{
    self = [super initWithFrame: CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height) ];
    if (self) {
        self.allItems = allItems;
        self.menuScrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.menuItemFont = [UIFont systemFontOfSize:13];
        self.menuItemPadding = 10;
        self.menuItemTitleColor = [UIColor darkGrayColor];
        self.menuButtons = [NSMutableArray array];
        self.menuItemHeight = 30;
        self.screenWidth = frame.size.width;
        self.underLineHeight = 5;
        self.paddingTop = frame.size.height - self.underLineHeight;
        self.underLine =[[UIView alloc] initWithFrame:CGRectMake(0, self.paddingTop, 50, self.underLineHeight)];
        self.underLine.backgroundColor = [UIColor darkGrayColor];
        
        self.currentItem = 1;
        
        [self InitScrollView];
        [self.menuScrollView addSubview:self.underLine];
        [self addSubview:self.menuScrollView];
        [self processMenuScrollView];
    }
    return self;
}

-(void)InitScrollView
{
    [self.menuScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.menuScrollView setScrollsToTop:NO];
    [self.menuScrollView setShowsHorizontalScrollIndicator:NO];
    [self.menuScrollView setShowsVerticalScrollIndicator:NO];
    [self.menuScrollView setBounces:YES];
    [self.menuScrollView setPagingEnabled:NO];
    [self.menuScrollView setDirectionalLockEnabled:YES];
    [self.menuScrollView setAlwaysBounceHorizontal:YES];
    [self.menuScrollView setAlwaysBounceVertical:NO];
}

-(void)setMenuBackGroundColor:(UIColor *)color
{
    self.menuScrollView.backgroundColor = color;
}


-(void)setCurrentActiveItem:(int)currentPage
{
    UIButton * button;
    
    for(UIButton * btn in self.menuButtons){
        if(btn.tag == currentPage){
            button = btn;
            break;
        }
    }
    
    //due to multipages under one tab
    if ((currentPage == 0 && self.currentItem == 1) || (currentPage == 1 && self.currentItem == 1 )){
        return;
    }
    [self MenuButtonPressed:button UpdatePager:NO];
}


-(void)processMenuScrollView
{
    int width = 0;
    NSMutableArray * array = [NSMutableArray array];
    
    for (int i = 0; i<[self.allItems count]; i++) {
        
        NSString * tempItem = [self.allItems objectAtIndex:i];
        CGSize stringSize = [tempItem sizeWithAttributes:@{NSFontAttributeName:self.menuItemFont}];
        width = width + 2 * self.menuItemPadding + stringSize.width;
        
        URMenuItem * item = [[URMenuItem alloc] init];
        [item setMenuItemId:[NSNumber numberWithInt:(i+1)]];
        [item setMenuItemName:tempItem];
        [item setMenuItemWidth:(2 * self.menuItemPadding + stringSize.width)];
        
        [array addObject:item];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+1;
        [btn addTarget:self
                         action:@selector(MenuButtonPressedFromTab:)
               forControlEvents:UIControlEventTouchUpInside];

        
        [btn setTitle:item.menuItemName forState:UIControlStateNormal];
        [btn.titleLabel setFont:self.menuItemFont];
        [btn setTitleColor:self.menuItemTitleColor forState:UIControlStateNormal];
        
        [self.menuButtons addObject:btn];
    }
    
    self.menuItems = array;
    self.contentWidth = width;
    [self.menuScrollView setContentSize:CGSizeMake(width, self.menuScrollView.bounds.size.height)];
    
    [self AddingMenuButtonsToScrollView];
}

-(void)AddingMenuButtonsToScrollView
{
    for (int i= 0; i<[self.menuButtons count]; i++) {
        if (i==0) {
            UIButton * button = [self.menuButtons objectAtIndex:i];
            URMenuItem * item = [self.menuItems objectAtIndex:i];
            [button setFrame:CGRectMake(0, 5, item.menuItemWidth, self.menuItemHeight)];
            [self.menuScrollView addSubview:button];
            [self.underLine setFrame:CGRectMake(button.bounds.origin.x, self.paddingTop, button.bounds.size.width, self.underLineHeight)];
        }else{
            UIButton * button = [self.menuButtons objectAtIndex:i];
            URMenuItem * item = [self.menuItems objectAtIndex:i];
            int width = 0;
            for (int j=0; j<i; j++) {
                URMenuItem * temp = [self.menuItems objectAtIndex:j];
                width = width + temp.menuItemWidth;
            }
            [button setFrame:CGRectMake(width, 5, item.menuItemWidth, self.menuItemHeight)];
            [self.menuScrollView addSubview:button];
        }
    }
}

-(void)MenuButtonPressedFromTab:(UIButton *)sender
{
    [self MenuButtonPressed:sender UpdatePager:YES];
}


-(void)MenuButtonPressed:(UIButton *)sender UpdatePager:(BOOL)update
{
    UIButton * button;
    for(UIButton * btn in self.menuButtons){
        if (btn.tag == sender.tag) {
            button = btn;
        }
    }
    
    int start = button.frame.origin.x;
    
    //move underline to position
    [UIView animateWithDuration:0.3 animations:^{
        self.underLine.frame = CGRectMake(start, self.paddingTop, button.bounds.size.width, self.underLineHeight);
    }];
    
     if(start < self.screenWidth/2){
        if(self.menuScrollView.contentOffset.x>0){
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.menuScrollView setContentOffset:CGPointMake(0 , 0)];
            }];
        }
     }else{
         
        int spaceLeft = self.contentWidth - start - button.frame.size.width;
       
         if(spaceLeft>self.screenWidth/2){
             
            [UIView animateWithDuration:0.3 animations:^{
                [self.menuScrollView setContentOffset:CGPointMake(start - self.screenWidth/2 + button.frame.size.width/2 , 0)];
            }];
        }else{
            
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint leftOffset = CGPointMake(self.menuScrollView.contentSize.width - self.menuScrollView.bounds.size.width, 0);
                [self.menuScrollView setContentOffset: leftOffset];
            
            }];
        }
    }
    self.currentItem = (int)sender.tag;
    if (update) {
        [self.delegate URMenuItemPressed:(int)sender.tag];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
