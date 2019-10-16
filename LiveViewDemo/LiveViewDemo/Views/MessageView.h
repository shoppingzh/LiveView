//
//  MessageView.h
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/15.
//

#import <UIKit/UIKit.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageView : UIView

- (void)addMessages:(NSArray<Message*>*) messages;

@end

NS_ASSUME_NONNULL_END
