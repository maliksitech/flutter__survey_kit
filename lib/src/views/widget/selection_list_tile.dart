import 'package:flutter/material.dart';

class SelectionListTile extends StatelessWidget {
  final String text;
  final Function onTap;
  final bool isSelected;

  const SelectionListTile({
    Key? key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap.call(),
          excludeFromSemantics: true,
          child: AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: colors.tertiary, width: 1.5),
                color: isSelected ? colors.tertiary.withOpacity(0.4) : null,
              ),
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            // color: isSelected
                            //     ? Theme.of(context).primaryColor
                            //     : Theme.of(context).textTheme.headlineSmall?.color,
                            color: darken(colors.tertiary, .3),
                          ),
                    ),
                  ),
                  isSelected
                      ? Icon(
                          Icons.check,
                          size: 32,
                          // color: isSelected
                          //     ? Theme.of(context).primaryColor
                          //     : Colors.black,
                          color: darken(colors.tertiary, .3),
                        )
                      : Container(
                          width: 32,
                          height: 32,
                        ),
                ],
              )
              // child: ListTile(
              //   title: Text(
              //     text,
              //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //           // color: isSelected
              //           //     ? Theme.of(context).primaryColor
              //           //     : Theme.of(context).textTheme.headlineSmall?.color,
              //           color: darken(colors.tertiary, .3),
              //         ),
              //   ),
              //   trailing: isSelected
              //       ? Icon(
              //           Icons.check,
              //           size: 32,
              //           // color: isSelected
              //           //     ? Theme.of(context).primaryColor
              //           //     : Colors.black,
              //           color: darken(colors.tertiary, .3),
              //         )
              //       : Container(
              //           width: 32,
              //           height: 32,
              //         ),
              //   onTap: () => onTap.call(),
              // ),
              ),
        ),
        // Divider(
        //   color: Colors.grey,
        // ),
      ],
    );
  }
}

class ListWithSpacer extends StatelessWidget {
  final List<Widget> children;
  final Widget? spacer;
  const ListWithSpacer({Key? key, required this.children, this.spacer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (ctx, idx) {
          return children[idx];
        },
        separatorBuilder: (_, __) => spacer ?? listTileSpacer,
        itemCount: children.length);
  }
}

const listTileSpacer = SizedBox(height: 12.0);

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}
