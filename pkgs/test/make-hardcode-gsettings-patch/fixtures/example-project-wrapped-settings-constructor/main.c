#include <gio/gio.h>
#include <glib-object.h>

void my_settings_new(const char *schema_id) {
  return g_settings_new(schema_id);
}

int main() {
  g_autoptr (GSettings) settings;
  settings = my_settings_new("org.gnome.evolution-data-server.addressbook");

  return 0;
}
