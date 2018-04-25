//
//  QLPageFlowView.m
//  QLPageFlowView
//
//  Created by cailianfeng on 2018/4/19.
//  Copyright © 2018年 cailianfeng. All rights reserved.
//

#import "QLPageFlowView.h"
@interface QLPageFlowView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) QLPageFlowViewScrollDirection direction;
@property (nonatomic, strong) NSMutableArray * availableCell;
@end
@implementation QLPageFlowView
- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(QLPageFlowViewScrollDirection)direction{
    if (self == [super initWithFrame:frame]) {
        [self initialize];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)initialize{
    self.backgroundColor = [UIColor lightGrayColor];
    self.availableCell = [[NSMutableArray alloc] init];
    self.clipsToBounds = NO;
    self.pageSize = self.frame.size;
    self.pageCount = 0;
    self.minimumPageAlpha = 1.0;
    self.minimumPageScale = 1.0;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor yellowColor];
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

#pragma mark - kernelMethod
- (void)reloadData{
    self.pageCount = [self.dataSource numberOfItemsInPageFlowView:self];
    [self.availableCell removeAllObjects];
    for (NSInteger i = 0; i < self.pageCount; i ++) {
        UIView * view = [self.dataSource pageFlowView:self viewForRowAtIndex:i];
        NSAssert(view, @"PageFlowView‘s view canot be nil");
        [self.availableCell addObject:view];
        view.frame = CGRectMake(i*self.pageSize.width, 0, self.pageSize.width, self.pageSize.height);
        [self.scrollView addSubview:view];
    }
    self.scrollView.contentSize = CGSizeMake(self.pageSize.width*self.pageCount, self.pageSize.height);
    [self reloadVisibleItems];
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated{
    if (index > self.pageCount || index < 0) {
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(index * self.pageSize.width, 0) animated:YES];
}
//通过改变frame或者缩放改变大小，实现中间放大的效果
- (void)reloadVisibleItems{
    if (self.direction == QLPageFlowViewScrollDirectionHorizontal) {
        CGFloat offset = self.scrollView.contentOffset.x;
        NSInteger page = offset/(self.pageSize.width*self.minimumPageScale);
        NSInteger length = 3;        
        NSInteger upPage = page-1 < 0 ? 0 : page-1;
        for (NSInteger i = upPage; i < upPage+length; i++) {
            if (i > self.pageCount-1) {
                return;
            }
            UIView *cell = [self.availableCell objectAtIndex:i];
            CGFloat origin = cell.frame.origin.x;
            //获取偏移量
            CGFloat delta = fabs(origin - offset);
            cell.alpha = 1 - (delta / self.pageSize.width) * (1 - self.minimumPageAlpha);
            //通过偏移量计算缩放比例
            CGFloat scale = 1 - (1 - self.minimumPageScale) * delta/(self.pageSize.width);
            cell.transform = CGAffineTransformMakeScale(scale, scale);
            
        }
    }
}
//通过改变frame或者缩放改变大小，实现中间放大的效果
//- (void)reloadVisibleItems{
//    if (self.direction == QLPageFlowViewScrollDirectionHorizontal) {
//        CGFloat offset = self.scrollView.contentOffset.x;
//        NSInteger page = offset/(self.pageSize.width*self.minimumPageScale);
//        NSInteger length = 3;
//        NSInteger upPage = page-1 < 0 ? 0 : page-1;
//        for (NSInteger i = upPage; i < upPage+length; i++) {
//            if (i > self.pageCount-1) {
//                return;
//            }
//            UIView *cell = [self.availableCell objectAtIndex:i];
//            CGFloat origin = cell.frame.origin.x;
//            CGFloat delta = fabs(origin - offset);
//            //            CGRect originCellFrame = CGRectMake(self.pageSize.width * i, 0, self.pageSize.width, self.pageSize.height);//如果没有缩小效果的情况下的本该的Frame
//            if (delta < self.pageSize.width) {
//                cell.alpha = 1 - (delta / self.pageSize.width) * (1 - self.minimumPageAlpha);
//                //                CGFloat inset = (self.pageSize.width * (1 - self.minimumPageScale)) * (delta / self.pageSize.width)/2.0;
//                //                cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
//                CGFloat scale = 1 - (1 - self.minimumPageScale) * delta/(self.pageSize.width);
//                cell.transform = CGAffineTransformMakeScale(scale, scale);
//            } else {
//                cell.alpha = self.minimumPageAlpha;
//                //                CGFloat inset = self.pageSize.width * (1 - self.minimumPageScale) / 2.0 ;
//                //                cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
//                CGFloat scale = self.minimumPageScale;
//                cell.transform = CGAffineTransformMakeScale(scale, scale);
//
//            }
//        }
//    }
//}



#pragma mark - UIScrollViewDelegate
//滑动的时候reload页面
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.pageCount < 2) {
        return;
    }
    if (CGSizeEqualToSize(self.pageSize, CGSizeZero)) {
        return;
    }
    [self reloadVisibleItems];
}

#pragma mark - 点击事件
- (void)handleTapGesture:(UITapGestureRecognizer *)gesture{
    NSLog(@"点击了");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
