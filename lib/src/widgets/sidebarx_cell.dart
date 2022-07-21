import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarXCell extends StatefulWidget {
  const SidebarXCell({
    Key? key,
    required this.item,
    required this.extended,
    required this.selected,
    required this.theme,
    required this.onTap,
    required this.animationController,
  }) : super(key: key);

  final bool extended;
  final bool selected;
  final SidebarXItem item;
  final SidebarXTheme theme;
  final VoidCallback onTap;
  final AnimationController animationController;

  @override
  State<SidebarXCell> createState() => _SidebarXCellState();
}

class _SidebarXCellState extends State<SidebarXCell> {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animation = CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final iconTheme =
        widget.selected ? theme.selectedIconTheme : theme.iconTheme;
    final textStyle =
        widget.selected ? theme.selectedTextStyle : theme.textStyle;
    final decoration =
        (widget.selected ? theme.selectedItemDecoration : theme.itemDecoration);
    final margin =
        (widget.selected ? theme.selectedItemMargin : theme.itemMargin);
    final padding =
        (widget.selected ? theme.selectedItemPadding : theme.itemPadding);
    final textPadding =
        widget.selected ? theme.selectedItemTextPadding : theme.itemTextPadding;

    return Container(
      decoration: decoration,
      margin: margin ?? const EdgeInsets.all(4),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: decoration?.borderRadius?.resolve(TextDirection.ltr),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: widget.extended
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              AnimatedSize(
                duration: widget.animationController.duration ??
                    const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: SizedBox(
                  width: widget.extended
                      ? theme.expandedLeftIconSpace
                      : theme.leftIconSpace,
                ),
              ),
              if (widget.item.icon != null)
                _Icon(item: widget.item, iconTheme: iconTheme)
              else if (widget.item.iconWidget != null)
                widget.item.iconWidget!,
              Flexible(
                child: AnimatedSwitcher(
                  duration: widget.animationController.duration ??
                      const Duration(milliseconds: 300),
                  child: _label(textStyle, textPadding),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(TextStyle? textStyle, EdgeInsets? textPadding) {
    if (widget.extended) {
      return Padding(
        padding: textPadding ?? EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.item.label ?? '',
                style: textStyle,
                overflow: TextOverflow.fade,
                maxLines: 1,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    Key? key,
    required this.item,
    required this.iconTheme,
  }) : super(key: key);

  final SidebarXItem item;
  final IconThemeData? iconTheme;

  @override
  Widget build(BuildContext context) {
    return Icon(
      item.icon,
      color: iconTheme?.color,
      size: iconTheme?.size,
    );
  }
}
