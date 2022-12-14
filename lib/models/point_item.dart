import 'package:latlng/latlng.dart';

import 'history_item.dart';

class PointItem {
  final int hostId;
  final String hostName;
  final String graphUrl;
  final LatLng pos;
  final bool active;
  final bool dataloaded;

  PointItem({
    required this.hostId,
    required this.hostName,
    required this.graphUrl,
    required this.pos,
    required this.active,
    this.dataloaded = true,
  });

  static PointItem fromJson(Map<String, dynamic> json) {
    // debugPrint('${json['history']}');
    final List<HistoryItem> history = List<HistoryItem>.from((json['history']).map((e) => HistoryItem.fromJson(e)));

    return PointItem(
      hostId: int.parse(json['hostid']),
      hostName: json['host'],
      graphUrl: json['graph_url'],
      pos: LatLng(double.parse(json['inventory_location_lat']), double.parse(json['inventory_location_lon'])),
      active: history.any((element) => element.value),
      dataloaded: history.isNotEmpty,
    );
  }
}
