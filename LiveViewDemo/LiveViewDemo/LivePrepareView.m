//
//  LivePrepareView.m
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/12.
//

#import "LivePrepareView.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>

@interface LivePrepareView()

@property (nonatomic, strong) UIButton *openCameraBtn;
@property (nonatomic, strong) UIButton *openMicroBtn;
@property (nonatomic, strong) UILabel *tipsLabel;


@end

@implementation LivePrepareView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.85];
        
        [self addSubview:self.openCameraBtn];
        [self addSubview:self.openMicroBtn];
        [self addSubview:self.tipsLabel];
        
        [self layoutViews];
        
        [self checkAuth];
    }
    
    return self;
}

- (void)layoutViews{
    
    [self.openCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(30);
    }];
    [self.openMicroBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.openCameraBtn.mas_bottom).with.offset(20);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).with.offset(-20);
        }else{
            make.bottom.equalTo(self.mas_bottom).with.offset(-20);
        }
    }];
}

- (BOOL)prepared{
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return videoStatus == AVAuthorizationStatusAuthorized && audioStatus == AVAuthorizationStatusAuthorized;
}

#pragma mark - 检查权限

- (void) checkAuth{
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(videoStatus == AVAuthorizationStatusAuthorized){
        [self.openCameraBtn setEnabled:NO];
        [self.openCameraBtn setTitle:@"\U0000e60a 开启摄像头权限" forState:UIControlStateNormal];
    }else{
        [self.openCameraBtn setEnabled:YES];
        [self.openCameraBtn setTitle:@"开启摄像头权限" forState:UIControlStateNormal];
    }
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(audioStatus == AVAuthorizationStatusAuthorized){
        [self.openMicroBtn setEnabled:NO];
        [self.openMicroBtn setTitle:@"\U0000e60a 开启麦克风权限" forState:UIControlStateNormal];
    }else{
        [self.openMicroBtn setEnabled:YES];
        [self.openMicroBtn setTitle:@"开启麦克风权限" forState:UIControlStateNormal];
    }
    
    if(videoStatus == AVAuthorizationStatusAuthorized && audioStatus == AVAuthorizationStatusAuthorized){
        if(self.delegate && [self.delegate respondsToSelector:@selector(didPrepare)]){
            [self.delegate didPrepare];
        }
    }
}


#pragma mark - getter setter

- (void)setDelegate:(id<LivePrepareViewDelegate>)delegate{
    _delegate = delegate;
    [self checkAuth];
}

- (UIButton *)openCameraBtn{
    if(!_openCameraBtn){
        _openCameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_openCameraBtn setTitle:@"开启摄像头权限" forState:UIControlStateNormal];
        [self setupMiniButton:_openCameraBtn];
        [_openCameraBtn addTarget:self action:@selector(authCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openCameraBtn;
}

- (UIButton *)openMicroBtn{
    if(!_openMicroBtn){
        _openMicroBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_openMicroBtn setTitle:@"打开麦克风权限" forState:UIControlStateNormal];
        [self setupMiniButton:_openMicroBtn];
        [_openMicroBtn addTarget:self action:@selector(authMicro:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _openMicroBtn;
}

- (UILabel *)tipsLabel{
    if(!_tipsLabel){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont fontWithName:@"suite" size:12];
        _tipsLabel.textColor = [UIColor grayColor];
        _tipsLabel.text = @"\U0000e66a 第一次启动等待的时间较长，请您耐心等待";
    }
    
    return _tipsLabel;
}

// 小按钮统一设置样式
- (void) setupMiniButton:(UIButton*) btn{
    btn.titleLabel.font = [UIFont fontWithName:@"suite" size:16];
}


#pragma mark - 事件


- (IBAction)authCamera:(id)sender{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self checkAuth];
            });
        }];
    }else if(status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

- (IBAction)authMicro:(id)sender{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(status == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self checkAuth];
            });
        }];
    }else if(status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

@end
