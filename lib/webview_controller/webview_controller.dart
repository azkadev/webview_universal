import 'webview_controller_web.dart';

export 'webview_controller_web.dart';

extension WebViewControllerExtension on WebViewController {
  void goBackSync() {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      webview_mobile_controller.goBack();
    }
    if (is_desktop) {}
  }

  void goForwardSync() async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      webview_mobile_controller.goForward();
    }
    if (is_desktop) {}
  }

  void goSync({
    required Uri uri,
  }) async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      webview_mobile_controller.loadRequest(uri);
    }
    if (is_desktop) {}
  }

  Future<void> goBack() async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      await webview_mobile_controller.goBack();
    }
    if (is_desktop) {}
  }

  Future<void> goForward() async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      await webview_mobile_controller.goForward();
    }
    if (is_desktop) {}
  }

  Future<void> go({
    required Uri uri,
  }) async {
    if (is_init == false) {
      return;
    }
    if (is_mobile) {
      await webview_mobile_controller.loadRequest(uri);
    }
    if (is_desktop) {}
  }
}
