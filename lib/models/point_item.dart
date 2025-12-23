import 'package:intl/intl.dart';
import 'package:latlng/latlng.dart';

import 'history_item.dart';

class PointItem {
  final int hostId;
  final String hostName;
  final String graphUrl;
  final LatLng pos;
  final bool active;
  final bool dataloaded;
  final List<HistoryItem> history;

  PointItem({
    required this.history,
    required this.hostId,
    required this.hostName,
    required this.graphUrl,
    required this.pos,
    required this.active,
    this.dataloaded = true,
  });

  String get updateDateTime => DateFormat('EEE, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(history.last.clock * 1000));
  String get updateTime => DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(history.last.clock * 1000));

  static PointItem fromJson(Map<String, dynamic> json) {
    // debugPrint('${json['history']}');
    final List<HistoryItem> hst = List<HistoryItem>.from((json['history']).map((e) => HistoryItem.fromJson(e)));
    final coords = LatLng(Angle.degree(double.parse(json['inventory_location_lat'])), Angle.degree(double.parse(json['inventory_location_lon'])));

    return PointItem(
      hostId: int.parse(json['hostid']),
      history: hst,
      hostName: json['host'],
      graphUrl: json['graph_url'].toString().replaceFirst('/static/', '/static/js/'),
      pos: coords,
      active: hst.last.value,
      dataloaded: hst.isNotEmpty,
    );
  }
}
