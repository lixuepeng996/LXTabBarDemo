//
//  LXTabBar.h
//  Pangu-iOS
//
//  Created by lixuepeng on 2023/2/20.
//

#import <UIKit/UIKit.h>
@class LXTabBarItem;
@protocol LXTabBarDelegate;

NS_ASSUME_NONNULL_BEGIN
@interface LXTabBar : UIView
@property(nullable, nonatomic, weak) id<LXTabBarDelegate> delegate;     // weak reference. default is nil
@property(nullable, nonatomic, copy) NSArray<LXTabBarItem *> *items;        // get/set visible LXTabBarItem. default is nil. changes not animated. shown in order
@property(nullable, nonatomic,strong) LXTabBarItem *selectedItem;

@property(nonatomic, strong) UIColor *tintColor;

@property (nonatomic, readwrite, copy) UIColor *unselectedItemTintColor;

@property(nonatomic) CGFloat itemWidth;

@property(nonatomic) CGFloat itemSpacing;

@end

@protocol LXTabBarDelegate<NSObject>
@optional

- (void)tabBar:(LXTabBar *)tabBar didSelectItem:(LXTabBarItem *)item;

@end
NS_ASSUME_NONNULL_END
