abstract class ListenerListEvent<T> {
  /// 监听的源
  sourceAware(List<T> source) {}

  void onAdd(T item);

  void onRemove(T item);

  void onUpdate(T item) {}

  void onBatchRemove(List<T> items);

  clear();
}

class OnchangeListEvent<T> extends ListenerListEvent<T> {
  final Function onChange;

  OnchangeListEvent(this.onChange);

  @override
  void onAdd(T item) => onChange.call();

  @override
  void onRemove(T item) => onChange.call();

  @override
  void onUpdate(T item) => onChange.call();

  @override
  void onBatchRemove(List<T> items) => onChange.call();

  @override
  clear() => onChange.call();
}

/// 可监听list
/// @author wanghongen
/// 2024/01/30
class ListenableList<T> {
  List<T> source = [];
  final List<ListenerListEvent<T>> _listeners = [];

  ListenableList([List<T>? source]) {
    if (source != null) this.source = source;
  }

  addListener(ListenerListEvent<T> listener) {
    if (_listeners.contains(listener)) return;
    listener.sourceAware(source);
    _listeners.add(listener);
  }

  removeListener(ListenerListEvent<T> listener) {
    _listeners.remove(listener);
  }

  int get length => source.length;

  int indexOf(T item) => source.indexOf(item);

  update(int index, T item) {
    source[index] = item;
    for (var element in _listeners) {
      element.onUpdate(item);
    }
  }

  add(T item) {
    source.add(item);
    for (var element in _listeners) {
      element.onAdd(item);
    }
  }

  bool remove(T item) {
    var remove = source.remove(item);
    if (remove) {
      for (var element in _listeners) {
        element.onRemove(item);
      }
    }
    return remove;
  }

  T removeAt(int index) {
    var item = source.removeAt(index);
    if (item != null) {
      for (var element in _listeners) {
        element.onRemove(item);
      }
    }
    return item;
  }

  clear() {
    source.clear();
    for (var element in _listeners) {
      element.clear();
    }
  }

  removeWhere(bool Function(T element) test) {
    var list = <T>[];
    source.removeWhere((it) {
      if (test.call(it)) {
        list.add(it);
        return true;
      }
      return false;
    });
    if (list.isEmpty) return;

    for (var element in _listeners) {
      element.onBatchRemove(list);
    }
  }
}
