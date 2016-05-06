//
//  ZZStreamFullSCreenView.m
//  ZZStreamPlayer
//
//  Created by 袁亮 on 16/4/18.
//  Copyright © 2016年 Migic_Z. All rights reserved.
//

#import "ZZStreamFullSCreenView.h"

@implementation ZZStreamFullSCreenView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self makeTopViewUI];
        
        [self makeDownViewUI];
        
    }
    return self;
}

-(void) makeTopViewUI
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 40)];
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = 0.7f;
    [self addSubview:topView];
    
    _lessenButton = [[UIButton alloc]initWithFrame:CGRectMake(25, 5, 60, 30)];
    [topView addSubview:_lessenButton];
    
    UIImageView *btnImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 11, 20)];
    btnImage.image = [UIImage imageNamed:@"backButton.png"];
    [_lessenButton addSubview:btnImage];
    
    _titlLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, [UIScreen mainScreen].bounds.size.height - 185, 30)];
    _titlLabel.textColor = [UIColor whiteColor];
    _titlLabel.font = [UIFont systemFontOfSize:17.0f];
    _titlLabel.text = @"周二珂，你的月亮我的珂";
    [topView addSubview:_titlLabel];
}

-(void)makeDownViewUI
{
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.width - 50, [UIScreen mainScreen].bounds.size.height, 64)];
    downView.backgroundColor = [UIColor blackColor];
//    downView.alpha = 0.7f;
    [self addSubview:downView];
    
    
    _messageField = [[UITextField alloc]initWithFrame:CGRectMake(25, 10, [UIScreen mainScreen].bounds.size.height  - 125, 30)];
    _messageField.layer.masksToBounds = YES;
    _messageField.layer.cornerRadius = 5.0f;
    _messageField.placeholder = @"请输入您的留言";
    _messageField.textColor = [UIColor blackColor];
    _messageField.backgroundColor = [UIColor whiteColor];
    _messageField.alpha = 1.0f;
    [downView addSubview:_messageField];
    
    _sendButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.height - 85, 10, 60, 30)];
    _sendButton.backgroundColor = [UIColor whiteColor];
    [_sendButton.layer setMasksToBounds:YES];
    [_sendButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [downView addSubview:_sendButton];
}


@end
