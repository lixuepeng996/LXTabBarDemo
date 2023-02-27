//
//  LXTabBarController.m
//  Pangu-iOS
//
//  Created by lixuepeng on 2023/2/20.
//

#import "LXTabBarController.h"
#import "LXTabBarItem.h"
@interface LXTabBarController ()<LXTabBarDelegate,UIPageViewControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,readwrite) LXTabBar *tabBar;
@property(nonatomic,strong) UIPageViewController *pageViewController;
@property(nonatomic,strong) NSMutableArray <LXTabBarItem *>*items;
@property(nonatomic,copy) NSMutableArray<__kindof UIViewController *> *currentViewControlles;
@property(nonatomic,copy) NSMutableArray<__kindof UIViewController *> *navRootViewControlles; // 获取导航栏根视图 iOS14及以上poptoroot时nav.viewControllers在willshow中获取第一个视图不是根视图
@end

@implementation LXTabBarController

-(NSMutableArray *)items {
    if(!_items) {
        _items = [NSMutableArray new];
    }
    return _items;
}

-(NSMutableArray *)currentViewControlles {
    if(!_currentViewControlles) {
        _currentViewControlles = [NSMutableArray new];
    }
    return _currentViewControlles;
}

-(NSMutableArray *)viewControllers {
    return _currentViewControlles;
}

-(NSMutableArray *)navRootViewControlles {
    if(!_navRootViewControlles) {
        _navRootViewControlles = [NSMutableArray new];
    }
    return _navRootViewControlles;
}


-(UIPageViewController *)pageViewController {
    if(!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}

-(LXTabBar *)tabBar {
    if(!_tabBar) {
        _tabBar = [[LXTabBar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - [LXTabBarController vg_tabBarFullHeight],  [UIScreen mainScreen].bounds.size.height, [LXTabBarController vg_tabBarFullHeight])];
        _tabBar.backgroundColor = [UIColor whiteColor];
        _tabBar.delegate = self;
        _tabBar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tabBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    // Do any additional setup after loading the view.
}

-(void)createViews {
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view addSubview:self.tabBar];

    NSLayoutConstraint *constantLeft = [NSLayoutConstraint constraintWithItem:self.tabBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *constantRight = [NSLayoutConstraint constraintWithItem:self.tabBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *constantBottom = [NSLayoutConstraint constraintWithItem:self.tabBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *constantH = [NSLayoutConstraint constraintWithItem:self.tabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:[LXTabBarController vg_tabBarFullHeight]];
    [self.view addConstraints:@[constantLeft,constantRight,constantH,constantBottom]];
}

#pragma mark- LXTabBarDelegate
-(void)tabBar:(LXTabBar *)tabBar didSelectItem:(LXTabBarItem *)item {
    NSInteger index = [tabBar.items indexOfObject:item];
    
    if(self.selectedIndex != index && index < self.viewControllers.count) {
        self.selectedIndex = index;
        [self.pageViewController setViewControllers:@[self.viewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            
        }];
        self.selectedViewController = self.viewControllers[index];
    }
}

-(void)addChildViewController:(UIViewController *)childController title:(NSString*)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage {
    [self.currentViewControlles addObject:childController];
    LXTabBarItem *item = [[LXTabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    item.tintColor = self.tabBar.tintColor;
    item.unselectedItemTintColor = self.tabBar.unselectedItemTintColor;
    [self.items addObject:item];
    self.tabBar.items = self.items;
    if (self.viewControllers.count == 1) {
        [self.pageViewController setViewControllers:@[childController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            
        }];
     self.selectedViewController = childController;
    }
    if([childController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)childController;
        nav.delegate = self;
        if(nav.viewControllers.count > 0) {
            [self.navRootViewControlles addObject:nav.viewControllers.firstObject];
        }
    }
}

#pragma mark- UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *firstVC = navigationController.viewControllers.firstObject;
    if(self.selectedIndex < self.navRootViewControlles.count) {
        firstVC = self.navRootViewControlles[self.selectedIndex];
    }
    if(navigationController && navigationController.viewControllers.count > 0 && viewController == firstVC) {
        self.tabBar.hidden = NO;
    } else {
        self.tabBar.hidden = YES;
    }
}

#pragma mark- UIPageViewControllerTools
-(UIViewController *)viewControllerAtIndex:(NSInteger)index {
    if(!self.viewControllers || self.viewControllers.count == 0 || index >= self.viewControllers.count){
        return nil;
    }
    return self.viewControllers[index];
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    return [self.viewControllers indexOfObject:viewController];
}
#pragma mark-Tools
+ (CGFloat)vg_safedistanceBottom {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.bottom;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.bottom;
    }
    return 0;
}

+ (CGFloat)vg_tabBarHeight {
    return 49.0f;
}

+ (CGFloat)vg_tabBarFullHeight {
    return [self vg_tabBarHeight] + [self vg_safedistanceBottom];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
