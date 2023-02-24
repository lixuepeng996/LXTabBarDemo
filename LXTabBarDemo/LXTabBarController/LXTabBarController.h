//
//  LXTabBarController.h
//  Pangu-iOS
//
//  Created by lixuepeng on 2023/2/20.
//

#import <UIKit/UIKit.h>
#import "LXTabBar.h"
@class LXTabBarItem;
NS_ASSUME_NONNULL_BEGIN
@protocol LXTabBarControllerDelegate;

@interface LXTabBarController : UIViewController
@property(nullable, nonatomic,copy) NSArray<__kindof UIViewController *> *viewControllers;

@property(nullable, nonatomic, assign) __kindof UIViewController *selectedViewController;

@property(nonatomic, assign) NSUInteger selectedIndex;

@property(nonatomic,readonly) LXTabBar *tabBar;

@property(nullable, nonatomic,weak) id<LXTabBarControllerDelegate> delegate;

-(void)addChildViewController:(UIViewController *)childController title:(NSString*)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage;
@end

NS_SWIFT_UI_ACTOR
@protocol LXTabBarControllerDelegate <NSObject>
@optional
- (void)tabBarController:(LXTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
- (BOOL)tabBarController:(LXTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
@end



NS_ASSUME_NONNULL_END
