//
//  MessageReplyView.m
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/15.
//

#import "MessageReplyView.h"
#import <Masonry.h>

@interface MessageReplyView()

@property (nonatomic, strong) UIView *separateView;

@end

@implementation MessageReplyView

@synthesize inputTextField = _inputTextField;
@synthesize sendBtn = _sendBtn;


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.inputTextField];
        [self addSubview:self.separateView];
        [self addSubview:self.sendBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(45);
    }];
    [self.separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sendBtn.mas_left).offset(-5);
        make.width.mas_equalTo(1);
        make.height.equalTo(self.mas_height).multipliedBy(.6);
        make.centerY.equalTo(self);
    }];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.sendBtn.mas_left).with.offset(-15);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
    }];
}

#pragma mark - getter setter

- (UITextField *)inputTextField{
    if(!_inputTextField){
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.placeholder = @"在此输入您想要说的话..";
    }
    return _inputTextField;
}

- (UIButton *)sendBtn{
    if(!_sendBtn){
        _sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _sendBtn.tintColor = [UIColor colorWithRed:.17 green:.72 blue:.46 alpha:1];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _sendBtn;
}

- (UIView *)separateView{
    if(!_separateView){
        _separateView = [[UIView alloc] init];
        _separateView.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    }
    return _separateView;
}


@end
