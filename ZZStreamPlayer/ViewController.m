//
//  ViewController.m
//  ZZStreamPlayer
//
//  Created by 袁亮 on 16/4/18.
//  Copyright © 2016年 Migic_Z. All rights reserved.
//

#import "ViewController.h"
#import "ZZStreamPlayerKit.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZZStreamPlayerView *streamView = [[ZZStreamPlayerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 3) playerWithUrl:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];

    [self.view addSubview:streamView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
