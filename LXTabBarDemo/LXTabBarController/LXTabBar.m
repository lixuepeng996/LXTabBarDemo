//
//  LXTabBar.m
//  Pangu-iOS
//
//  Created by lixuepeng on 2023/2/20.
//

#import "LXTabBar.h"
#import "LXTabBarItem.h"
#import "UIButton+Layout.h"

static NSString *itemKey = @"tabBarItemBtn";
@interface LXTabBar()
@property(nonatomic,strong) UIStackView *stackView;
@property(nonatomic,strong) NSMutableArray<UIView *> *views;
@end
@implementation LXTabBar

-(void)setItems:(NSArray<LXTabBarItem *> *)items {
    _items = items;
    [self createItems];
}

-(NSMutableArray *)views {
    if(!_views) {
        _views = [NSMutableArray new];
    }
    return _views;
}

-(UIStackView *)stackView {
    if(!_stackView) {
        _stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentFill;
    }
    return _stackView;
}

-(void)setItemSpacing:(CGFloat)itemSpacing {
    _itemSpacing = itemSpacing;
    self.stackView.spacing = itemSpacing;
}

-(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.itemWidth = 100;
        self.itemSpacing = 0;
        [self createUI];
    }
    return self;
}


-(void)createUI {
    [self addSubview:self.stackView];
}

-(void)createItems {
    for (UIView *view in self.stackView.subviews) {
        [view removeFromSuperview];
    }
    self.itemWidth = [UIScreen mainScreen].bounds.size.width /  self.items.count;

    for (NSInteger i = 0; i<self.items.count; i++) {
        LXTabBarItem *item = self.items[i];
        //添加item
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];     
        btn.frame = CGRectMake(0, 0, self.itemWidth, self.stackView.frame.size.height);
        [btn setTitle:item.title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:9];
        [btn setTag:i + 1];
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.stackView addArrangedSubview:btn];
        [item setValue:btn forKey:itemKey];
        if (i == 0) {
            [btn setTitleColor:item.tintColor forState:UIControlStateNormal];
            [btn setImage:item.selectedImage forState:UIControlStateNormal];
            self.selectedItem = item;
        } else {
            [btn setTitleColor:item.unselectedItemTintColor forState:UIControlStateNormal];
            [btn setImage:item.image forState:UIControlStateNormal];
        }
        [btn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:0]; //需先设置图片再执行
    }
}

-(void)itemClick:(UIButton *)btn {
    NSInteger index = btn.tag - 1;
    LXTabBarItem *item = self.items[index];
    if(item != self.selectedItem) {
        UIButton *oldBtn = [self.selectedItem valueForKey:itemKey];
        [oldBtn setTitleColor:self.selectedItem.unselectedItemTintColor forState:UIControlStateNormal];
        [oldBtn setImage:self.selectedItem.image forState:UIControlStateNormal];
        [btn setTitleColor:item.tintColor forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateNormal];
        self.selectedItem = item;
        if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
            [self.delegate tabBar:self didSelectItem:item];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
