//
//  MessageView.m
//  LiveViewDemo
//
//  Created by xpzheng on 2019/10/15.
//

#import "MessageView.h"
#import <Masonry.h>
#import "MessageTableViewCell.h"
#import "UIImage+IconFont.h"

#define REUSE_CELL_NAME @"messsageCell"

@interface MessageView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong, nonnull) NSMutableArray<Message*> *messages;
@property (nonatomic, strong) UIButton *unreadView;
@property (nonatomic, assign) NSUInteger unreadCount;
@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) BOOL atBottom;

@end

@implementation MessageView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.messageTableView];
        [self addSubview:self.unreadView];
        self.atBottom = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.unreadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.messageTableView){
        CGFloat offsetY = scrollView.contentOffset.y;
        self.atBottom = offsetY >= self.lastOffsetY;
        self.lastOffsetY = offsetY;
    }
}

#pragma mark - API

- (void)addMessages:(NSArray<Message *> *)messages{
    if(!messages || !messages.count){
        return;
    }
    // 添加消息前，计算当前表格是否滚动到了最底部，如果是，则在添加消息后滚动到底部，否则不滚动
    // 如果没有滚动到最底部，可认为用户正在查看消息，如果此时来了新消息将表格滚动到底部则会影响用户的体验
    // 但是一种情况例外，用户自己发送消息时，无论如何都将表格滚动到最底部
//    BOOL atBottom = self.messageTableView.contentSize.height - self.messageTableView.contentOffset.y - self.frame.size.height <= 0;
    BOOL hasMine = NO;
    for (Message *msg in messages) {
        if(msg.mine){
            hasMine = YES;
            break;
        }
    }
    
    // 使用局部更新的方式更新消息列表，以减少性能损耗
    [self.messageTableView beginUpdates];
    [self.messages addObjectsFromArray:messages];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSUInteger to = self.messages.count;
    for(NSUInteger from  = to - messages.count; from < to; from++){
        [indexPaths addObject:[NSIndexPath indexPathForRow:from inSection:0]];
    }
    [self.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.messageTableView endUpdates];
    
//    NSLog(@"表格内容高度：%f, 表格滚动距离：%f, 表格占据高度：%f，位于底部：%d", self.messageTableView.contentSize.height, self.messageTableView.contentOffset.y, self.messageTableView.frame.size.height, atBottom);
    
    if(hasMine || self.atBottom){
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        self.unreadCount = 0;
    }else{
        self.unreadCount += messages.count;
    }
}

#pragma mark - getter setter

- (UITableView *)messageTableView{
    if(!_messageTableView){
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _messageTableView.dataSource = self;
        _messageTableView.delegate = self;
        _messageTableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _messageTableView.allowsSelection = NO; // 不允许选择
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去除分割线
        [_messageTableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:REUSE_CELL_NAME];
    }
    return _messageTableView;
}

- (UIButton *)unreadView{
    if(!_unreadView){
        _unreadView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unreadView setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
        [_unreadView setContentEdgeInsets:UIEdgeInsetsMake(3, 5, 3, 5)];
        _unreadView.backgroundColor = [UIColor whiteColor];
        _unreadView.titleLabel.font = [UIFont fontWithName:@"suite" size:14];
        _unreadView.layer.cornerRadius = 4;
        [_unreadView setHidden:YES];
        
        [_unreadView addTarget:self action:@selector(readNew:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unreadView;
}

- (NSMutableArray<Message *> *)messages{
    if(!_messages){
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

- (void)setUnreadCount:(NSUInteger)unreadCount{
    _unreadCount = unreadCount;
    [self.unreadView setTitle:[NSString stringWithFormat:@"\U0000e601 %ld条未读消息", unreadCount] forState:UIControlStateNormal];
    [self.unreadView setHidden:unreadCount <= 0];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell = [self.messageTableView dequeueReusableCellWithIdentifier:REUSE_CELL_NAME forIndexPath:indexPath];
    cell.message = [self.messages objectAtIndex:indexPath.row];
    return cell;
    
}

#pragma mark - 阅读新消息
- (IBAction)readNew:(id)sender{
    self.unreadCount = 0;
    // 以最快的速度滚动到最底部，无需动画
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

@end
