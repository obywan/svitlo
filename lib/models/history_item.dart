class HistoryItem {
  final int itemId;
  final int clock;
  final bool value;

  HistoryItem(this.itemId, this.clock, this.value);

  HistoryItem.fromJson(Map<String, dynamic> json)
      : clock = int.parse(json['clock']),
        itemId = int.parse(json['itemid']),
        value = json['value'] == '1' ? true : false;
}
