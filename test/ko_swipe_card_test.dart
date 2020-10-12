import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ko_swipe_card/ko_swipe_card.dart';

///  图片列表
List<Color> imageList = [
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.purple,
  Colors.orange,
  Colors.teal,
];

///  测试的app
MaterialApp kowipecardApp = MaterialApp(
  home: Scaffold(
    body: KoSwipeCard(
      //  数据长度
      itemCount: imageList.length,
      //  卡片内容构建
      indexedCardBuilder: (ctx, index, rotateFraction, translateFraction) =>
          //  根据索引创建卡片
          _buildCard(ctx, index, rotateFraction),
      //  顶部卡片划出去的监听
      topCardDismissListener: () {
        //  删除顶部数据
        imageList.removeAt(0);
      },
    ),
  ),
);

///  创建卡片内容
///  [context] 上下文实例
///  [index] 卡片索引
///  [rotateFraction] 卡片旋转百分比
Widget _buildCard(BuildContext context, int index, double rotateFraction) {
  return Container(
    color: imageList[index],
  );
}

void main() {
  testWidgets('render ko_swipe_card', (WidgetTester tester) async {
    await tester.pumpWidget(kowipecardApp);

    expect(find.byType(KoSwipeCard), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });
}
