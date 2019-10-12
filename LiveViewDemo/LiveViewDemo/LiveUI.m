//
//  LiveUI.m
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/12.
//

#import "LiveUI.h"
#import <Masonry.h>
#import "LivePrepareView.h"
#import "LiveView.h"


@interface LiveUI () <LivePrepareViewDelegate, LiveViewDelegate>

@property (nonatomic, strong) LiveView *liveView;
@property (nonatomic, strong) LivePrepareView *prepareView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation LiveUI

- (instancetype)initWithLiveUrl:(NSString *)liveUrl{
    if(self = [super init]){
        _liveUrl = liveUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.liveView];
    [self.view addSubview:self.prepareView];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.startBtn];
    
    [self layoutViews];
}

- (void)layoutViews{
    [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.prepareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).with.offset(10);
        } else {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left).with.offset(10);
        }
    }];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-40);
    }];
}

#pragma mark - getter setter

- (LiveView *)liveView{
    if(!_liveView){
        _liveView = [[LiveView alloc] init];
        _liveView.delegate = self;
        _liveView.liveUrl = self.liveUrl;
    }
    
    return _liveView;
}

- (LivePrepareView *)prepareView{
    if(!_prepareView){
        _prepareView = [[LivePrepareView alloc] init];
        _prepareView.delegate = self;
    }
    
    return _prepareView;
}

- (UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.titleLabel.font = [UIFont fontWithName:@"suite" size:32];
        _closeBtn.tintColor = [UIColor whiteColor];
        [_closeBtn setTitle:@"\U0000e627" forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)startBtn{
    if(!_startBtn){
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setTitle:@"开启直播" forState:UIControlStateNormal];
        [_startBtn setBackgroundColor:[UIColor colorWithRed:0 green:.59375 blue:.9335 alpha:1]];
        _startBtn.tintColor = [UIColor whiteColor];
        [_startBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 50, 10, 50)];
        _startBtn.layer.cornerRadius = 20;
        [_startBtn setEnabled:NO];
        _startBtn.alpha = .45;
        [_startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

#pragma mark - LivePrepareViewDelegate

- (void)didPrepare{
    NSLog(@"准备好了！");
    [self.startBtn setEnabled:YES];
    self.startBtn.alpha = 1;
}

#pragma mark - LiveViewDelegate

- (void)didLiveStart{
    [self.startBtn setHidden:YES];
    [self.prepareView removeFromSuperview];
}

- (void)didLiveStop{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didLiveError:(LFLiveSocketErrorCode)errorCode{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器连接错误，请稍后重试。" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self close:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 状态栏颜色

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 事件

- (IBAction)start:(id)sender{
    [self.startBtn setTitle:@"正在开始..." forState:UIControlStateNormal];
    [self.liveView startLive];
}

- (IBAction)close:(id)sender{
    [self.liveView stopLive];
    
}

@end
