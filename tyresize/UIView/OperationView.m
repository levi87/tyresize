//
//  OperationView.m
//  tyresize
//
//  Created by mac on 13-3-20.
//  Copyright (c) 2013年 thinktube. All rights reserved.
//

#import "OperationView.h"
#import "HandleView.h"
#import "AppDelegate.h"
#import "PassValueDelegate.h"
#import "GradientLabel.h"

@interface OperationView()

@property(strong, nonatomic)NSArray *WArray;
@property(strong, nonatomic)NSArray *AArray;
@property(strong, nonatomic)NSArray *RArray;

@property(strong, nonatomic)HandleView *nowWView;
@property(strong, nonatomic)HandleView *nowAView;
@property(strong, nonatomic)HandleView *nowRView;

@property(strong, nonatomic)HandleView *wantWView;
@property(strong, nonatomic)HandleView *wantAView;
@property(strong, nonatomic)HandleView *wantRView;

@property(strong, nonatomic)UIImageView *bgView;

@property(strong, nonatomic)GradientLabel *nowTitle;
@property(strong, nonatomic)GradientLabel *wantTitle;
@property(strong, nonatomic)UIButton *lockNowButton;
@property(readwrite, nonatomic)BOOL isLockNowButton;

@end

@implementation OperationView
@synthesize WArray;
@synthesize AArray;
@synthesize RArray;

@synthesize nowWView;
@synthesize nowAView;
@synthesize nowRView;
@synthesize wantWView;
@synthesize wantAView;
@synthesize wantRView;

@synthesize bgView;

@synthesize nowTitle;
@synthesize wantTitle;
@synthesize lockNowButton;
@synthesize isLockNowButton;
@synthesize delegate;

#define OFFSET_X            12.0f
#define OFFSET_Y            5.0f
#define HANDLE_WIDTH        135.0f
#define HANDLE_HEIGHT       (IS_IPHONE_5 ? 39.0f : 36.0f)
#define TITLE_HEIGHT        (IS_IPHONE_5 ? 39.0f : 26.0f)

#define LOCK_WIDTH          54.0f
#define LOCK_HEIGHT         38.0f
#define L_H                 (IS_IPHONE_5 ? 38.0f : 38.0f)
#define L_H_OFFSET          (IS_IPHONE_5 ? 16.0f : 20.0f)
#define LINE_HEIGHT         (OFFSET_Y + HANDLE_HEIGHT)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
        self.WArray = [[NSArray alloc]initWithObjects:
                       INT(125),INT(135),INT(145),INT(155),INT(165),INT(175),INT(185),INT(195),INT(205),INT(215),INT(225),INT(235),INT(245),INT(255),INT(265),
                       INT(275),INT(285),INT(295),INT(305),INT(315),INT(325),INT(335),INT(345),INT(355),INT(365),INT(375),INT(385),INT(395),INT(405),nil];
        
        self.AArray = [[NSArray alloc]initWithObjects:
                       INT(25),INT(30),INT(35),INT(40),INT(45),INT(50),INT(55),INT(60),INT(65),INT(70),INT(75),INT(80),INT(85),nil];
        self.RArray = [[NSArray alloc]initWithObjects:
                       INT(10),INT(11),INT(12),INT(13),INT(14),INT(15),INT(16),INT(17),INT(18),INT(19),INT(20),INT(21),INT(22),INT(23),INT(24),INT(25),INT(26),INT(27),INT(28),INT(29),INT(30),nil];
        
        // label
        self.nowTitle = [[GradientLabel alloc]initWithFrame:CGRectMake(0, L_H , TOTAL_WIDTH/2, TITLE_HEIGHT)];
        [self.nowTitle setText:T(@"YOUR TYRE")];
        
        self.wantTitle = [[GradientLabel alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, L_H, TOTAL_WIDTH/2, TITLE_HEIGHT)];
        [self.wantTitle setText:T(@"YOU WANT")];
        
        // lockNowButton
        self.lockNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.lockNowButton setFrame:CGRectMake(10, 0, LOCK_WIDTH, LOCK_HEIGHT)];
        [self.lockNowButton setTitle:@"" forState:UIControlStateNormal];
        [self.lockNowButton setBackgroundImage:[UIImage imageNamed:@"lock_on.png"] forState:UIControlStateNormal];
        [self.lockNowButton setBackgroundColor:[UIColor clearColor]];
        [self.lockNowButton addTarget:self action:@selector(lockNowAction) forControlEvents:UIControlEventTouchUpInside];
        self.isLockNowButton = NO;

        // now handle input datasource and frame
        
        self.nowWView = [[HandleView alloc]initWithFrame:CGRectMake(OFFSET_X, L_H + TITLE_HEIGHT, HANDLE_WIDTH, HANDLE_HEIGHT)];
        self.nowWView.dataArray = self.WArray;
        self.nowAView = [[HandleView alloc]initWithFrame:CGRectMake(OFFSET_X, L_H + TITLE_HEIGHT+LINE_HEIGHT, HANDLE_WIDTH, HANDLE_HEIGHT)];
        self.nowAView.dataArray = self.AArray;
        self.nowRView = [[HandleView alloc]initWithFrame:CGRectMake(OFFSET_X, L_H + TITLE_HEIGHT+LINE_HEIGHT*2, HANDLE_WIDTH, HANDLE_HEIGHT)];
        self.nowRView.dataArray = self.RArray;
        
        // want handle input datasource and frame

        self.wantWView = [[HandleView alloc]initWithFrame:CGRectMake(OFFSET_X+TOTAL_WIDTH/2, L_H + TITLE_HEIGHT, HANDLE_WIDTH, HANDLE_HEIGHT)];
        self.wantWView.dataArray = self.WArray;
        self.wantAView = [[HandleView alloc]initWithFrame:CGRectMake(OFFSET_X+TOTAL_WIDTH/2, L_H + TITLE_HEIGHT+LINE_HEIGHT, HANDLE_WIDTH, HANDLE_HEIGHT)];
        self.wantAView.dataArray = self.AArray;
        self.wantRView = [[HandleView alloc]initWithFrame:CGRectMake(OFFSET_X+TOTAL_WIDTH/2, L_H + TITLE_HEIGHT+LINE_HEIGHT*2, HANDLE_WIDTH, HANDLE_HEIGHT)];
        self.wantRView.dataArray = self.RArray;
        
        // default now and want value 六个input的初始值
        
        self.nowWView.index = DEFAULT_NOWW_INDEX;
        self.nowAView.index = DEFAULT_NOWA_INDEX;
        self.nowRView.index = DEFAULT_NOWR_INDEX;
        self.wantWView.index = DEFAULT_WANTW_INDEX;
        self.wantAView.index = DEFAULT_WANTA_INDEX;
        self.wantRView.index = DEFAULT_WANTR_INDEX;
        
        // delegate 
        self.nowWView.delegate = [self appDelegate].mainViewController;
        self.nowAView.delegate = [self appDelegate].mainViewController;
        self.nowRView.delegate = [self appDelegate].mainViewController;
        self.wantWView.delegate = [self appDelegate].mainViewController;
        self.wantAView.delegate = [self appDelegate].mainViewController;
        self.wantRView.delegate = [self appDelegate].mainViewController;
        
        
        
        // pos index
        self.nowWView.posIndex = NOWW_INDEX;
        self.nowAView.posIndex = NOWA_INDEX;
        self.nowRView.posIndex = NOWR_INDEX;
        self.wantWView.posIndex = WANTW_INDEX;
        self.wantAView.posIndex = WANTA_INDEX;
        self.wantRView.posIndex = WANTR_INDEX;
        
        //BG View
        self.bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"operView_bg.png"]];
        self.bgView.frame = CGRectMake(0, L_H-L_H_OFFSET , TOTAL_WIDTH, OPER_VIEW_HEIGHT-L_H+L_H_OFFSET);
        
//        [self setBackgroundColor:[UIColor colorWithRed:33.0f green:35.0f blue:38.0f alpha:1.0]];
        [self setBackgroundColor:[UIColor clearColor]];

        // add to view
        // add 晚的后计算
        [self addSubview:self.lockNowButton];
        [self addSubview:self.bgView];

        [self addSubview:self.wantWView];
        [self addSubview:self.wantAView];
        [self addSubview:self.wantRView];
        
        [self addSubview:self.nowWView];
        [self addSubview:self.nowAView];
        [self addSubview:self.nowRView];
        
        [self addSubview:self.nowTitle];
        [self addSubview:self.wantTitle];
        
    }
    return self;
}

- (void)lockNowAction
{
    if (self.isLockNowButton) {
        [self.lockNowButton setBackgroundImage:[UIImage imageNamed:@"lock_on.png"] forState:UIControlStateNormal];
        [self.nowWView setLockStatus:NO];
        [self.nowRView setLockStatus:NO];
        [self.nowAView setLockStatus:NO];
        self.isLockNowButton = NO;
        // delegate
        [self.delegate unlockNowTyre];
    }else{
        [self.lockNowButton setBackgroundImage:[UIImage imageNamed:@"lock_off.png"] forState:UIControlStateNormal];
        [self.nowWView setLockStatus:YES];
        [self.nowRView setLockStatus:YES];
        [self.nowAView setLockStatus:YES];
        self.isLockNowButton = YES;
        // delegate
        [self.delegate lockNowTyre];
    }

}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
