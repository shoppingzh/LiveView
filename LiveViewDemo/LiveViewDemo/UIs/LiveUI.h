//
//  LiveUI.h
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveUI : UIViewController

@property (nonatomic, copy, nonnull) NSString *liveUrl;

- (instancetype)initWithLiveUrl:(NSString*) liveUrl;

@end

NS_ASSUME_NONNULL_END
