//
//  LXTabBarItem.h
//  Pangu-iOS
//
//  Created by lixuepeng on 2023/2/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXTabBarItem : NSObject
- (instancetype _Nonnull)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage;
@property(nullable, nonatomic,strong) UIImage *image;
@property(nullable, nonatomic,strong) UIImage *selectedImage;
@property(nullable, nonatomic,strong) NSString *title;
@property(nonatomic, strong) UIColor *tintColor;
@property(nonatomic, readwrite, copy, nullable) UIColor *unselectedItemTintColor;
@end
NS_ASSUME_NONNULL_END
