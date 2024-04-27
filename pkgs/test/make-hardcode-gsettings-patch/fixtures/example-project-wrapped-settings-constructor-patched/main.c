#include <gio/gio.h>
#include <glib-object.h>

int main() {
  g_autoptr(GSettings) settings;
  {
    g_autoptr(GSettingsSchemaSource) schema_source;
    g_autoptr(GSettingsSchema) schema;
    schema_source = g_settings_schema_source_new_from_directory("@EDS@", g_settings_schema_source_get_default(), TRUE, NULL);
    schema = g_settings_schema_source_lookup(schema_source, "org.gnome.evolution-data-server.addressbook", FALSE);
    settings = g_settings_new_full(schema, NULL, NULL);
  }

  return 0;
}
