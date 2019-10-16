//
//  Message.h
//  LFLiveDemo
//
//  Created by xpzheng on 2019/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject

@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *content;
@property (nonatomic, strong, nullable) NSDate *datetime;
@property (nonatomic, assign) BOOL mine;

@end

NS_ASSUME_NONNULL_END
