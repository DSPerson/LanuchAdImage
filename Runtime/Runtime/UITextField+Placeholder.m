//
//  UITextField+Placeholder.m
//  Runtime
//
//  Created by 杜帅 on 16/10/12.
//  Copyright © 2016年 杜帅. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <objc/runtime.h>
#import <objc/message.h>
NSString *const placeHolderColorName = @"placeHolderColorName";
@implementation UITextField (Placeholder)

+ (void)load {
    Method origin = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method ds = class_getInstanceMethod(self, @selector(ds_setPlaceHolderColor:));
    method_exchangeImplementations(origin, ds);
}

- (void)ds_setPlaceHolderColor:(NSString *)placeholder {
    /**
     *  交换方法
     */
    [self ds_setPlaceHolderColor:placeholder];
    self.placeHolderColor = [UIColor redColor];
}
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    objc_setAssociatedObject(self, (__bridge const void *)(placeHolderColorName), placeHolderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 设置占位文字颜色
    UILabel *placeholderLabel = [self valueForKeyPath:@"placeholderLabel"];
    
    placeholderLabel.textColor = placeHolderColor;
}
- (UIColor *)placeHolderColor {
    
    return objc_getAssociatedObject(self, (__bridge const void *)(placeHolderColorName));
    
}

@end
