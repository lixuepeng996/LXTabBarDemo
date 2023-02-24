//
//  MyTabBarController.m
//  LXTabBarDemo
//
//  Created by lixuepeng on 2023/2/24.
//

#import "MyTabBarController.h"
#import "ViewController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor redColor];//选中颜色
    self.tabBar.unselectedItemTintColor = [UIColor lightGrayColor];//默认颜色

    for (NSInteger i = 0; i < 8; i++) {
        ViewController *vc = [[ViewController alloc] init];
        [self addChildVc:vc title:[NSString stringWithFormat:@"标题%ld",(long)i + 1] image:[NSString stringWithFormat:@"btn_%ld_normal",(long)i + 1] selectedImage:[NSString stringWithFormat:@"btn_%ld_highlight",(long)i + 1]];
    }
    // Do any additional setup after loading the view.
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 先给外面传进来的小控制器 包装 一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav title:title normalImage:[UIImage imageNamed:image] selectedImage:[UIImage imageNamed:selectedImage]];
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
