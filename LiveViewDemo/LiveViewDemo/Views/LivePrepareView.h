//
//  LivePrepareView.h
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LivePrepareViewDelegate <NSObject>

- (void)didPrepare;

@end

@interface LivePrepareView : UIView

@property (nonatomic, weak, nullable) id<LivePrepareViewDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL prepared;

@end

NS_ASSUME_NONNULL_END
