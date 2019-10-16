//
//  MessageTableViewCell.m
//  LFLiveDemo
//
//  Created by xpzheng on 2019/10/11.
//

#import "MessageTableViewCell.h"
#import <Masonry.h>

@interface MessageTableViewCell()

@property (nonatomic, strong) UIView *maskView;

@end

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style
                   reuseIdentifier:reuseIdentifier]){
        self.textLabel.numberOfLines = 0;
        
        self.backgroundColor = [UIColor clearColor];
        [self.textLabel sizeToFit];
    }
    return self;
}

- (void)setMessage:(Message *)message{
    if(!message.name || [message.name isKindOfClass:[NSNull class]]){
        message.name = @"未知用户";
    }
    if(!message.content || [message.content isKindOfClass:[NSNull class]]){
        message.content = @"";
    }
    _message = message;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    UIColor *nameColor = message.mine ? [UIColor greenColor] : [UIColor orangeColor];
    NSDictionary *nameAttr = @{NSForegroundColorAttributeName: nameColor};
    NSDictionary *contentAttr = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSAttributedString *name = [[NSAttributedString alloc] initWithString:[message.name stringByAppendingString:@"："] attributes:nameAttr];
    NSAttributedString *content = [[NSAttributedString alloc] initWithString:message.content attributes:contentAttr];
    
    [text appendAttributedString:name];
    [text appendAttributedString:content];
    [self.textLabel setAttributedText:text];
}

#pragma mark - getter setter
- (UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.25];
        _maskView.layer.cornerRadius = 4;
        _maskView.layer.masksToBounds = YES;
    }
    return _maskView;
}

@end
