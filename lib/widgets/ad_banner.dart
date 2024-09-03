// import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
// import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0.5, 1),
        // child: UnityBannerAd(
        //   placementId: 'Banner_Android',
        //   onLoad: (placementId) => print('Banner loaded: $placementId'),
        //   onClick: (placementId) => print('Banner clicked: $placementId'),
        //   onShown: (placementId) => print('Banner shown: $placementId'),
        //   onFailed: (placementId, error, message) =>
        //       print('Banner Ad $placementId failed: $error $message'),
        // )
        );
  }
}
