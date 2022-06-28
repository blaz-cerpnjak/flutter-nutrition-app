import 'package:flutter/material.dart';

class InfoRow extends StatefulWidget {

  final String title;
  final String subtitle;
  final String imageAsset;

  const InfoRow(
    this.title,
    this.subtitle,
    this.imageAsset,
    {Key? key}
  ) : super(key: key);

  @override
  State<InfoRow> createState() => _InfoRowState();
}

class _InfoRowState extends State<InfoRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(widget.imageAsset, height: 50),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontSize: 15),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    widget.subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 13, color: Colors.grey.withOpacity(0.5)),
                  )
                ),
              ],
            )
          ),
        ),
      ],
    );
  }
}