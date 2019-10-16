//
//  MessageReplyView.h
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageReplyView : UIView

@property (nonatomic, strong, readonly) UITextField *inputTextField;
@property (nonatomic, strong, readonly) UIButton *sendBtn;

@end

NS_ASSUME_NONNULL_END
