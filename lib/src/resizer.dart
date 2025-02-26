// import '../shadcn_flutter.dart';

// main() {
//   List<ResizableItem> items = [
//     ResizableItem(value: 80),
//     ResizableItem(value: 80),
//     ResizableItem(value: 120),
//     ResizableItem(value: 80),
//     ResizableItem(value: 80),
//   ];
//   double total = items.fold(0, (prev, item) => prev + item.value);
//   final state = Resizer(items);
//   double result = state.resize(1, 2, 200);
//   print('Applied Delta: $result');
//   for (int i = 0; i < items.length; i++) {
//     print('Item $i: ${items[i].newValue}');
//   }
//   print('Total: ${items.fold(0.0, (prev, item) => prev + item.newValue)}');
//   // double result = state.resize(1, 2, 78.66668701171875);
//   // print('Applied Delta: $result');
//   // for (int i = 0; i < items.length; i++) {
//   //   print('Item $i: ${items[i].newValue}');
//   // }
//   // print('Total: ${items.fold(0.0, (prev, item) => prev + item.newValue)}');
// }

class ResizableItem {
  double _value;
  final double min;
  final double max;
  final bool collapsed;
  final double? collapsedSize;
  final bool resizable;
  double? _newValue;
  bool? _newCollapsed;

  ResizableItem({
    required double value,
    this.min = 0,
    this.max = double.infinity,
    this.collapsed = false,
    this.collapsedSize,
    this.resizable = true,
  }) : _value = value;

  bool get newCollapsed => _newCollapsed ?? collapsed;

  double get newValue {
    return _newValue ?? _value;
  }

  double get value {
    return _value;
  }

  @override
  String toString() {
    return 'ResizableItem(value: $value, min: $min, max: $max)';
  }
}

double _closerToZero(double a, double b) {
  if (a.abs() < b.abs()) {
    return a;
  } else {
    return b;
  }
}

class _BorrowInfo {
  final double givenSize;
  final int from;

  _BorrowInfo(this.givenSize, this.from);
}

class Resizer {
  final List<ResizableItem> items;
  final double collapseRatio;
  final double expandRatio;
  Resizer(
    this.items, {
    this.collapseRatio = 0.5, // half of min size
    this.expandRatio = 0.5, // half of max size
  });

  double _couldNotBorrow = 0;

  double _payOffLoanSize(int index, double delta, int direction) {
    if (direction < 0) {
      for (int i = 0; i < index; i++) {
        double borrowedSize = items[i].newValue - items[i].value;
        if (borrowedSize < 0 && delta > 0) {
          double newBorrowedSize = borrowedSize + delta;
          if (newBorrowedSize > 0) {
            delta = -borrowedSize;
            newBorrowedSize = 0;
          }
          items[i]._newValue = items[i].value + newBorrowedSize;
          return delta;
        } else if (borrowedSize > 0 && delta < 0) {
          double newBorrowedSize = borrowedSize + delta;
          if (newBorrowedSize < 0) {
            delta = -borrowedSize;
            newBorrowedSize = 0;
          }
          items[i]._newValue = items[i].value + newBorrowedSize;
          return delta;
        }
      }
    } else if (direction > 0) {
      for (int i = items.length - 1; i > index; i--) {
        double borrowedSize = items[i].newValue - items[i].value;
        if (borrowedSize < 0 && delta > 0) {
          double newBorrowedSize = borrowedSize + delta;
          if (newBorrowedSize > 0) {
            delta = -borrowedSize;
            newBorrowedSize = 0;
          }
          items[i]._newValue = items[i].value + newBorrowedSize;
          return delta;
        } else if (borrowedSize > 0 && delta < 0) {
          double newBorrowedSize = borrowedSize + delta;
          if (newBorrowedSize < 0) {
            delta = -borrowedSize;
            newBorrowedSize = 0;
          }
          items[i]._newValue = items[i].value + newBorrowedSize;
          return delta;
        }
      }
    }
    return 0;
  }

  ResizableItem? _getItem(int index) {
    if (index < 0 || index >= items.length) {
      return null;
    }
    return items[index];
  }

  _BorrowInfo _borrowSize(int index, double delta, int until, int direction) {
    assert(direction == -1 || direction == 1, 'Direction must be -1 or 1');
    final item = _getItem(index);
    if (item == null) {
      return _BorrowInfo(0, index - direction);
    }
    if (index == until + direction) {
      return _BorrowInfo(0, index);
    }
    if (!item.resizable) {
      return _BorrowInfo(0, index - direction);
    }

    double minSize = item.min;
    double maxSize = item.max;

    if (item.newCollapsed) {
      if ((direction < 0 && delta < 0) || (direction > 0 && delta > 0)) {
        return _borrowSize(index + direction, delta, until, direction);
      }
      return _BorrowInfo(0, index);
    }

    double newSize = item.newValue + delta;

    if (newSize < minSize) {
      double overflow = newSize - minSize;
      double given = delta - overflow;
      var borrowSize = _borrowSize(index + direction, overflow, until, direction);
      item._newValue = minSize;
      return _BorrowInfo(borrowSize.givenSize + given, borrowSize.from);
    }

    if (newSize > maxSize) {
      double maxOverflow = newSize - maxSize;
      double given = delta - maxOverflow;

      var borrowSize = _borrowSize(index + direction, maxOverflow, until, direction);
      item._newValue = maxSize;
      return _BorrowInfo(borrowSize.givenSize + given, borrowSize.from);
    }

    item._newValue = newSize;
    return _BorrowInfo(delta, index);
  }

  bool attemptExpand(int index, int direction, double delta) {
    final item = items[index];
    double currentSize = item.newValue; // check
    double minSize = item.min;
    double maxSize = item.max;
    double newSize = currentSize + delta;
    double minOverflow = newSize - minSize;
    double maxOverflow = newSize - maxSize;

    if (minOverflow < 0 && delta < 0) {
      delta = delta - minOverflow;
    }

    if (maxOverflow > 0 && delta > 0) {
      delta = delta - maxOverflow;
    }

    if (delta == 0) {
      return false;
    }

    if (index == 0) {
      direction = 1;
    } else if (index == items.length - 1) {
      direction = -1;
    }
    if (direction < 0) {
      var borrowed = _borrowSize(index - 1, -delta, 0, -1);
      if (borrowed.givenSize != -delta) {
        reset();
        return false;
      }
      item._newValue = (item.newValue + delta).clamp(minSize, maxSize);
      // check
      return true;
    } else if (direction > 0) {
      var borrowed = _borrowSize(index + 1, -delta, items.length - 1, 1);
      if (borrowed.givenSize != -delta) {
        reset();
        return false;
      }
      item._newValue = (item.newValue + delta).clamp(minSize, maxSize);
      // check
      return true;
    } else if (direction == 0) {
      double halfDelta = delta / 2;
      var borrowedLeft = _borrowSize(index - 1, -halfDelta, 0, -1);
      var borrowedRight = _borrowSize(index + 1, -halfDelta, items.length - 1, 1);
      if (borrowedLeft.givenSize != -halfDelta || borrowedRight.givenSize != -halfDelta) {
        reset();
        return false;
      }
      item._newValue = (item.newValue + delta).clamp(minSize, maxSize);
      // check
      return true;
    }
    return false;
  }

  bool attemptCollapse(int index, int direction) {
    if (index == 0) {
      direction = 1;
    } else if (index == items.length - 1) {
      direction = -1;
    }
    if (direction < 0) {
      final item = items[index];
      final collapsedSize = item.collapsedSize ?? 0;
      final currentSize = item.newValue;
      final delta = currentSize - collapsedSize;
      var borrowed = _borrowSize(index - 1, delta, 0, -1);
      if (borrowed.givenSize != delta) {
        reset();
        return false;
      }
      item._newCollapsed = true;
      return true;
    } else if (direction > 0) {
      final item = items[index];
      final collapsedSize = item.collapsedSize ?? 0;
      final delta = item.newValue - collapsedSize;
      var borrowed = _borrowSize(index + 1, delta, items.length - 1, 1);
      if (borrowed.givenSize != delta) {
        reset();
        return false;
      }
      item._newCollapsed = true;
      return true;
    } else if (direction == 0) {
      final item = items[index];
      final collapsedSize = item.collapsedSize ?? 0;
      final delta = item.newValue - collapsedSize;
      final halfDelta = delta / 2;
      var borrowedLeft = _borrowSize(index - 1, halfDelta, 0, -1);
      var borrowedRight = _borrowSize(index + 1, halfDelta, items.length - 1, 1);
      if (borrowedLeft.givenSize != halfDelta || borrowedRight.givenSize != halfDelta) {
        reset();
        return false;
      }
      item._newCollapsed = true;
      return true;
    }
    return false;
  }

  bool attemptExpandCollapsed(int index, int direction) {
    if (index == 0) {
      direction = 1;
    } else if (index == items.length - 1) {
      direction = -1;
    }
    final item = items[index];
    final collapsedSize = item.collapsedSize ?? 0;
    final currentSize = item.newValue;
    final delta = collapsedSize - currentSize;
    if (direction < 0) {
      var borrowed = _borrowSize(index - 1, delta, 0, -1);
      if (borrowed.givenSize != delta) {
        reset();
        return false;
      }
      item._newCollapsed = false;
      return true;
    } else if (direction > 0) {
      var borrowed = _borrowSize(index + 1, delta, items.length - 1, 1);
      if (borrowed.givenSize != delta) {
        reset();
        return false;
      }
      item._newCollapsed = false;
      return true;
    } else if (direction == 0) {
      final halfDelta = delta / 2;
      var borrowedLeft = _borrowSize(index - 1, halfDelta, 0, -1);
      var borrowedRight = _borrowSize(index + 1, halfDelta, items.length - 1, 1);
      if (borrowedLeft.givenSize != halfDelta || borrowedRight.givenSize != halfDelta) {
        reset();
        return false;
      }
      item._newCollapsed = false;
      return true;
    }
    return false;
  }

  void dragDivider(int index, double delta) {
    if (delta == 0) {
      return;
    }

    var borrowedLeft = _borrowSize(index - 1, delta, 0, -1);
    var borrowedRight = _borrowSize(index, -delta, items.length - 1, 1);

    double borrowedRightSize = borrowedRight.givenSize;
    double borrowedLeftSize = borrowedLeft.givenSize;

    double couldNotBorrowRight = borrowedRightSize + delta;
    double couldNotBorrowLeft = borrowedLeftSize - delta;

    if (couldNotBorrowLeft != 0 || couldNotBorrowRight != 0) {
      _couldNotBorrow += delta;
    } else {
      _couldNotBorrow = 0;
    }

    double givenBackLeft = 0;
    double givenBackRight = 0;

    if (couldNotBorrowLeft != -couldNotBorrowRight) {
      givenBackLeft = _borrowSize(borrowedRight.from, -couldNotBorrowLeft, index, -1).givenSize;
      givenBackRight = _borrowSize(borrowedLeft.from, -couldNotBorrowRight, index - 1, 1).givenSize;
    }

    if (givenBackLeft != -couldNotBorrowLeft || givenBackRight != -couldNotBorrowRight) {
      reset();
      return;
    }

    double payOffLeft = _payOffLoanSize(index - 1, delta, -1);
    double payOffRight = _payOffLoanSize(index, -delta, 1);

    double payingBackLeft = _borrowSize(index - 1, -payOffLeft, 0, -1).givenSize;
    double payingBackRight = _borrowSize(index, -payOffRight, items.length - 1, 1).givenSize;

    if (payingBackLeft != -payOffLeft || payingBackRight != -payOffRight) {
      reset();
      return;
    }

    if (_couldNotBorrow > 0) {
      int start = borrowedRight.from;
      int endNotCollapsed = items.length - 1;
      for (int i = endNotCollapsed; i > start; i--) {
        if (items[i].newCollapsed) {
          endNotCollapsed = i - 1;
        } else {
          break;
        }
      }
      if (start == endNotCollapsed) {
        _checkCollapseUntil(index);
      }
      _checkExpanding(index);
    } else if (_couldNotBorrow < 0) {
      int start = borrowedLeft.from;
      int endNotCollapsed = 0;
      for (int i = endNotCollapsed; i < start; i++) {
        if (items[i].newCollapsed) {
          endNotCollapsed = i + 1;
        } else {
          break;
        }
      }
      if (start == endNotCollapsed) {
        _checkCollapseUntil(index);
      }
      _checkExpanding(index);
    }
  }

  void _checkCollapseUntil(int index) {
    if (_couldNotBorrow < 0) {
      for (int i = index - 1; i >= 0; i--) {
        final previousItem = _getItem(i);
        double? collapsibleSize = previousItem?.collapsedSize;
        if (previousItem != null && collapsibleSize != null && !previousItem.newCollapsed) {
          var minSize = previousItem.min;
          var threshold = (collapsibleSize - minSize) * collapseRatio;
          if (_couldNotBorrow < threshold) {
            var toBorrow = minSize - collapsibleSize;
            var borrowed = _borrowSize(index, toBorrow, items.length - 1, 1);
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize < toBorrow) {
              reset();
              return;
            }
            previousItem._newCollapsed = true;
            previousItem._newValue = previousItem.collapsedSize ?? 0;
            previousItem._value = previousItem._newValue!;
            _couldNotBorrow = 0;
          }
        }
      }
    } else {
      for (int i = index; i < items.length; i++) {
        final nextItem = _getItem(i);
        double? collapsibleSize = nextItem?.collapsedSize;
        if (nextItem != null && collapsibleSize != null && !nextItem.newCollapsed) {
          var minSize = nextItem.min;
          var threshold = (collapsibleSize - minSize) * collapseRatio;
          if (_couldNotBorrow > threshold) {
            var toBorrow = minSize - collapsibleSize;
            var borrowed = _borrowSize(index - 1, toBorrow, 0, -1);
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize < toBorrow) {
              reset();
              return;
            }
            nextItem._newCollapsed = true;
            nextItem._newValue = nextItem.collapsedSize ?? 0;
            nextItem._value = nextItem._newValue!;
            _couldNotBorrow = 0;
          }
        }
      }
    }
  }

  void _checkExpanding(int index) {
    if (_couldNotBorrow > 0) {
      int toCheck = index - 1;
      for (; toCheck >= 0; toCheck--) {
        final item = _getItem(toCheck);
        double? collapsibleSize = item?.collapsedSize;
        if (item != null && item.newCollapsed && collapsibleSize != null) {
          double minSize = item.min;
          double threshold = (minSize - collapsibleSize) * expandRatio;
          if (_couldNotBorrow >= threshold) {
            double toBorrow = collapsibleSize - minSize;
            var borrowed = _borrowSize(toCheck + 1, toBorrow, items.length, 1);
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize > toBorrow) {
              reset();
              continue;
            }
            item._newCollapsed = false;
            item._newValue = minSize;
            item._value = minSize;
            _couldNotBorrow = 0;
          }
          break;
        }
      }
    } else if (_couldNotBorrow < 0) {
      int toCheck = index;
      for (; toCheck < items.length; toCheck++) {
        final item = _getItem(toCheck);
        double? collapsibleSize = item?.collapsedSize;
        if (item != null && collapsibleSize != null && item.newCollapsed) {
          double minSize = item.min;
          double threshold = (collapsibleSize - minSize) * expandRatio;
          if (_couldNotBorrow <= threshold) {
            double toBorrow = collapsibleSize - minSize;
            var borrowed = _borrowSize(toCheck - 1, toBorrow, -1, -1);
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize > toBorrow) {
              reset();
              continue;
            }
            item._newCollapsed = false;
            item._newValue = minSize;
            item._value = minSize;
            _couldNotBorrow = 0;
          }
          break;
        }
      }
    }
  }

  void reset() {
    for (final item in items) {
      if (item._newValue != null) {
        item._newValue = null;
        item._newCollapsed = null;
      }
    }
  }
}
