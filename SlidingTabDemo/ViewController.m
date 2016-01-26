//
//  ViewController.m
//  SlidingTabDemo
//
//  Created by kevin song on 22/01/2016.
//  Copyright © 2016 NotiTech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
//    //do something like background color, title, etc you self
    [self.view addSubview:navbar];
    
    self.arrayItems = [[NSArray alloc] initWithObjects:@"Top News",@"Top Videos",@"Sports", @"FootBall", @"BasketBall", @"Travel", @"Snooker", nil];
    
    self.slidingMenu = [[SlidingMenu alloc] initWithMenuItems:self.arrayItems withFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    
    self.slidingMenu.delegate = self;
    
    self.tabView.backgroundColor = [UIColor blackColor];
    [self.tabView addSubview:self.slidingMenu];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 84, self.view.bounds.size.width, self.view.bounds.size.height - 84)];
    
    self.mainScrollView.delegate = self;
    self.mainScrollView.pagingEnabled = YES;
    
    [self.mainScrollView setContentSize:CGSizeMake(self.view.bounds.size.width* [self.arrayItems count], self.view.bounds.size.height - 84)];
    
    [self.view addSubview:self.mainScrollView];

    [self AddTitleToPage];
}

-(void)AddTitleToPage
{
    for (int i=0; i<[self.arrayItems count]; i++) {
        
        UILabel * temp = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 50)];
        
        UIView * pageView = [[UIView alloc] initWithFrame:CGRectMake(i*320, 0, self.view.bounds.size.width, self.view.bounds.size.height-84)];
        
        [pageView addSubview:temp];
        temp.text = [ self.arrayItems objectAtIndex:i];
        temp.textAlignment= NSTextAlignmentCenter;
        [self.mainScrollView addSubview:pageView];
    }

    UIView * pageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-84)];
    [self.mainScrollView addSubview:pageView];
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 2;
    [self.slidingMenu setCurrentActiveItem:page];
}

- (void)MenuItemPressed:(int)page
{
    [self.mainScrollView setContentOffset:CGPointMake((page-1)*self.view.bounds.size.width, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
