import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import '../providers/points_provider.dart';

class FavButton extends StatelessWidget {
  final bool favourite;
  final Function onTap;
  const FavButton({Key? key, required this.favourite, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: favourite
          ? const Icon(
              Icons.star,
              color: Colors.amber,
            )
          : const Icon(Icons.star_border),
      onPressed: () => onTap(),
    );
  }
}
