import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

///  创建      CJR
///  创建时间  2020/08/27 10:36
///  信息      Android的OvershootInterpolator效果的估值器
class OvershootInterpolator extends Curve {
  /// Creates an overshoot-interpolator curve.
  const OvershootInterpolator([this.tension = 2.0]);

  /// Amount of overshoot. When tension equals 0.0f, there is
  /// no overshoot and the interpolator becomes a simple
  /// deceleration interpolator.
  final double tension;

  @override
  double transformInternal(double t) {
    t -= 1.0;
    return t * t * ((tension + 1) * t + tension) + 1.0;
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, 'OvershootInterpolator')}($tension)';
  }
}
