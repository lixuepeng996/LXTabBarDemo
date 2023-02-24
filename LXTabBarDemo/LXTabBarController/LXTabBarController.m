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

-(void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self changeTabToIndex:selectedIndex];
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
    self.selectedIndex = index;
}

-(void)addChildViewController:(UIViewController *)childController title:(NSString*)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage {
    [self.currentViewControlles addObject:childController];
    LXTabBarItem *item = [[LXTabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    item.tintColor = self.tabBar.tintColor;
    item.unselectedItemTintColor = self.tabBar.unselectedItemTintColor;
    [self.items addObject:item];
    self.tabBar.items = self.items;
    if (self.viewControllers.count == 1) {
        self.selectedIndex = 0;
    }
    
    if([childController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)childController;
        nav.delegate = self;
    }
}

#pragma mark- UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(navigationController && navigationController.viewControllers.count > 0 && viewController == navigationController.viewControllers.firstObject) {
        self.tabBar.hidden = NO;
    } else {
        self.tabBar.hidden = YES;
    }
}
#pragma mark- UIPageViewControllerTools
-(void)changeTabToIndex:(NSInteger)index {
    if (index < self.viewControllers.count) {
        UIViewController *childController = self.viewControllers[index];
        [self.pageViewController setViewControllers:@[childController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            
        }];
     self.selectedViewController = childController;
    }
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
