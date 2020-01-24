import 'dart:ui';
import 'dart:math';

class Density {
  final Size _size;
  Size _sizeSimplex;

  Size get size => _size;
  Size get sizeSimplex => _sizeSimplex;

  @override
  String toString() {
    double maxValue = max(_sizeSimplex.width, _sizeSimplex.height);
    double minValue = min(_sizeSimplex.width, _sizeSimplex.height);
    if (maxValue==8 && minValue==5) {
      maxValue=16;
      minValue=10;
    }
    return "${maxValue.toInt()}:${minValue.toInt()}";
  }

  Density(Size size) : _size = size {
    int mcd = _mcd(width: _size.width.toInt(), height: _size.height.toInt());
    _sizeSimplex = Size((_size.width / mcd), (_size.height / mcd));
  }

  int _mcd({int width, int height}) {
    int res = width % height;
    if (res == 0) {
      return height;
    }
    return _mcd(width: height, height: res);
  }
}
