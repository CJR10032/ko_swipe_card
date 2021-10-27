import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ko_swipe_card/src/animation/over_shoot_interpolator.dart';

///  触发惯性动画的阈值
const double _kMinFlingVelocity = 500.0;

///  创建      CJR
///  创建时间  2020/08/27 10:30
///  信息      滑动卡片控件
class KoSwipeCard extends StatefulWidget {
  ///  条目数量
  final int itemCount;

  ///  卡片创建回调
  final IndexedCardBuilder indexedCardBuilder;

  ///   顶部卡片划掉的监听
  final void Function() topCardDismissListener;

  ///  加载的卡片数量至少3张, 默认是4(界面上只能看到3张, 最底下一张是被挡住的)
  final int cardCount;

  ///  卡片宽度
  final double cardWidth;

  ///  卡片高度
  final double cardHeight;

  ///  卡片圆角
  final RoundedRectangleBorder cardRadiusBorder;

  ///  图片左右滑动时的最大旋转角度
  final double maxRotation;

  ///  卡片阴影
  final double cardElevation;

  ///   卡片底部的高度差
  final double cardDeltaHeight;

  ///  卡片的缩放比例, 默认0.1, 第一张卡片1.0, 第二张卡片0.9, 第三张卡片0.8...
  final double cardScalePercent;

  ///  划掉的动画持续时间
  final int dismissDuration;

  ///  恢复原位的动画持续时间
  final int recoverDuration;

  ///  构造方法
  ///  [itemCount] 条目数量
  ///  [indexedCardBuilder] 卡片创建回调
  ///  [topCardDismissListener] 顶部卡片划掉的监听
  ///  [cardCount] 加载的卡片数量至少3张, 默认是4(界面上只能看到3张, 最底下一张是被挡住的)
  ///  [cardWidth] 卡片宽度
  ///  [cardHeight] 卡片高度
  ///  [cardRadiusBorder] 卡片圆角
  ///  [maxRotation] 图片左右滑动时的最大旋转角度
  ///  [cardElevation] 卡片阴影
  ///  [cardDeltaHeight] 卡片底部的高度差
  ///  [cardScalePercent] 卡片的缩放比例, 默认0.1, 第一张卡片1.0, 第二张卡片0.9, 第三张卡片0.8...
  ///  [dismissDuration] 划掉的动画持续时间
  ///  [recoverDuration] 恢复原位的动画持续时间
  KoSwipeCard({
    required this.itemCount,
    required this.indexedCardBuilder,
    required this.topCardDismissListener,
    this.cardCount = 4,
    this.cardWidth = 319.5,
    this.cardHeight = 252,
    this.cardRadiusBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0))),
    this.maxRotation = 15.0,
    this.cardElevation = 3.0,
    this.cardDeltaHeight = 10,
    this.cardScalePercent = 0.1,
    this.dismissDuration = 400,
    this.recoverDuration = 700,
  });

  @override
  KoSwipeCardState createState() => KoSwipeCardState();
}

///  创建      CJR
///  创建时间  2020/08/27 10:34
///  信息      滑动卡片控件的state
class KoSwipeCardState extends State<KoSwipeCard>
    with TickerProviderStateMixin {
  ///  记录移动偏移量的变量
  Offset _offset = Offset.zero;

  ///  动画控制器
  late AnimationController _flingController;

  ///  fling动画
  late Animation<Offset> _flingAnimation;

  ///  滑动动画的controller
  late AnimationController _swipeController;

  ///  滑到阈值, 顶部图片滑出去的动画(没滑到阈值就做恢复动画)
  late Animation<Offset> _swipeAnimation;

  @override
  void initState() {
    super.initState();
    //  创建fling动画控制类
    _flingController = AnimationController(vsync: this)
      //  添加监听, 处理fling
      ..addListener(_handleFlingAnimation)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //  惯性滑动结束, 处理滑动动画
          _startSwipeAnimation();
        }
      });

    //  创建滑动动画控制类
    _swipeController = AnimationController(vsync: this)
      ..addListener(_handleSwipeAnimation)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //  判断是否需要移除顶部卡片
          checkNeedRemoveTop();
        }
      });
  }

  @override
  void dispose() {
    //  取消fling动画
    _flingController.dispose();
    //  取消滑动动画
    _swipeController.dispose();
    super.dispose();
  }

  ///  处理开始位移
  ///  [startDetails] 偏移量
  void _handleOnPanStart(DragStartDetails startDetails) {
    setState(() {
      // The fling src.animation stops if an input gesture starts.
      _flingController.stop();
      //  停止滑动动画
      _swipeController.stop();
      //  判断是否需要移除顶部卡片
      checkNeedRemoveTop();
    });
  }

  /// 处理偏移量更新
  /// [details] 新的偏移量
  void _handleOnPanUpdate(DragUpdateDetails details) {
    setState(() {
      //  更新偏移量
      _offset += details.delta;
    });
  }

  ///  处理位移结束
  ///  [details] 结束的偏移量
  void _handleOnPanEnd(DragEndDetails details) {
    //  获取fling速度
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) {
      //  没到处理fling的阈值, 不处理fling, 直接做滑动动画
      _startSwipeAnimation();
      return;
    }
    //  计算fling的方向
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;

    if (_offset.dx * direction.dx >= 0 && _offset.dy * direction.dy >= 0) {
      //  是往外滑的(惯性与位移方向一致)才处理惯性滑动, 从外面往回丢的不处理惯性
      _startFlingAnimation(magnitude, direction);
    } else {
      //  不处理fling, 直接做滑动动画
      _startSwipeAnimation();
    }
  }

  ///  处理fling动画
  void _handleFlingAnimation() {
    setState(() {
      //  获取fling的offset
      _offset = _flingAnimation.value;
    });
  }

  ///  处理滑动动画
  void _handleSwipeAnimation() {
    setState(() {
      //  获取swipe的offset
      _offset = _swipeAnimation.value;
    });
  }

  ///  开始惯性滑动动画
  ///  [magnitude] fling的速度
  ///  [direction] fling的方向
  void _startFlingAnimation(double magnitude, Offset direction) {
    //  计算fling的距离
    final double distance = (Offset.zero & context.size!).shortestSide / 5;
    _flingAnimation = _flingController.drive(Tween<Offset>(
      begin: _offset,
      end: _offset + direction * distance,
    ));

    _flingController
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  ///  开始滑动动画
  void _startSwipeAnimation() {
    //  获取最大位移(达到这个位移时旋转角度达到最大值)
    double maxRotateTrans = getRotateTranslate();

    //  动画时间, 划掉动画因为没有插值器, 所以动画时间短一点
    Duration duration;

    //  阈值设置为最大位移的一半
    if (_offset.dx.abs() >= maxRotateTrans * 2 / 3) {
      //  划掉时要移动的距离
      int dismissTrans = maxRotateTrans.toInt();

      //  位移的x值
      double deltaX = _offset.dx >= 0
          ? _offset.dx + dismissTrans
          : _offset.dx - dismissTrans;
      //  位移的y值
      double deltaY = _offset.dy + dismissTrans;

      //  超过阈值, 划掉顶部卡片
      _swipeAnimation = _swipeController.drive(Tween<Offset>(
        begin: _offset,
        end: Offset(deltaX, deltaY),
      ));

      //  动画时间
      duration = Duration(milliseconds: widget.dismissDuration);
    } else {
      //  没到阈值, 做恢复动画
      _swipeAnimation = _swipeController
          //  Curves.easeInOutCubic, Curves.easeInOutSine 这两个效果也还可以, 这里
          //  直接搬运原生的OvershootInterpolator(3)
          .drive(CurveTween(curve: OvershootInterpolator(3)))
          .drive(Tween<Offset>(
            begin: _offset,
            end: Offset.zero,
          ));

      //  动画时间
      duration = Duration(milliseconds: widget.recoverDuration);
    }

    _swipeController
      ..value = 0.0
      //  动画时间
      ..duration = duration
      ..forward();
  }

  ///  判断是否需要移除顶部的卡片
  void checkNeedRemoveTop() {
    if (_offset.dx.abs() > getRotateTranslate()) {
      //  滑动结束并且是滑出去的动画, 需要删除第一张图片
      setState(() {
        //  移除顶部图片
        widget.topCardDismissListener();
        //  重新刷新
        _offset = Offset.zero;
      });
    }
  }

  ///  获取卡片宽度
  double getCardWidth() {
    return widget.cardWidth;
  }

  ///  获取卡片高度
  double getCardHeight() {
    return widget.cardHeight;
  }

  ///  获取卡片的缩放比例
  ///  [level] 卡片等级, 从0开始, 第1张传0, 第2张传1, 以此类推
  ///  [rotateFraction] 旋转角度的百分比
  double getCardScale(double level, double rotateFraction) {
    return 1 - ((level - rotateFraction.abs()) * widget.cardScalePercent);
  }

  ///  计算最大位移(达到这个位移时旋转角度达到最大值), 取屏幕的2/3
  double getRotateTranslate() {
    return MediaQuery.of(context).size.width * 2 / 3;
  }

  ///  获取x位移到最大值了的百分比; 值是-1~1之间
  double getRotateFraction() {
    //  获取最大位移(达到这个位移时旋转角度达到最大值)
    double maxRotateTrans = getRotateTranslate();
    return (_offset.dx / maxRotateTrans).clamp(-1.0, 1.0);
  }

  ///  获取卡片位移到了最大值了的百分比; 值是-1~1之间
  double getTranslateFraction() {
    return (_offset.distance / getRotateTranslate()).clamp(-1.0, 1.0);
  }

  ///  获取当前卡片需要做的位移, 卡片的位移比例差设置为第1张卡片高度的1/35
  ///  [level] 卡片等级
  ///  [translateFraction] 卡片位移百分比
  double getCardTranslate(double level, double translateFraction) {
    //  获取卡片高度
    double cardHeight = getCardHeight();
    //  Scale导致的translate值, 因为是在卡片中心进行的Scale, 所以要底部齐平就需要补偿
    double scaleTranslate = cardHeight *
        widget.cardScalePercent *
        0.5 *
        (level - translateFraction.abs());

    if (widget.cardDeltaHeight == 0) {
      //  不需要调节卡片底部位移
      return scaleTranslate;
    }

    //  去掉Scale导致的位移再加上偏移
    return scaleTranslate +
        widget.cardDeltaHeight * (level - translateFraction.abs());
  }

  ///  获取顶部卡片的旋转角度
  double getFrontCardRotation() {
    //  计算x位移到最大值了的百分比
    double fraction = getRotateFraction();

    //  计算旋转角度
    double rotation = (pi / 180) * (fraction * widget.maxRotation);

    return rotation;
  }

  ///  第1张卡片, 使用Align定位
  ///  [context] BuildContext实例
  ///  [level] 卡片等级
  ///  [rotateFraction] 顶部卡片旋转百分比
  ///  [translateFraction] 卡片位移到最大值了的百分比
  Widget _startCard(BuildContext context, double level, double rotateFraction,
      double translateFraction) {
    if (widget.itemCount < 1) {
      //  图片长度不足, 直接返回
      return Container();
    }

    return Transform(
      transform: Matrix4.identity()
        //  设置卡片位移
        ..translate(_offset.dx, _offset.dy)
        //  设置旋转角度
        ..rotateZ(getFrontCardRotation()),
      //  设置旋转中心
      alignment: Alignment.center,
      child: Align(
        //  居中对齐
        alignment: Alignment.center,
        child: Card(
          //  设置圆角
          shape: widget.cardRadiusBorder,
          //  设置阴影
          elevation: widget.cardElevation,
          //  裁剪抗锯齿
          clipBehavior: Clip.antiAlias,
          child: Container(
            //  卡片宽度
            width: getCardWidth(),
            //  卡片高度
            height: getCardHeight(),
            //  构建卡片UI
            child: widget.indexedCardBuilder(
                context, level.toInt(), rotateFraction, translateFraction),
          ),
        ),
      ),
    );
  }

  ///  中间的卡片, 使用Align定位
  ///  [context] BuildContext实例
  ///  [level] 卡片等级
  ///  [rotateFraction] 顶部卡片旋转百分比
  ///  [rotateFraction] 卡片位移到最大值了的百分比
  Widget _middleCard(BuildContext context, double level, double rotateFraction,
      double translateFraction) {
    if (widget.itemCount < level + 1) {
      //  图片长度不足, 直接返回
      return Container();
    }

    //  获取缩放值
    double scale = getCardScale(level, translateFraction);

    return Transform(
      transform: Matrix4.identity()
        //  设置卡片位移
        ..translate(0.0, getCardTranslate(level, translateFraction))
        //  卡片缩放
        ..scale(scale),
      //  设置缩放中心
      alignment: Alignment.center,
      child: Align(
        //  居中对齐
        alignment: Alignment.center,
        child: Card(
          //  设置圆角
          shape: widget.cardRadiusBorder,
          //  设置阴影
          elevation: widget.cardElevation,
          //  裁剪抗锯齿
          clipBehavior: Clip.antiAlias,
          child: Container(
            //  卡片宽度
            width: getCardWidth(),
            //  卡片高度
            height: getCardHeight(),
            //  构建卡片UI
            child: widget.indexedCardBuilder(
                context, level.toInt(), rotateFraction, translateFraction),
          ),
        ),
      ),
    );
  }

  ///  最底部的卡片, 使用Align定位
  ///  [context] BuildContext实例
  ///  [level] 卡片等级
  Widget _endCard(BuildContext context, double level) {
    if (widget.itemCount < widget.cardCount) {
      //  图片长度不足, 直接返回
      return Container();
    }

    //  获取缩放值
    double scale = getCardScale(level, 0);

    return Transform(
      transform: Matrix4.identity()
        //  设置卡片位移
        ..translate(0.0, getCardTranslate(level, 0))
        //  卡片缩放
        ..scale(scale),
      //  设置缩放中心
      alignment: Alignment.center,
      child: Align(
        //  居中对齐
        alignment: Alignment.center,
        child: Card(
          //  设置圆角
          shape: widget.cardRadiusBorder,
          //  设置阴影
          elevation: widget.cardElevation,
          //  裁剪抗锯齿
          clipBehavior: Clip.antiAlias,
          child: Container(
            //  卡片宽度
            width: getCardWidth(),
            //  卡片高度
            height: getCardHeight(),
            //  构建卡片UI
            child: widget.indexedCardBuilder(context, 3, 0, 0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  创建卡片列表的容器
    List<Widget> cardList = [];

    if (widget.cardCount < 3) {
      throw Exception("At least three cards");
    }

    //  顶部卡片旋转百分比
    double rotateFraction = getRotateFraction();
    //  卡片位移的百分比
    double translateFraction = getTranslateFraction();

    for (int cardCount = widget.cardCount, i = cardCount - 1; i >= 0; i--) {
      if (i == 0) {
        //  第1张卡片0级
        cardList.add(_startCard(context, 0, rotateFraction, translateFraction));
      } else if (i == cardCount - 1) {
        //  最后一张卡片, 和倒数第二张卡片同等级
        cardList.add(_endCard(context, (cardCount - 2).toDouble()));
      } else {
        //  中间的卡片
        cardList.add(_middleCard(
            context, i.toDouble(), rotateFraction, translateFraction));
      }
    }

    return GestureDetector(
      onPanStart: (DragStartDetails startDetails) {
        //  手指开始触摸
        _handleOnPanStart(startDetails);
      },
      onPanUpdate: (DragUpdateDetails updateDetails) {
        //  手指滑动
        _handleOnPanUpdate(updateDetails);
      },
      onPanEnd: (DragEndDetails endDetails) {
        //  手指抬起
        _handleOnPanEnd(endDetails);
      },
      //  使用Stack重叠4张卡片
      child: Stack(
        children: cardList,
      ),
    );
  }
}

///  根据卡片索引创建卡片内容的方法
///  [context] 上下文实例
///  [index] 卡片索引
///  [rotateFraction] 顶部卡片旋转百分比
///  [translateFraction] 卡片位移百分比
typedef IndexedCardBuilder = Widget Function(BuildContext context, int index,
    double rotateFraction, double translateFraction);
