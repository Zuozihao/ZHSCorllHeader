# ZHSCorllHeader
头部广告轮播图,支持本地图片和网络图片,支持设置轮播时间<br>
创建方式:<br>
######ZHSCorllHeader *header = [[ZHSCorllHeader alloc] initWithFrame:frame];<br>
设置网络图片:
######NSArray *array = @[...];//数组放入图片地址<br>
设置本地图片:
######NSArray *array = @[...];//数组放入图片名<br>
设置轮播时间:
######header.time = time;<br>
获取头部点击事件:
######实现代理:ZHScrollHeaderTaped<br>
<br>
#####未完成:<br>
未实现图片的缓存,待实现
