//
//  ViewController.m
//  ZHSCrollHeaderDemo
//
//  Created by 左梓豪 on 16/6/30.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ViewController.h"
#import "ZHSCorllHeader.h"

@interface ViewController ()<ZHScrollHeaderTaped>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 网络图片 **/
    /**
     *  所给图片较大,需要等待
     */
    NSArray *array1 = @[@"http://dl.bizhi.sogou.com/images/2012/09/30/44928.jpg",
                        @"http://www.deskcar.com/desktop/star/world/20081017165318/27.jpg",
                        @"http://www.0739i.com.cn/data/attachment/portal/201603/09/120156l1yzzn747ji77ugx.jpg",
                        @"http://image.tianjimedia.com/uploadImages/2012/320/8N5IGLFH4HDY_1920x1080.jpg",
                        @"http://b.hiphotos.baidu.com/zhidao/pic/item/10dfa9ec8a136327c3f37f95938fa0ec08fac77e.jpg",
                        @"http://pic15.nipic.com/20110628/7398485_105718357143_2.jpg"];
    ZHSCorllHeader *header = [[ZHSCorllHeader alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 150)];
    /**
     *  本地图片
     */
    //    [header setImageNameArray:@[@"header0.png",@"header1.jpeg",@"header2.jpg"]];
    header.urlImagesArray = array1;
    header.delegate = self;
    header.time = 3.0f;
    
    [self.view addSubview:header];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)scrollHeaderTapAtIndex:(NSInteger)index {
    NSLog(@"%ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
