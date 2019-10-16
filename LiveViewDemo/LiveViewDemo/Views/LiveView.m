//
//  LiveView.m
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/12.
//

#import "LiveView.h"
#import <Masonry.h>
#import "Message.h"
#import "MessageTableViewCell.h"
#import "MessageView.h"
#import "UIImage+IconFont.h"
#import "MessageReplyView.h"

// 操作按钮大小
#define OPERATE_BUTTON_SIZE 36

@interface LiveView() <LFLiveSessionDelegate, UITextFieldDelegate>

@property (nonatomic, strong) LFLiveSession *liveSession;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *flipBtn;
@property (nonatomic, strong) UIButton *beautyBtn;
@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) MessageView *messageView;
@property (nonatomic, strong) MessageReplyView *replyView;

@end

@implementation LiveView

- (instancetype)initWithLiveUrl:(NSString *)liveUrl{
    if(self = [self init]){
        _liveUrl = liveUrl;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.55];
        [self addSubview:self.closeBtn];
        [self addSubview:self.flipBtn];
        [self addSubview:self.beautyBtn];
        [self addSubview:self.flashBtn];
        [self addSubview:self.replyBtn];
        [self addSubview:self.messageView];
        [self addSubview:self.replyView];
    }
    return self;
}

- (void)layoutSubviews{
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).with.offset(-5);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).with.offset(-10);
        }else{
            make.bottom.equalTo(self.mas_bottom).with.offset(-5);
            make.right.equalTo(self.mas_right).with.offset(-10);
        }
        make.width.mas_equalTo(OPERATE_BUTTON_SIZE);
        make.height.mas_equalTo(OPERATE_BUTTON_SIZE);
    }];
    [self.flipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.closeBtn.mas_left).with.offset(-8);
        make.centerY.equalTo(self.closeBtn.mas_centerY);
        make.width.equalTo(self.closeBtn.mas_width);
        make.height.equalTo(self.closeBtn.mas_height);
    }];
    [self.beautyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.flipBtn.mas_left).with.offset(-8);
        make.centerY.equalTo(self.closeBtn.mas_centerY);
        make.width.equalTo(self.closeBtn.mas_width);
        make.height.equalTo(self.closeBtn.mas_height);
    }];
    [self.flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.beautyBtn.mas_left).with.offset(-8);
        make.centerY.equalTo(self.closeBtn.mas_centerY);
        make.width.equalTo(self.closeBtn.mas_width);
        make.height.equalTo(self.closeBtn.mas_height);
    }];
    [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.flashBtn.mas_left).with.offset(-8);
        make.centerY.equalTo(self.closeBtn.mas_centerY);
        make.height.equalTo(self.closeBtn.mas_height);
    }];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.flipBtn.mas_top).with.offset(-10);
        make.height.equalTo(self.mas_height).multipliedBy(.25);
    }];
    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

#pragma mark - API

- (void)startLive{
    LFLiveStreamInfo *stream = [[LFLiveStreamInfo alloc] init];
    stream.url = _liveUrl;
    [self.liveSession startLive:stream];
}

- (void)stopLive{
    [self.liveSession stopLive];
}

- (void)addMessages:(NSArray<Message *> *)messages{
    [self.messageView addMessages:messages];
}

#pragma mark - getter setter

- (LFLiveSession *)liveSession{
    if(!_liveSession){
        LFLiveVideoConfiguration *videoConf = [LFLiveVideoConfiguration defaultConfiguration];
        LFLiveAudioConfiguration *audioConf = [LFLiveAudioConfiguration defaultConfiguration];
        _liveSession = [[LFLiveSession alloc] initWithAudioConfiguration:audioConf videoConfiguration:videoConf captureType:LFLiveCaptureDefaultMask];
        _liveSession.preView = self;
        _liveSession.delegate = self;
        // 基础设置(摄像头位置、美颜、亮度等)
        _liveSession.captureDevicePosition = AVCaptureDevicePositionBack;
        _liveSession.beautyFace = YES;
        _liveSession.beautyLevel = 1;
        _liveSession.showDebugInfo = NO;
    }
    return _liveSession;
}

- (UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setupOperationBtn:_closeBtn];
        [_closeBtn setTitle:@"\U0000e627" forState:UIControlStateNormal];
        // 图标大了，重新设置一下
        _closeBtn.titleLabel.font = [UIFont fontWithName:@"suite" size:22];
        [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)flipBtn{
    if(!_flipBtn){
        _flipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setupOperationBtn:_flipBtn];
        [_flipBtn setTitle:@"\U0000e904" forState:UIControlStateNormal];
        [_flipBtn addTarget:self action:@selector(flipCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flipBtn;
}

- (UIButton *)beautyBtn{
    if(!_beautyBtn){
        _beautyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setupOperationBtn:_beautyBtn];
        [_beautyBtn setTitle:@"\U0000e628" forState:UIControlStateNormal];
        [_beautyBtn addTarget:self action:@selector(toggleBeauty:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _beautyBtn;
}

- (UIButton *)flashBtn{
    if(!_flashBtn){
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setupOperationBtn:_flashBtn];
        [_flashBtn setTitle:@"\U0000e609" forState:UIControlStateNormal];
        [_flashBtn addTarget:self action:@selector(toggleFlash:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _flashBtn;
}

- (UIButton *)replyBtn{
    if(!_replyBtn){
        _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyBtn.tintColor = [UIColor darkGrayColor];
        _replyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_replyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_replyBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [_replyBtn setImage:[UIImage imageWithIcon:@"\U0000e61d" fontName:@"suite" size:18 color:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_replyBtn setTitle:@"  我有话要说.." forState:UIControlStateNormal];
        _replyBtn.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.1];
        _replyBtn.layer.cornerRadius = 16;
        
        [_replyBtn addTarget:self action:@selector(showReplyView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyBtn;
}

- (MessageView *)messageView{
    if(!_messageView){
        _messageView = [[MessageView alloc] init];
    }
    return _messageView;
}

- (MessageReplyView *)replyView{
    if(!_replyView){
        _replyView = [[MessageReplyView alloc] init];
        [_replyView setHidden:YES];
        _replyView.inputTextField.delegate = self;
        [_replyView.sendBtn addTarget:self action:@selector(reply:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyView;
}

// 操作图标按钮通用设置
- (void) setupOperationBtn:(UIButton*) btn{
    btn.titleLabel.font = [UIFont fontWithName:@"suite" size:28];
    btn.tintColor = [UIColor whiteColor];
    // 设置背景、圆角
    btn.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.1];
    btn.layer.cornerRadius = OPERATE_BUTTON_SIZE / 2;
}

#pragma mark - LFLiveSessionDelegate

- (void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSLog(@"直播状态改变：%ld", state);
    switch (state) {
        case LFLiveReady:
            
            break;
        case LFLivePending:
            break;
        case LFLiveStart:
            self.liveSession.running = YES;
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLiveStart:)]){
                [self.delegate didLiveStart:self];
            }
            break;
        case LFLiveStop:
            self.liveSession.running = NO;
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLiveStop:)]){
                [self.delegate didLiveStop:self];
            }
            break;
        case LFLiveError:
            break;
        case LFLiveRefresh:
            break;
        default:
            break;
    }
}

- (void)liveSession:(LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode{
    NSLog(@"直播发生错误：%ld", errorCode);
    if(self.delegate && [self.delegate respondsToSelector:@selector(liveView:didLiveError:)]){
        [self.delegate liveView:self didLiveError:errorCode];
    }
}

#pragma mark - 关闭
- (IBAction)close:(id)sender{
    [self stopLive];
}

#pragma mark - 摄像头翻转

- (IBAction)flipCamera:(id)sender{
    AVCaptureDevicePosition pos = self.liveSession.captureDevicePosition;
    if(pos == AVCaptureDevicePositionFront){
        self.liveSession.captureDevicePosition = AVCaptureDevicePositionBack;
    }else{
        self.liveSession.captureDevicePosition = AVCaptureDevicePositionFront;
    }
}

#pragma mark - 美颜

- (IBAction)toggleBeauty:(id)sender{
    BOOL setting = !self.liveSession.beautyFace;
    self.liveSession.beautyFace = setting;
}

#pragma mark - 闪光灯

- (IBAction)toggleFlash:(id)sender{
    BOOL setting = !self.liveSession.torch;
    self.liveSession.torch = setting;
}

#pragma mark - 消息回复

// 展示回复View
- (IBAction)showReplyView:(id)sender{
    [self.replyView setHidden:NO];
    [self.replyView.inputTextField becomeFirstResponder];
}

- (IBAction)reply:(id)sender{
    NSString *content = self.replyView.inputTextField.text;
    if(!content || content.length <= 0){
        return;
    }
    [self.replyView.inputTextField setText:@""];
    if(self.delegate && [self.delegate respondsToSelector:@selector(liveView:didReplyMessage:)]){
        BOOL end = [self.delegate liveView:self didReplyMessage:content];
        if(end){
            [self.replyView.inputTextField endEditing:end];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.replyView setHidden:YES];
}

@end
