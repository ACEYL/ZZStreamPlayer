//
//  ZZStreamPlayerView.m
//  ZZStreamPlayer
//
//  Created by 袁亮 on 16/4/18.
//  Copyright © 2016年 Migic_Z. All rights reserved.
//

#import "ZZStreamPlayerView.h"
#import "ZZStreamFullSCreenView.h"
#import "ZZStreamLoadHud.h"

@interface ZZStreamPlayerView ()

@property (nonatomic, assign) CGRect smallFrame;
@property (nonatomic, assign) CGRect bigFrame;

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL isShowBig;
@property (nonatomic, strong) ZZStreamFullSCreenView *full_screen_view;

@end

@implementation ZZStreamPlayerView

#pragma 懒加载
-(AVURLAsset *)urlAsset
{
    if (!_urlAsset) {
        NSURL *streamUrl = [NSURL URLWithString:_stream_url];
        _urlAsset = [AVURLAsset assetWithURL:streamUrl];
    }
    return _urlAsset;
}

-(AVPlayerItem *)playerItem
{
    if (!_playerItem) {
        _playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    }
    return _playerItem;
}

-(AVPlayer *)player
{
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    return _player;
}

-(AVPlayerLayer *)playerLayer
{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _playerLayer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
    }
    return _playerLayer;
}

-(instancetype)initWithFrame:(CGRect)frame playerWithUrl:(NSString *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        self.stream_url = url;
        
        
        self.backgroundColor = [UIColor blackColor];
        
        self.smallFrame = frame;
        self.bigFrame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        
        //注册监听
        [self registMonitor];
        //直播开始
        [self startStreamPlayer];
        //视频底层控件
        [self.layer addSublayer:self.playerLayer];
        
        //实例化小屏幕UI
        [self makeSmallScreenUI];
        //添加小屏幕Button 到  SELF
        [self addSmallScreenUI];
        
        [self listeningRotating];
        
        //实例化全屏UI
        [self initFullScrennViewUI];
        
        _isFullScreen = NO;
        _isShow = YES;
        _isShow = YES;
        
    }
    return self;
}


#pragma 注册监听
-(void) registMonitor
{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听直播流突然中断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(streamConnectLeaveOff) name:AVPlayerItemPlaybackStalledNotification object:self.playerItem];
}

-(void)startStreamPlayer
{
    [[ZZStreamLoadHud sharedHud] showHudInView:self];
    NSLog(@"开始直播");
    //开始播放吧
    [self.player play];

}

//直播中断
-(void) streamConnectLeaveOff
{
    [[ZZStreamLoadHud sharedHud] showHudInView:self];
    NSLog(@"视屏突然中断");
}

//KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        
        if ([playerItem status] == AVPlayerItemStatusUnknown) {
            
            NSLog(@"直播的有问题");
            
        }else if([playerItem status] == AVPlayerItemStatusReadyToPlay){
            [[ZZStreamLoadHud sharedHud] removeFromSuperview];
        }
    }
}

//释放
-(void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self.playerItem];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    
    self.playerLayer.frame = self.bounds;
}

#pragma make --- 实例化小屏幕UI
-(void) makeSmallScreenUI
{
    _backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 30, 30)];
    _backButton.layer.masksToBounds = YES;
    _backButton.layer.borderWidth = 1.0;
    _backButton.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:160.0 / 255.0 green:160.0 / 255.0 blue:160.0 / 255.0 alpha:1]);
    [_backButton setImage:[UIImage imageNamed:@"ks_stream_back_btn.png"] forState:UIControlStateNormal];
    
    
    _sharedButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 50, 20, 30, 30)];
    [_sharedButton setImage:[UIImage imageNamed:@"ks_stream_shared_btn.png"] forState:UIControlStateNormal];

    
    _fullScreenButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 50, self.frame.size.height - 50, 30, 30)];
    [_fullScreenButton setImage:[UIImage imageNamed:@"ks_stream_fullscreen_btn.png"] forState:UIControlStateNormal];
    [_fullScreenButton addTarget:self action:@selector(fullScreenMethod:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) fullScreenMethod:(UIButton *)sender
{
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

#pragma mark --- 添加小屏幕UI至SELF

-(void) addSmallScreenUI
{
    [self addSubview:_backButton];
    [self addSubview:_sharedButton];
    [self addSubview:_fullScreenButton];
}

#pragma mark --- 移除小屏幕UI从SELF

-(void) removeSmallScreenUI
{
    [_backButton removeFromSuperview];
    [_sharedButton removeFromSuperview];
    [_fullScreenButton removeFromSuperview];
}

#pragma mark --- 全屏UI 实例化
//全屏按钮以及view
-(void) initFullScrennViewUI
{
    _full_screen_view = [[ZZStreamFullSCreenView alloc]init];
    
    [_full_screen_view.lessenButton addTarget:self action:@selector(smallScreenMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [_full_screen_view.sendButton addTarget:self action:@selector(sendMessageMethod:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark --- 添加全屏UI
-(void) addFullScreenUI:(CGRect)frame
{
    _full_screen_view.frame = frame;
    [self addSubview:_full_screen_view];
}
#pragma mark --- 移除全屏UI
-(void) removeFullScreenUI
{
    [_full_screen_view removeFromSuperview];
}

-(void) smallScreenMethod:(UIButton *)sender
{
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

-(void) sendMessageMethod:(UIButton *)sender
{
    NSLog(@"发送方法");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_isFullScreen == NO) {
        if (_isShow == YES) {
            _isShow = NO;
            [self removeSmallScreenUI];
        }else{
            _isShow = YES;
            [self addSmallScreenUI];
        }
    }else{
        if (_isShowBig == YES) {
            _isShowBig = NO;
            [self removeFullScreenUI];
        }else{
            _isShowBig = YES;
            [self addFullScreenUI:self.bigFrame];
        }
        
    }
    
}


- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
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
        _isFullScreen = NO;
        self.frame = self.smallFrame;
        [self addSmallScreenUI];
        [self removeFullScreenUI];

    }else if(direction == UIInterfaceOrientationLandscapeRight)
    {
        _isFullScreen = YES;
        self.frame = self.bigFrame;
        [self removeSmallScreenUI];
        [self addFullScreenUI:self.bigFrame];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    }else if (direction == UIInterfaceOrientationLandscapeLeft){
        _isFullScreen = YES;
        self.frame = self.bigFrame;
        [self removeSmallScreenUI];
        [self addFullScreenUI:self.bigFrame];
        
    }
}


@end
