import 'package:quiver/iterables.dart' as quiver;

extension PartitionExt<T> on Iterable<T> {
  Iterable<List<T>> partition(int size) {
    return quiver.partition(this, size);
  }
}
