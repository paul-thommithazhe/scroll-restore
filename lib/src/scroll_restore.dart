import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef ScrollRestoreBuilder = Widget Function(BuildContext, ScrollController);

/// Wrap any scrollable widget to remember its scroll offset (persisted under [id]).
class ScrollRestore extends StatefulWidget {
  /// Unique identifier for this scrollable. Used as the shared_preferences key.
  final String id;

  /// Build your scrollable, passing in the provided [controller].
  final ScrollRestoreBuilder builder;

  const ScrollRestore({super.key, required this.id, required this.builder});

  @override
  ScrollRestoreState createState() => ScrollRestoreState();
}

class ScrollRestoreState extends State<ScrollRestore> {
  late final ScrollController _controller;
  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final savedOffset = _prefs.getDouble(widget.id) ?? 0.0;

    // Wait for first frame so controller has a valid position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients) return;

      final maxScroll = _controller.position.maxScrollExtent;
      final offset = savedOffset.clamp(0.0, maxScroll);
      _controller.jumpTo(offset);

      // Start listening to scroll end events after initialization
      _controller.position.isScrollingNotifier.addListener(_saveOffset);
    });
  }

  void _saveOffset() {
    // Only save when scrolling stops
    if (!_controller.position.isScrollingNotifier.value) {
      if (!_controller.hasClients) return;
      _prefs.setDouble(widget.id, _controller.offset);
    }
  }

  @override
  void dispose() {
    _controller.position.isScrollingNotifier.removeListener(_saveOffset);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }
}
