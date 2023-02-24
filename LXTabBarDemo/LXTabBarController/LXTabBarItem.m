//
//  LXTabBarItem.m
//  Pangu-iOS
//
//  Created by lixuepeng on 2023/2/20.
//

#import "LXTabBarItem.h"
@interface LXTabBarItem()
@property(nonatomic,strong) UIButton *tabBarItemBtn;
@end
@implementation LXTabBarItem
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    if (self = [super init]) {
        self.title = title;
        self.image = image;
        self.selectedImage = selectedImage;
    }
    return self;
}

-(void)setTitle:(NSString *)title {
    _title = title;
    if(self.tabBarItemBtn) {
        [self.tabBarItemBtn setTitle:title forState:UIControlStateNormal];
    }
}

-(void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
}

-(void)setUnselectedItemTintColor:(UIColor *)unselectedItemTintColor {
    _unselectedItemTintColor = unselectedItemTintColor;
}
@end
