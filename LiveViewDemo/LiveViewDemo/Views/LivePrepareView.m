//
//  LivePrepareView.m
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/12.
//

#import "LivePrepareView.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import "UIImage+IconFont.h"

@interface LivePrepareView()

@property (nonatomic, strong) UIButton *openCameraBtn;
@property (nonatomic, strong) UIButton *openMicroBtn;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation LivePrepareView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:.2 green:.3 blue:.4 alpha:1];
        [self addSubview:self.openCameraBtn];
        [self addSubview:self.openMicroBtn];
        [self addSubview:self.tipsLabel];
        [self checkAuth];
    }
    return self;
}

- (void)layoutSubviews{
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
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    [self.openCameraBtn setEnabled:!(videoStatus == AVAuthorizationStatusAuthorized)];
    [self.openMicroBtn setEnabled:!(audioStatus == AVAuthorizationStatusAuthorized)];
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
        [_openCameraBtn setTitle:@" 打开摄像头权限" forState:UIControlStateNormal];
        [_openCameraBtn setImage:[UIImage imageWithIcon:@"\U0000e60a" fontName:@"suite" size:_openCameraBtn.titleLabel.font.pointSize color:[UIColor whiteColor]] forState:UIControlStateDisabled];
        [_openCameraBtn addTarget:self action:@selector(authCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openCameraBtn;
}

- (UIButton *)openMicroBtn{
    if(!_openMicroBtn){
        _openMicroBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_openMicroBtn setTitle:@" 打开麦克风权限" forState:UIControlStateNormal];
        [_openMicroBtn setImage:[UIImage imageWithIcon:@"\U0000e60a" fontName:@"suite" size:_openMicroBtn.titleLabel.font.pointSize color:[UIColor whiteColor]] forState:UIControlStateDisabled];
        [_openMicroBtn addTarget:self action:@selector(authMicro:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _openMicroBtn;
}

- (UILabel *)tipsLabel{
    if(!_tipsLabel){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont fontWithName:@"suite" size:12];
        _tipsLabel.textColor = [UIColor lightGrayColor];
        _tipsLabel.text = @"\U0000e66a 第一次启动等待的时间较长，请您耐心等待";
    }
    return _tipsLabel;
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
