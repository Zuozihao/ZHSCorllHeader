//
//  ZHSCorllHeader.m
//  ZHNetMusicPlayer
//
//  Created by 左梓豪 on 16/6/27.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHSCorllHeader.h"

@interface ZHSCorllHeader ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIPageControl *pageControl;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)NSTimer *timer;

@end

static NSInteger count;
static float timeDur;

@implementation ZHSCorllHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor grayColor];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pageControl.currentPage = 0;
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
}

- (void)setImageNameArray:(NSArray *)imageNameArray {
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * (imageNameArray.count + 2), self.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    _pageControl.frame = CGRectMake(self.frame.size.width / 2 - 25 * imageNameArray.count / 2 , self.frame.size.height - 35, 25 * imageNameArray.count, 30);
    _pageControl.numberOfPages = imageNameArray.count;
    for (int i = 0; i < (imageNameArray.count + 2); i ++ ) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = i + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
        [imageView addGestureRecognizer:tap];
        NSString *imageName;
        if (i == 0 ) {
            imageName = imageNameArray[imageNameArray.count - 1];
        } else if (i == imageNameArray.count + 1) {
            imageName = imageNameArray[0];
        } else {
            imageName = imageNameArray[i - 1];
        }
        UIImage *image = [UIImage imageNamed:imageName];
        imageView.image = image;
        [_scrollView addSubview:imageView];
    }
    
    count = imageNameArray.count;
}

- (void)setUrlImagesArray:(NSArray *)urlImagesArray {
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * (urlImagesArray.count + 2), self.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    _pageControl.frame = CGRectMake(self.frame.size.width / 2 - 25 * urlImagesArray.count / 2 , self.frame.size.height - 35, 25 * urlImagesArray.count, 30);
    _pageControl.numberOfPages = urlImagesArray.count;
    for (int i = 0; i < (urlImagesArray.count + 2); i ++ ) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = i + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
        [imageView addGestureRecognizer:tap];
        NSString *imageName;
        if (i == 0 ) {
            imageName = urlImagesArray[urlImagesArray.count - 1];
        } else if (i == urlImagesArray.count + 1) {
            imageName = urlImagesArray[0];
        } else {
            imageName = urlImagesArray[i - 1];
        }

       dispatch_async(dispatch_get_global_queue(0, 0), ^{
           [self downloadImageWithURL:[NSURL URLWithString:imageName] completionBlock:^(UIImage *image) {
               imageView.image = image;
           }];

       });
        [_scrollView addSubview:imageView];
    }
    count = urlImagesArray.count;
}

- (void)setTime:(float)time {
    timeDur = time;
    _timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    NSInteger page = _pageControl.currentPage;
    if (page == (count - 1)) {
        _pageControl.currentPage = 0;
        [UIView animateWithDuration:0.3f animations:^{
            _scrollView.contentOffset = CGPointMake(self.frame.size.width * (count+1), 0);
        }];
        _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    } else {
        _pageControl.currentPage = _pageControl.currentPage + 1;
        [UIView animateWithDuration:0.3f animations:^{
           _scrollView.contentOffset = CGPointMake(self.frame.size.width * (_pageControl.currentPage+1), 0); 
        }];
    }
}

- (void)tapHeader:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(scrollHeaderTapAtIndex:)]) {
        
        NSInteger index;
        
        if (sender.view.tag == 100) {
            index = count - 1;
        } else if (sender.view.tag == 100 + count + 1) {
            index = 0;
        } else {
            index = sender.view.tag - 100 - 1;
        }
        
        [self.delegate scrollHeaderTapAtIndex:index];
    }
}


#pragma mark - 下载图片
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void(^)(UIImage *image))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        __block UIImage *image = nil;
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            image = [UIImage imageWithData:data];
            if (block) {
                block(image);
            }
        }] resume];
        
    });
}

#pragma mark - 缓存路径
- (NSString *)cachePath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/ScrollCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    NSInteger page = x / self.frame.size.width;
    
    if (page == 0) {
        _scrollView.contentOffset = CGPointMake(self.frame.size.width * count, 0);
        _pageControl.currentPage = _pageControl.numberOfPages - 1;
    } else if (page ==  (count + 1)) {
        _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        _pageControl.currentPage = 0;
    } else {
        _pageControl.currentPage = page - 1;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
