//
//  MessageUI.m
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/15.
//

#import "MessageUI.h"
#import <Masonry.h>
#import "MessageView.h"

@interface MessageUI ()

@property (nonatomic, strong) MessageView *messageView;

// 模拟消息定时器
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger count;

@end

@implementation MessageUI

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.75];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.messageView];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.height.equalTo(self.view.mas_height).multipliedBy(.45);
    }];
    
    _count = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.timer fire];
}

- (void)viewWillDisappear:(BOOL)animated{
    if(self.timer.isValid){
        [self.timer invalidate];
    }
}

- (MessageView *)messageView{
    if(!_messageView){
        _messageView = [[MessageView alloc] init];
    }
    return _messageView;
}

- (NSTimer *)timer{
    if(!_timer){
        _timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(timeout:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    
    return _timer;
}

- (IBAction)timeout:(id)sender{
    Message *msg = [Message new];
    msg.name = @"老郑头";
    msg.content = [NSString stringWithFormat:@"这是我的新消息%ld", ++_count];
    [self.messageView addMessages:[NSArray arrayWithObjects:msg, nil]];
}

@end
