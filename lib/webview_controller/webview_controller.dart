export 'webview.dart';
import 'webview.dart';

extension WebViewControllerExtension on WebViewController {
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
