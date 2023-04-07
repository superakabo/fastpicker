import 'package:flutter/material.dart';

class SelectionIndicator extends StatelessWidget {
  final bool visible;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry margin;
  final bool selected;

  const SelectionIndicator({
    super.key,
    required this.visible,
    this.margin = const EdgeInsets.only(top: 6, right: 6),
    this.alignment = AlignmentDirectional.bottomEnd,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      selected: selected,
      enabled: visible,
      child: Visibility(
        visible: visible,
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: margin,
            child: SizedBox.square(
              dimension: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? theme.colorScheme.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 0.5,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: Visibility(
                  visible: selected,
                  child: Icon(
                    Icons.check_rounded,
                    size: 12,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
