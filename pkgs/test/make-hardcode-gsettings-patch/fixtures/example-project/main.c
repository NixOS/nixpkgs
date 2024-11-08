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

void schema_id_with_backend() {
  GSettings *settings;
  settings = g_settings_new_with_backend("org.gnome.evolution-data-server.addressbook", g_settings_backend_get_default());
  g_object_unref(settings);
}

void schema_id_with_backend_and_path() {
  GSettings *settings;
  settings = g_settings_new_with_backend_and_path("org.gnome.seahorse.nautilus.window", g_settings_backend_get_default(), "/org/gnome/seahorse/nautilus/windows/123/");
  g_object_unref(settings);
}

void schema_id_with_path() {
  GSettings *settings;
  settings = g_settings_new_with_path("org.gnome.seahorse.nautilus.window", "/org/gnome/seahorse/nautilus/windows/123/");
  g_object_unref(settings);
}

int main() {
  schema_id_literal();
  schema_id_from_constant();
  schema_id_autoptr();
  schema_id_with_backend();
  schema_id_with_backend_and_path();
  schema_id_with_path();

  return 0;
}
