//
//  ZHSCorllHeader.h
//  ZHNetMusicPlayer
//
//  Created by 左梓豪 on 16/6/27.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHScrollHeaderTaped <NSObject>

@optional

- (void)scrollHeaderTapAtIndex:(NSInteger)index;

@end

@interface ZHSCorllHeader : UIView

@property(nonatomic, strong)NSArray *imageNameArray;
@property(nonatomic, strong)NSArray *urlImagesArray;

@property(nonatomic, assign)float time;

@property(nonatomic, weak)id<ZHScrollHeaderTaped>delegate;

@end
