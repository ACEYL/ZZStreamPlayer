//
//  ZZStreamPlayerView.h
//  ZZStreamPlayer
//
//  Created by 袁亮 on 16/4/18.
//  Copyright © 2016年 Migic_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ZZStreamPlayerView : UIView

@property (strong, nonatomic) NSString *stream_url;

@property (strong, nonatomic) AVURLAsset *urlAsset;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@property (strong, nonatomic) UITapGestureRecognizer *playerTap;


@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *sharedButton;
@property (strong, nonatomic) UIButton *fullScreenButton;



-(instancetype)initWithFrame:(CGRect)frame
               playerWithUrl:(NSString *)url;

@end
