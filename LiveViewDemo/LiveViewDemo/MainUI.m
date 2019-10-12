//
//  MainUI.m
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/12.
//

#import "MainUI.h"
#import <Masonry.h>
#import "LiveUI.h"

@interface MainUI ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation MainUI

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_btn setTitle:@"我要直播" forState:UIControlStateNormal];
    [self.view addSubview:_btn];
    
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_btn addTarget:self action:@selector(live:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)live:(id)sender{
    [self presentViewController:[[LiveUI alloc] initWithLiveUrl:@"rtmp://218.17.142.4/oflaDemo/145459"] animated:YES completion:nil];
}


@end
