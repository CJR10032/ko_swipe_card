import 'package:flutter/widgets.dart';

///  创建      CJR
///  创建时间  2020/08/27
///  描述      卡片数据模型
class CardInfoBean {
  ///  图片链接
  final String imageUrl;

  ///  人物名称
  final String personName;

  ///  人物性别
  final int personSex;

  ///  人物年龄
  final String personAge;

  ///  人物星座
  final String personZodiac;

  ///  人物职业
  final String personOccupation;

  ///  图片裁剪方式
  final BoxFit fit;

  CardInfoBean({
    required this.imageUrl,
    required this.personName,
    required this.personSex,
    required this.personAge,
    required this.personZodiac,
    required this.personOccupation,
    this.fit = BoxFit.cover,
  });
}
