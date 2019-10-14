//
//  UIImage+IconFont.h
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (IconFont)

// 图标图片
+ (instancetype) imageWithIcon:(nonnull NSString*) icon
                      fontName:(nonnull NSString*) fontName
                          size:(NSUInteger) size
                         color:(nullable UIColor*) color;

@end

NS_ASSUME_NONNULL_END
