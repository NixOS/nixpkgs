#include <gio/gio.h>
#include <glib-object.h>

void schema_id_literal() {
  GSettings *settings;
  settings = g_settings_new("org.gnome.evolution-data-server.addressbook");
  g_object_unref(settings);
}

#define SELF_UID_PATH_ID "org.gnome.evolution-data-server.addressbook"
int schema_id_from_constant() {
  GSettings *settings;
  settings = g_settings_new(SELF_UID_PATH_ID);
  g_object_unref(settings);
}

void schema_id_autoptr() {
  g_autoptr(GSettings) settings = NULL;
  settings = g_settings_new("org.gnome.evolution.calendar");
}

int main() {
  schema_id_literal();
  schema_id_from_constant();
  schema_id_autoptr();

  return 0;
}
