//
//  UIImage+IconFont.m
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/14.
//

#import "UIImage+IconFont.h"

@implementation UIImage (IconFont)

+ (instancetype)imageWithIcon:(NSString *)icon fontName:(NSString *)fontName size:(NSUInteger)size color:(UIColor *)color{
    CGSize imageSize = CGSizeMake(size, size);
    UIGraphicsBeginImageContext(imageSize);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    label.font = [UIFont fontWithName:fontName size:size];
    label.text = icon;
    if(color){
        label.textColor = color;
    }
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    return iconImage;
}

@end
