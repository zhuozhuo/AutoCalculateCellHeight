>UITableViewCell highly adaptive dynamic Cell height has always been our most upset issues encountered, today and share the method I use 'systemLayoutSizeFittingSize' system comes with a height of some ideas! 

**UITableViewCell 高度自适应一直是我们做动态Cell高度时遇到的最烦躁的问题,今天主要和大家分享下我在使用`systemLayoutSizeFittingSize`系统自带方法计算高度的一些心得!**


### 展示gif

![ZHAutoCalculateCellHeight.gif](http://upload-images.jianshu.io/upload_images/2926059-767f4101b3d0806f.gif?imageMogr2/auto-orient/strip)

##先看原函数注释

``` objective-c
/* The size fitting most closely to targetSize in which the receiver's subtree can be laid out while optimally satisfying the constraints. If you want the smallest possible size, pass UILayoutFittingCompressedSize; for the largest possible size, pass UILayoutFittingExpandedSize.
 Also see the comment for UILayoutPriorityFittingSizeLevel.
 */
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize NS_AVAILABLE_IOS(6_0); // Equivalent to sending -systemLayoutSizeFittingSize:withHorizontalFittingPriority:verticalFittingPriority: with UILayoutPriorityFittingSizeLevel for both priorities.

```

*从注释中我们可以看出,当你的约束条件配置好后它可以计算出最接近目标的Size,那我们该如何下手呢?*

##1.首先我们需要建一个UITableViewCell

假如我们Cell的布局如下所示：

![屏幕快照 2016-09-08 17.08.11.png](http://upload-images.jianshu.io/upload_images/2926059-4331432160e72e50.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Cell所对应的Class我们取名为`ZHCalculateTableViewCell`
所带属性我们定义为：

```objective-c
@interface ZHCalculateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImgView;
@property (weak, nonatomic) IBOutlet UILabel *UseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (strong, nonatomic) ZHCalculateHeightModel *model;
@end
```

看到这里也许你会疑惑`ZHCalculateHeightModel`是什么,它是我们Cell所要展示的数据来源！

##2.然后我们为我们的Cell建个数据模型
Cell的模型名称我们暂定为:`ZHCalculateHeightModel`
所带属性：
```objective-c
@interface ZHCalculateHeightModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *imageName;
```

## 3. 创建一个存储Cell Height 的类 ZHCellHeightCalculator

所带属性：

```objective-c
@interface ZHCellHeightCalculator ()
@property (strong, nonatomic, readonly) NSCache *cache;
@end
```

所带方法：

```Ob
@interface ZHCellHeightCalculator : NSObject

//系统计算高度后缓存进cache
-(void)setHeight:(CGFloat)height withCalculateheightModel:(ZHCalculateHeightModel *)model;

//根据model hash 获取cache中的高度,如过无则返回－1
-(CGFloat)heightForCalculateheightModel:(ZHCalculateHeightModel *)model;

//清空cache
-(void)clearCaches;

@end
```



**Ok,数据模型建立好了,展示的TableViewCell也有了, Just Show it~**

##4. 建一个继承于`UITableViewController`的`ZHCustomLayoutTableViewController`

* 建一个在函数`-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath`中调用的Cell：
```objective-c
@property (nonatomic, strong)  ZHCalculateTableViewCell *prototypeCell;
```
* 注册Cell

```objective-c
[self.tableView registerNib:[UINib nibWithNibName:@"ZHCalculateTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
self.tableView.estimatedRowHeight = 100;//很重要保障滑动流畅性
self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

```

* 动态计算高度+缓存

```objective-c
  -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   ZHCalculateHeightModel *model = model = [dataArray objectAtIndex:indexPath.row];
    
    CGFloat height = [heightCalculator heightForCalculateheightModel:model];
    if (height>0) {
        NSLog(@"cache height");
        return height;
    }else{
        NSLog(@"calculate height");
    }
    ZHCalculateTableViewCell *cell = self.prototypeCell;
    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self configureCell:cell atIndexPath:indexPath];//必须先对Cell中的数据进行配置使动态计算时能够知道根据Cell内容计算出合适的高度
    
    /*------------------------------重点这里必须加上contentView的宽度约束不然计算出来的高度不准确-------------------------------------*/
    CGFloat contentViewWidth = CGRectGetWidth(self.tableView.bounds);
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    [cell.contentView addConstraint:widthFenceConstraint];
    // Auto layout engine does its math
    CGFloat fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [cell.contentView removeConstraint:widthFenceConstraint];
    /*-------------------------------End------------------------------------*/
    
    CGFloat cellHeight = fittingHeight+2*1/[UIScreen mainScreen].scale;//必须加上上下分割线的高度
    [heightCalculator setHeight:cellHeight withCalculateheightModel:model];
    return cellHeight;
}


```

### ZHCalculateTableViewCell Model的Set函数重写为
```objective-c
#pragma mark - Setters
-(void)setModel:(ZHCalculateHeightModel *)model
{
    _model = model;
    self.TitleLabel.text = model.title;
    self.ContentLabel.text = model.content;
    self.showImgView.image = model.imageName.length > 0 ? [UIImage imageNamed:model.imageName] : nil;
    self.UseNameLabel.text = model.username;
    self.TimeLabel.text = model.time;
    
}
```

### 扩展
我们可以在计算高度后对其进行缓存,下次可以直接返回！

###总结
* 在`-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath`一定不要用` ZHCalculateTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];`来获取Cell。
* 上述动态计算Cell高度中最最重要的是需要在计算前先初始化Cell中的数据。
* 对高度使用NSCache进行缓存
* 一定要对ContentView加上宽度约束。
```objective-c
 CGFloat contentViewWidth = CGRectGetWidth(self.tableView.bounds);
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    [cell.contentView addConstraint:widthFenceConstraint];
    // Auto layout engine does its math
    CGFloat fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [cell.contentView removeConstraint:widthFenceConstraint];
```
