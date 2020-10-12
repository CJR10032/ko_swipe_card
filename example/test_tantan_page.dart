import 'package:flutter/material.dart';
import 'package:ko_swipe_card/ko_swipe_card.dart';

import 'CardInfoBean.dart';

///  测试探探效果的页面
class TestTantanPage extends StatefulWidget {
  @override
  _TestTantanPage createState() => _TestTantanPage();
}

///  测试探探效果页面的state
class _TestTantanPage extends State<TestTantanPage> {
  ///  图片列表
  List<CardInfoBean> imageList = [];

  @override
  void initState() {
    super.initState();

    imageList.add(CardInfoBean(
      imageUrl: "assets/sephiroth.jpg",
      personName: "萨菲罗斯",
      personSex: 1,
      personAge: "12",
      personZodiac: "天蝎座",
      personOccupation: "IT/互联网",
    ));

    imageList.add(CardInfoBean(
      imageUrl: "assets/misaka_mikoto.jpg",
      personName: "美琴",
      personSex: 0,
      personAge: "12",
      personZodiac: "天蝎座",
      personOccupation: "IT/互联网",
    ));

    imageList.add(CardInfoBean(
      imageUrl: "assets/misaka.jpg",
      personName: "御坂",
      personSex: 0,
      personAge: "12",
      personZodiac: "天蝎座",
      personOccupation: "IT/互联网",
    ));

    imageList.add(CardInfoBean(
      imageUrl: "assets/misaka_2.jpg",
      personName: "御坂",
      personSex: 0,
      personAge: "12",
      personZodiac: "天蝎座",
      personOccupation: "IT/互联网",
    ));

    imageList.add(CardInfoBean(
      imageUrl: "assets/zinogre.webp",
      personName: "雷娘",
      personSex: 0,
      personAge: "12",
      personZodiac: "天蝎座",
      personOccupation: "IT/互联网",
      fit: BoxFit.fill,
    ));

    imageList.add(CardInfoBean(
      imageUrl: "assets/cloud.jpg",
      personName: "克劳德",
      personSex: 1,
      personAge: "12",
      personZodiac: "天蝎座",
      personOccupation: "IT/互联网",
    ));

    imageList.add(CardInfoBean(
      imageUrl: 'assets/origami.jpg',
      personName: "折纸",
      personSex: 0,
      personAge: "12",
      personZodiac: "射手座",
      personOccupation: "IT/互联网",
    ));

    imageList.add(CardInfoBean(
      imageUrl: 'assets/img_avatar_03.png',
      personName: "派拉斯特",
      personSex: 0,
      personAge: "12",
      personZodiac: "射手座",
      personOccupation: "IT/互联网",
    ));

    imageList.add(CardInfoBean(
      imageUrl:
          "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1598940799744&di=3515e7de080c3e5ce0aa2d05d29a4ad0&imgtype=0&src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201508%2F11%2F20150811161728_MnWiN.thumb.700_0.gif",
      personName: "灰原",
      personSex: 0,
      personAge: "12",
      personZodiac: "双子座",
      personOccupation: "IT/互联网",
    ));

    imageList.add(CardInfoBean(
      imageUrl: "assets/haibara.gif",
      personName: "小哀",
      personSex: 0,
      personAge: "12",
      personZodiac: "水瓶座",
      personOccupation: "IT/互联网",
      fit: BoxFit.fill,
    ));

    imageList.add(CardInfoBean(
      imageUrl: "assets/kudou.gif",
      personName: "工藤",
      personSex: 1,
      personAge: "12",
      personZodiac: "水瓶座",
      personOccupation: "IT/互联网",
      fit: BoxFit.fill,
    ));

    imageList.add(CardInfoBean(
      imageUrl: "assets/kirino.jpg",
      personName: "Kirino",
      personSex: 0,
      personAge: "12",
      personZodiac: "双子座",
      personOccupation: "IT/互联网",
    ));

    imageList.add(CardInfoBean(
      imageUrl: "assets/kame.jpg",
      personName: "Kame",
      personSex: 0,
      personAge: "12",
      personZodiac: "双子座",
      personOccupation: "IT/互联网",
    ));
  }

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
              //  删除顶部数据
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
    //  获取条目数据
    CardInfoBean bean = imageList[index];

    //  竖向排放
    return Column(
      //  左对齐
      crossAxisAlignment: CrossAxisAlignment.start,
      //  子控件列表
      children: <Widget>[
        //  顶部头像
        AspectRatio(
          //  图片宽高比1:1
          aspectRatio: 1 / 1,
          //  使用Stack叠加图片和喜欢不喜欢的icon
          child: Stack(
            children: <Widget>[
              Container(
                //  显示头像
                child: _buildCardImage(bean),
              ),

              //  喜欢的icon
              Positioned(
                top: 12,
                left: 12,
                //  右滑喜欢
                child: _buildLikeIcon(
                    index, rotateFraction, 'assets/img_like.png', 1),
              ),

              //  不喜欢的icon
              Positioned(
                top: 12,
                right: 12,
                //  左滑不喜欢
                child: _buildLikeIcon(
                    index, rotateFraction, 'assets/img_dislike.png', -1),
              ),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 2, left: 12),
          child: Text(
            //  角色姓名
            bean.personName,
            style: const TextStyle(
              fontSize: 16.0,
              color: Color(0xFF333333),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            //  性别和年龄的标签
            _buildTagText(
              bean.personSex == 0
                  ? "♀ ${bean.personAge}"
                  : "♂ ${bean.personAge}",
              0XFFF3C9F5,
              12,
            ),
            //  星座的标签
            _buildTagText(bean.personZodiac, 0XFF269F7A, 4),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 3, left: 12),
          //  职业信息
          child: Text(
            bean.personOccupation,
            style: const TextStyle(
              fontSize: 14.0,
              color: Color(0XFFCBCBCB),
            ),
          ),
        ),
      ],
    );
  }

  ///  构建标签
  ///  [text] 标签文案
  ///  [color] 标签背景色
  ///  [marginLeft] 左边距
  Widget _buildTagText(String text, int color, double marginLeft) {
    return Container(
      margin: EdgeInsets.only(top: 2, left: marginLeft),
      //  文字内边距
      padding: EdgeInsets.all(2),
      //  设置文字背景
      decoration: BoxDecoration(
        //  背景色
        color: Color(color),
        //  背景圆角
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
    );
  }

  ///  显示卡片头像
  ///  [bean] 卡片的数据模型
  Widget _buildCardImage(CardInfoBean bean) {
    String imageUrl = bean.imageUrl;
    //  处理雷娘的动图...
    return imageUrl.startsWith("http")
        ? Image.network(
            imageUrl,
            fit: bean.fit,
            width: double.infinity,
            height: double.infinity,
          )
        : Image.asset(imageUrl,
            fit: bean.fit, width: double.infinity, height: double.infinity);
  }

  ///  创建喜好的icon
  ///  [index] 卡片索引, 第一张卡片才显示icon
  ///  [rotateFraction] 卡片旋转百分比
  ///  [iconUrl] icon的资源路径
  ///  [orientation] 方向, 左滑传-1, 右滑传1
  Widget _buildLikeIcon(
      int index, double rotateFraction, String iconUrl, int orientation) {
    if (index != 0 || orientation * rotateFraction < 0) {
      //  方向不一致, 隐藏
      return Container();
    }

    return Opacity(
      //  透明度, 方向一致才显示icon
      opacity: rotateFraction.abs(),
      child: Image.asset(
        iconUrl,
        width: 66,
        height: 66,
      ),
    );
  }
}
