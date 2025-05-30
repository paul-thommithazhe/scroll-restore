# scroll_restore

[![pub package](https://img.shields.io/pub/v/scroll_restore.svg)](https://pub.dev/packages/scroll_restore)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/paul-thommithazhe/scroll-restore/dart.yml?branch=main)](https://github.com/paul-thommithazhe/scroll-restore/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

`scroll_restore` is a tiny Flutter package that **automatically saves and restores** the scroll position of any scrollable widget—across rebuilds, hot reloads, navigation pops/pushes, and even app restarts. No boilerplate, no manual state management: just wrap your `ListView`, `GridView`, or any scrollable, and it “just works.”

---

## 🎯 Features

- ✅ Persist scroll offset using `SharedPreferences`  
- ✅ Restore position on init (clamps if content is shorter)  
- ✅ Simple, one-widget API  
- ✅ Zero external dependencies (except `shared_preferences`)  
- ✅ Compatible with mobile, web, and desktop Flutter apps

---

## 📦 Installation


```yaml
dependencies:
  flutter:
    sdk: flutter

  scroll_restore: ^0.1.0


Then run:


flutter pub get
🚀 Quick Start
Wrap your scrollable in ScrollRestore, giving it a unique id:


import 'package:flutter/material.dart';
import 'package:scroll_restore/scroll_restore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: ScrollRestore(
        id: 'chat_screen_list',  // unique key per scrollable
        builder: (context, controller) {
          return ListView.builder(
            controller: controller,
            itemCount: messages.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(messages[index].text),
              );
            },
          );
        },
      ),
    );
  }
}
id: persisted key in SharedPreferences. Use a different id for each scrollable you want to remember.

The package takes care of saving .offset on every scroll and jumping to it on next build.

📖 Example
A full example app lives in the example/ folder:

cd example
flutter pub get
flutter run
Try scrolling halfway, hot-reloading, navigating away/back, or restarting the app—you’ll stay at the same scroll position!

🧪 Testing
To run the package’s unit & widget tests:

flutter test

⚙️ CI
We use GitHub Actions to:

flutter analyze

flutter test (package & example)

Workflow file: .github/workflows/dart.yml

🛠️ Caveats & Tips
If the saved offset exceeds the new content’s max scroll, it’s clamped to the end.

Works with any ScrollController-driven widget: ListView, GridView, CustomScrollView, etc.

You can nest multiple ScrollRestore widgets on one screen by using different ids.

📜 Changelog
0.1.0
Initial release with basic save & restore logic

Supports clamp-to-boundary and async init

📝 License
MIT © Paul Thommithazhe

## 👤 Author
**Paul *Thommithazhe**  
📧 [paul04kply@gmail.com](mailto:paul04kply@gmail.com)  
🔗 [GitHub](https://github.com/paul-thommithazhe)