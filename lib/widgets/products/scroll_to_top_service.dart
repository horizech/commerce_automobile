import 'package:rxdart/subjects.dart';

class ScrollToTopService {
  final BehaviorSubject<double> _offset = BehaviorSubject.seeded(0);
  Stream<double> get offsetStream$ => _offset.stream;
  double? get currentOffset => _offset.valueWrapper?.value;

  final BehaviorSubject<bool> _goUp = BehaviorSubject.seeded(false);
  Stream<bool> get goUpStream$ => _goUp.stream;

  updateOffset(newValue) {
    _offset.add(newValue);
  }

  resetOffset() {
    updateOffset(0);
  }

  goUp() {
    _goUp.add(true);
  }
}
