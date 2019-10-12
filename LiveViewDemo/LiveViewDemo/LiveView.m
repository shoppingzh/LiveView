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

#define REUSE_CELL_NAME @"messsageCell"

@interface LiveView() <LFLiveSessionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LFLiveSession *liveSession;

@property (nonatomic, strong) UIButton *flipBtn;
@property (nonatomic, strong) UIButton *beautyBtn;
@property (nonatomic, strong) UITableView *messageTableView;
// Attributes
@property (nonatomic, strong, nonnull) NSMutableArray<Message*> *messages;

@end

@implementation LiveView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.55];
        [self addSubview:self.flipBtn];
        [self addSubview:self.beautyBtn];
        [self addSubview:self.messageTableView];
        [self layoutViews];
        
        
        
    }
    
    return self;
}

- (instancetype)initWithLiveUrl:(NSString *)liveUrl{
    if(self = [self init]){
        _liveUrl = liveUrl;
    }
    return self;
}

- (void)layoutViews{
    [self.flipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).with.offset(5);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).with.offset(-15);
        }else{
            make.top.equalTo(self.mas_top).with.offset(5);
            make.right.equalTo(self.mas_right).with.offset(-15);
        }
    }];
    [self.beautyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.flipBtn.mas_left).with.offset(-15);
        make.centerY.equalTo(self.flipBtn.mas_centerY);
    }];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).with.offset(-10);
        }else{
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        }
        make.height.equalTo(self.mas_height).multipliedBy(.4);
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
    [self.messages addObjectsFromArray:messages];
    [self.messageTableView reloadData];
}

#pragma mark - getter setter

- (LFLiveSession *)liveSession{
    if(!_liveSession){
        LFLiveVideoConfiguration *videoConf = [LFLiveVideoConfiguration defaultConfiguration];
        LFLiveAudioConfiguration *audioConf = [LFLiveAudioConfiguration defaultConfiguration];
        _liveSession = [[LFLiveSession alloc] initWithAudioConfiguration:audioConf videoConfiguration:videoConf captureType:LFLiveCaptureDefaultMask];
        _liveSession.preView = self;
        _liveSession.delegate = self;
        // 基础设置(美颜、亮度等)
        _liveSession.beautyFace = YES;
        _liveSession.beautyLevel = 1;
        _liveSession.showDebugInfo = YES;
        _liveSession.captureDevicePosition = AVCaptureDevicePositionBack;
    }
    return _liveSession;
}


- (UIButton *)flipBtn{
    if(!_flipBtn){
        _flipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setupOperationBtn:_flipBtn];
        [_flipBtn setTitle:@"\U0000e655" forState:UIControlStateNormal];
        [_flipBtn addTarget:self action:@selector(flipCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _flipBtn;
}

- (UIButton *)beautyBtn{
    if(!_beautyBtn){
        _beautyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setupOperationBtn:_beautyBtn];
        [_beautyBtn setTitle:@"\U0000e609" forState:UIControlStateNormal];
        [_beautyBtn addTarget:self action:@selector(toggleBeauty:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _beautyBtn;
}

- (UITableView *)messageTableView{
    if(!_messageTableView){
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _messageTableView.dataSource = self;
        _messageTableView.delegate = self;
        _messageTableView.backgroundColor = [UIColor yellowColor];
        _messageTableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _messageTableView.allowsSelection = NO;
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_messageTableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:REUSE_CELL_NAME];
    }
    return _messageTableView;
}

- (NSMutableArray<Message *> *)messages{
    if(!_messages){
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

// 操作图标按钮通用设置
- (void) setupOperationBtn:(UIButton*) btn{
    btn.titleLabel.font = [UIFont fontWithName:@"suite" size:28];
    btn.tintColor = [UIColor whiteColor];
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
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLiveStart)]){
                [self.delegate didLiveStart];
            }
            break;
        case LFLiveStop:
            self.liveSession.running = NO;
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLiveStop)]){
                [self.delegate didLiveStop];
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

//- (void)liveSession:(LFLiveSession *)session debugInfo:(LFLiveDebug *)debugInfo{
//    NSLog(@"直播详情：%@", debugInfo);
//}

- (void)liveSession:(LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode{
    NSLog(@"直播发生错误：%ld", errorCode);
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLiveError:)]){
        [self.delegate didLiveError:errorCode];
    }
}

#pragma mark - 事件处理

- (IBAction)flipCamera:(id)sender{
    AVCaptureDevicePosition pos = self.liveSession.captureDevicePosition;
    if(pos == AVCaptureDevicePositionFront){
        self.liveSession.captureDevicePosition = AVCaptureDevicePositionBack;
    }else{
        self.liveSession.captureDevicePosition = AVCaptureDevicePositionFront;
    }
}

- (IBAction)toggleBeauty:(id)sender{
    BOOL setting = !self.liveSession.beautyFace;
    self.liveSession.beautyFace = setting;
    // 设置按钮样式
    NSLog(@"美颜是否开启：%d", setting);
    if(setting){
        [self.beautyBtn setTitle:@"\U0000e609" forState:UIControlStateNormal];
    }else{
        [self.beautyBtn setTitle:@"\U0000e60b" forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell = [self.messageTableView dequeueReusableCellWithIdentifier:REUSE_CELL_NAME forIndexPath:indexPath];
    cell.message = [self.messages objectAtIndex:indexPath.row];
    return cell;
    
}

@end
