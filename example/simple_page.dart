import 'package:flutter/material.dart';
import 'package:ko_swipe_card/ko_swipe_card.dart';

///  测试SwipeCard的页面
class SimplePage extends StatefulWidget {
  @override
  _SimplePageState createState() => _SimplePageState();
}

///  测试SwipeCard页面的state
class _SimplePageState extends State<SimplePage> {
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

  @override
  Widget build(BuildContext context) {
    //  计算卡片宽度, 占屏幕宽度0.85
    double cardWidth = MediaQuery.of(context).size.width * 0.85;
    //  计算卡片高度, 高比宽按比例1.2678计算
    double cardHeight = cardWidth * 1.2678;
    //  卡片底部高度差, 默认是10, 这里取卡片高度的1/35
    double cardDeltaHeight = cardHeight / 35;

    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.black54),
        child: KoSwipeCard(
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
              //  删除顶部数据(添加到末尾, 形成无限循环的demo)
              imageList.add(imageList.removeAt(0));
            });
          },
        ),
      ),
    );
  }

  ///  创建卡片内容
  ///  [context] 上下文实例
  ///  [index] 卡片索引
  ///  [rotateFraction] 卡片旋转百分比
  Widget _buildCard(BuildContext context, int index, double rotateFraction) {
    return Container(
      color: imageList[index],
    );
  }
}
