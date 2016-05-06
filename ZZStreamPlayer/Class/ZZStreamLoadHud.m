//
//  ZZStreamLoadHud.m
//  ZZStreamPlayer
//
//  Created by 袁亮 on 16/4/18.
//  Copyright © 2016年 Migic_Z. All rights reserved.
//

#import "ZZStreamLoadHud.h"

@interface ZZStreamLoadHud()

@property (strong ,nonatomic) UIView *hudView;
@property (strong ,nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong ,nonatomic) UILabel *hudLabel;

@property (assign ,nonatomic) CGPoint hengPoint;
@property (assign ,nonatomic) CGPoint shuPoint;

@end

@implementation ZZStreamLoadHud

+(ZZStreamLoadHud *)sharedHud
{
    static ZZStreamLoadHud *hud = nil;
    if (hud == nil) {
        hud = [[ZZStreamLoadHud alloc]init];
    }
    return hud;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _shuPoint = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 3 / 2);
        _hengPoint = CGPointMake([UIScreen mainScreen].bounds.size.height / 2, [UIScreen mainScreen].bounds.size.width / 2);

        [self makeHudUI];
    }
    return self;
}

-(void) makeHudUI
{
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicatorView.frame = CGRectMake(45, 15, 30, 30);
    [self addSubview:_indicatorView];
    [_indicatorView startAnimating];
    
    _hudLabel = [[UILabel alloc] init];
    _hudLabel.frame = CGRectMake(0,40, 120, 50);
    _hudLabel.textAlignment = NSTextAlignmentCenter;
    _hudLabel.text = @"直播链接中...";
    _hudLabel.font = [UIFont systemFontOfSize:15];
    _hudLabel.textColor = [UIColor whiteColor];
    [self addSubview:_hudLabel];
}

-(void)showHudInView:(UIView *)view
{

    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.8;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 7.0;
    self.frame = CGRectMake(0, 0, 120, 90);
    self.center = _shuPoint;
    [view addSubview:self];
    
    [self listeningRotating];
}

-(void)hideHidInView
{
    [self.indicatorView stopAnimating];
    [self removeFromSuperview];
}

#pragma mark - 监听设备旋转方向

- (void)listeningRotating{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
}

- (void)onDeviceOrientationChange{
    
    UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    [self transformScreenDirection:interfaceOrientation];
    
}


-(void)transformScreenDirection:(UIInterfaceOrientation)direction
{
    
    if (direction == UIInterfaceOrientationPortrait) {
        self.center = _shuPoint;
    }else if(direction == UIInterfaceOrientationLandscapeRight){
        self.center = _hengPoint;
    }else if (direction == UIInterfaceOrientationLandscapeLeft){
        self.center = _hengPoint;
    }
}



@end
