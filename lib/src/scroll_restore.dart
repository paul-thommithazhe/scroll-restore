import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// Wrap any scrollable widget to remember its scroll offset (persisted under [id]).
class ScrollRestore extends StatefulWidget {
  /// Unique identifier for this scrollable. Used as the shared_preferences key.
  final String id;

  /// Build your scrollable, passing in the provided [controller].
  final Widget Function(BuildContext context, ScrollController controller) builder;

  const ScrollRestore({
    Key? key,
    required this.id,
    required this.builder,
  }) : super(key: key);

  @override
  _ScrollRestoreState createState() => _ScrollRestoreState();
}

class _ScrollRestoreState extends State<ScrollRestore> {
  late final ScrollController _controller;
  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_saveOffset);
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final savedOffset = _prefs.getDouble(widget.id) ?? 0.0;

    // Wait for first frame so controller has a valid position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final maxScroll = _controller.position.maxScrollExtent;
      final offset = savedOffset.clamp(0.0, maxScroll);
      _controller.jumpTo(offset);
    });
  }

  void _saveOffset() {
    _prefs.setDouble(widget.id, _controller.offset);
  }

  @override
  void dispose() {
    _controller.removeListener(_saveOffset);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }
}
