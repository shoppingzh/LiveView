//
//  LiveView.h
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/12.
//

#import <UIKit/UIKit.h>
#import <LFLiveKit/LFLiveKit.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@class LiveView;
// 直播代理
@protocol LiveViewDelegate <NSObject>

@optional
// 直播已开始
- (void)didLiveStart:(LiveView*)liveView;
// 直播已结束
- (void)didLiveStop:(LiveView*)liveView;
// 直播发生错误
- (void)liveView:(LiveView*)liveView didLiveError:(LFLiveSocketErrorCode) errorCode;
// 回复了一条消息
// 当返回YES时，表示结束本次回复会话，否则就可以连续回复
- (BOOL)liveView:(LiveView*)liveView didReplyMessage:(NSString*) content;

@end

@interface LiveView : UIView

@property (nonatomic, copy, nonnull) NSString *liveUrl;
@property (nonatomic, weak, nullable) id<LiveViewDelegate> delegate;

- (instancetype)initWithLiveUrl:(NSString*) liveUrl;
- (void)startLive;
- (void)stopLive;
- (void)addMessages:(NSArray<Message*>*) messages;

@end

NS_ASSUME_NONNULL_END
