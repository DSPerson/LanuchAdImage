//
//  CheckLauchImage.m
//  Runtime
//
//  Created by 杜帅 on 16/10/13.
//  Copyright © 2016年 杜帅. All rights reserved.
//

#import "CheckLauchImage.h"


/**
 *  动画时间
 */
static const NSTimeInterval timeInterVal = 1.0;

static NSString *const adsFilePath = @"LANUCHIMAGEADPATHFILE";

static NSString *const isAdsDownloadFinsh = @"isAdsDownloadFinsh";


static NSString *const adsName = @"LANUCHIMAGENAME";
@interface CheckLauchImage ()
<
NSURLSessionDataDelegate
>

/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

/** sesion */
@property (nonatomic, strong) NSURLSession *session;

/** 下载图片网址 */
@property (nonatomic, strong) NSURL *imageUrl;

/** 下载流 */
@property (nonatomic, strong) NSOutputStream *outStream;

/** 下载路径 一般情况下 路径 +  static NSString *const adsFilePath*/
@property (nonatomic, copy) NSString *adsCacheFullPath;

/** <#(id)#> */
@property (nonatomic, strong) NSUserDefaults *userD;

/** 管理 */
@property (nonatomic, strong) NSFileManager *fileManager;

/** <#(id)#> */
@property (nonatomic, strong) UIButton *button;

/** 展示时间 */
@property (nonatomic, assign) NSTimeInterval howLong;

/** 确认更新图片 */
@property (nonatomic, assign) BOOL sureUpdateImage;

/** 倒计时时间 */
@property (nonatomic, strong) NSTimer *timer;

/** <#(id)#> */
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation CheckLauchImage

- (NSUserDefaults *)userD {
    if (_userD == nil) {
        _userD = [NSUserDefaults standardUserDefaults];
    }
    return _userD;
}

- (NSFileManager *)fileManager {
    if (_fileManager == nil) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        __block NSTimeInterval num = 0.0;
        __block NSTimeInterval timeInval = self.howLong;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
            NSLog(@"%f", timer.timeInterval);
            num ++;
            if (num - 1> self.howLong) {
                [_timer invalidate];
                _timer = nil;
            }
            NSString *title = [NSString stringWithFormat:@"跳过%.0f",timeInval - 1];
            timeInval -= 1;
            [self.button setTitle:title forState:UIControlStateNormal];
        }];
    }
    return _timer;
}
//开始动画
+ (void)checkLanuchImage:(NSTimeInterval)timerI isShowAd:(BOOL)isShowAd ignore:(BOOL)ignore {
    
    CheckLauchImage *check = [[self alloc] init];
    check.sureUpdateImage = false;
    if (timerI < 0.1) {
        timerI = timeInterVal;
    }
    check.howLong = timerI;
    //如果展示广告
    if (isShowAd) {
        BOOL isExit = [check chargeAdsFilePathHavePhoto];
        //如果存在的话
        if (isExit) {
            
            [check showAdImage:timerI igore:ignore];
        } else {
            [check startAnimation:timerI];
        }
    }else {
        [check startAnimation:timerI];
    }
}

- (void)showIgoreButton:(BOOL)igore superView:(UIView *)superView {
    if (igore) {
        return;
    }
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *title = [NSString stringWithFormat:@"%.0f", self.howLong];
    [self.button setTitle:[@"跳过" stringByAppendingString:title] forState:UIControlStateNormal];
    self.buttonBackColor = self.buttonBackColor ? self.buttonBackColor : [UIColor whiteColor];
    self.button.backgroundColor = self.buttonBackColor;
    self.buttonFont = self.buttonFont ? self.buttonFont : 12;
    self.button.titleLabel.font = [UIFont systemFontOfSize:self.buttonFont];
    self.buttonTitleColor = self.buttonTitleColor ? self.buttonTitleColor : [UIColor blackColor];
    CGSize size = [self.button.titleLabel.text boundingRectWithSize: CGSizeMake(MAXFLOAT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:self.buttonFont] } context:nil].size;
    CGRect fra = CGRectMake(superView.bounds.size.width - size.width - 40, 30, size.width + 20, size.height + 10);
    self.button.frame = fra;
    [self.button setTitleColor:_buttonTitleColor forState:UIControlStateNormal];
    self.button.layer.cornerRadius = 10;
    self.button.layer.masksToBounds = true;
    [superView addSubview:self.button];
    [self.button addTarget:self action:@selector(buttonDump) forControlEvents:UIControlEventTouchUpInside];
    
    [self.timer setFireDate:[NSDate distantPast]];
}
/**
 * func: 跳过
 */
- (void)buttonDump {
    [self.imageView removeFromSuperview];
}
//下载新图片
+ (void)downLauchImageUrl:(NSString *)url update:(BOOL)updateImage {
    CheckLauchImage *check = [[self alloc] init];
    //保存没下载完成
    check.sureUpdateImage = updateImage;
    [check.userD setValue:[NSString stringWithFormat:@"%ld", CacheImageStatus_Delete] forKey:isAdsDownloadFinsh];
    check.imageUrl = [NSURL URLWithString:url];
    [check downLoadScreenLauchImage];
}

- (void)showAdImage:(NSTimeInterval)timerI igore:(BOOL)igore {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
   
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[self.adsCacheFullPath stringByAppendingPathComponent:[self.userD objectForKey:adsName]]];
    if (!image) {
        return;
    }
    self.imageView.userInteractionEnabled = true;
    self.imageView.image = image;
    [window addSubview:self.imageView];
    [self showIgoreButton:igore superView:self.imageView];
    /**[UIView animateWithDuration:timerI delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        imageView.alpha = 0.0f;
        imageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];**/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timerI * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.imageView) {
             [self.imageView removeFromSuperview];
        }
    });
    
}
//判断是否下载完成和缓存时候被删除
- (BOOL)chargeAdsFilePathHavePhoto {
    //创建文件夹
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[self.adsCacheFullPath stringByAppendingPathComponent:[self.userD objectForKey:adsName]]];
    if (image) {
        return true;
    }
    return false;
}

- (NSString *)adsCacheFullPath {
    if (_adsCacheFullPath == nil) {
        _adsCacheFullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:adsFilePath];

    }
    return _adsCacheFullPath;
}

- (NSURLSession *)session {
    if (_session == nil) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
    }
    return _session;
}

- (NSURLSessionDataTask *)dataTask {
    if (nil == _dataTask) {
        NSMutableURLRequest *requst = [NSMutableURLRequest requestWithURL:self.imageUrl];
        requst.HTTPMethod = @"GET";
        _dataTask = [self.session dataTaskWithRequest:requst];
    }
    return _dataTask;
}
- (void)startAnimation:(NSTimeInterval)timerI {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGSize size = window.bounds.size;
    NSString *viewOrientation = @"Portrait";  //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, size) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchView.frame = window.bounds;
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    [window addSubview:launchView];
    
    [UIView animateWithDuration:timerI
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         launchView.alpha = 0.0f;
                         launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [launchView removeFromSuperview];
                         
                     }];
}
/**
 * func: 下载需要的图片并保存起来
 */
- (void)downLoadScreenLauchImage {
    [self.dataTask resume];
}

#pragma mark ------------------
#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    
    NSString *seggustPath = [self.adsCacheFullPath stringByAppendingPathComponent:response.suggestedFilename];
    NSString *seggustName = response.suggestedFilename;
    NSString *lastSeggestName = [self.userD objectForKey:adsName];
    if ([lastSeggestName isEqualToString:seggustName] && !self.sureUpdateImage) {
        [self.userD setValue:[NSString stringWithFormat:@"%ld", CacheImageStatus_Finsh] forKey:isAdsDownloadFinsh];
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    //删除文件夹中
    [self.fileManager removeItemAtPath:self.adsCacheFullPath error:nil];
    //BOOL fileDoucment = [self.fileManager fileExistsAtPath:_adsCacheFullPath];
    [self.fileManager createDirectoryAtPath:self.adsCacheFullPath withIntermediateDirectories:true attributes:nil error:nil];
    self.outStream = ({
        
        NSOutputStream *outS = [[NSOutputStream alloc] initToFileAtPath:seggustPath append:true];
        [outS open];
        outS;
    });
    completionHandler(NSURLSessionResponseAllow);//接收到信息继续下载
   

}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    @synchronized(self){
       NSInteger num =  [self.outStream write:data.bytes maxLength:data.length];
        
        NSLog(@"%ld", (long)num);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    
    NSLog(@"%@", self.adsCacheFullPath);
    [self.outStream close];
    [self.userD setValue:[NSString stringWithFormat:@"%ld", CacheImageStatus_Finsh] forKey:isAdsDownloadFinsh];
     [self.userD setValue:task.response.suggestedFilename forKey:adsName];
}
@end
