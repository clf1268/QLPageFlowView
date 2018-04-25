//
//  QLPageFlowView.h
//  QLPageFlowView
//
//  Created by cailianfeng on 2018/4/19.
//  Copyright © 2018年 cailianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    QLPageFlowViewScrollDirectionHorizontal = 0,
    QLPageFlowViewScrollDirectionVertical
} QLPageFlowViewScrollDirection;

@class QLPageFlowView;
@protocol QLPageFlowViewDataSource <NSObject>
- (NSInteger)numberOfItemsInPageFlowView:(QLPageFlowView *)pageFlowView;
- (UIView *)pageFlowView:(QLPageFlowView *)pageFlowView viewForRowAtIndex:(NSInteger)index;
@end

@protocol QLPageFlowViewDelegate <NSObject>
- (void)pageFlowView:(QLPageFlowView *)pageFlowView didSelectItemAtIndex:(NSInteger)index;
@end

@interface QLPageFlowView : UIView
@property (nonatomic, assign) id <QLPageFlowViewDataSource> dataSource;
@property (nonatomic, assign) id <QLPageFlowViewDelegate>   delegate;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) CGFloat minimumPageAlpha;
@property (nonatomic, assign) CGFloat minimumPageScale;
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;
- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(QLPageFlowViewScrollDirection)direction;
- (void)reloadData;
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
