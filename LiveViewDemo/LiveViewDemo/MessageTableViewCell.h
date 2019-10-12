//
//  MessageTableViewCell.h
//  LFLiveDemo
//
//  Created by xpzheng on 2019/10/11.
//

#import <UIKit/UIKit.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, strong) Message *message;

@end

NS_ASSUME_NONNULL_END
