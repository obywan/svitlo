import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:svitlo/models/point_item.dart';

import '../helpers/api_request_helper.dart';
import '../providers/points_provider.dart';
import 'fav_button.dart';

class GraphPopup extends StatelessWidget {
  final PointItem point;
  const GraphPopup({Key? key, required this.point}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PointsProvider pp = Provider.of<PointsProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FavButton(
          favourite: pp.isFav(point.hostId),
          onTap: () => pp.favTap(point.hostId),
        ),
        Image.network('${ApiRequestsHelper.baseUrl}${point.graphUrl}'),
      ],
    );
  }
}
