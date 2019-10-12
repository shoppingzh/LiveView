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

@protocol LiveViewDelegate <NSObject>

// 直播已开始
- (void)didLiveStart;
// 直播已结束
- (void)didLiveStop;
// 直播发生错误
- (void)didLiveError:(LFLiveSocketErrorCode) errorCode;

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
