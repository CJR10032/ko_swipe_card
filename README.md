# KoSwipeCard

模仿探探卡片滑动效果的布局。<br>
已在插件市场发布
https://pub.dev/packages/ko_swipe_card
```
dependencies:
  ko_swipe_card: ^1.0.0
```



## 简单使用
参考：example中的simple_page.dart

```dart
KoSwipeCard(
          //  卡片宽度
          cardWidth: cardWidth,
          //  卡片高度
          cardHeight: cardHeight,
          //  卡片底部高度差
          cardDeltaHeight: cardDeltaHeight,
          //  数据长度
          itemCount: imageList.length,
          //  卡片内容构建
          indexedCardBuilder: (ctx, index, rotateFraction, translateFraction) =>
              //  根据索引创建卡片
              _buildCard(ctx, index, rotateFraction),
          //  顶部卡片划出去的监听
          topCardDismissListener: () {
            setState(() {
              //  删除顶部数据
              imageList.removeAt(0);
            });
          },
        )

///  图片列表
List<Color> imageList = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.teal,
  Colors.orange,
  Colors.purple,
];

///  创建卡片内容
///  [context] 上下文实例
///  [index] 卡片索引
///  [rotateFraction] 卡片旋转百分比
Widget _buildCard(BuildContext context, int index, double rotateFraction) {
  return Container(
    color: imageList[index],
  );
}

```

<img src="https://raw.githubusercontent.com/CJR10032/ko_swipe_card/master/example/card_demo.webp" style="width: 275px;" alt="CardDemo">


### Tantan_demo
参考：example中的test_tantan_page.dart

<img src="https://raw.githubusercontent.com/CJR10032/ko_swipe_card/master/example/tantan_demo.webp" style="width: 275px;" alt="TantanDemo">

