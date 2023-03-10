//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <webview_universal/webview_universal_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) webview_universal_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WebviewUniversalPlugin");
  webview_universal_plugin_register_with_registrar(webview_universal_registrar);
}
