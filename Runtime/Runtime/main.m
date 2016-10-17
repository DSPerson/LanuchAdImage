//
//  main.m
//  Runtime
//
//  Created by 杜帅 on 16/10/10.
//  Copyright © 2016年 杜帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

void sayFunction(id self ,SEL _cmd ,id some) {
    
}
int main(int argc, char * argv[]) {
    @autoreleasepool {
        //动态创建对象，创建一个Person类，继承与NSObject
        Class People = objc_allocateClassPair([NSObject class], "Person", 0);
        //为该类添加属性
        class_addIvar(People, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
