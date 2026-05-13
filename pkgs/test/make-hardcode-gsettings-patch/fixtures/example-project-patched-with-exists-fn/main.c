#include <gio/gio.h>
#include <glib-object.h>

void schema_id_literal() {
  GSettings *settings;
  {
    g_autoptr(GSettingsSchemaSource) schema_source;
    g_autoptr(GSettingsSchema) schema;
    schema_source = g_settings_schema_source_new_from_directory("@EDS@", g_settings_schema_source_get_default(), TRUE, NULL);
    schema = g_settings_schema_source_lookup(schema_source, "org.gnome.evolution-data-server.addressbook", FALSE);
    settings = g_settings_new_full(schema, NULL, NULL);
  }
  g_object_unref(settings);
}

#define SELF_UID_PATH_ID "org.gnome.evolution-data-server.addressbook"
int schema_id_from_constant() {
  GSettings *settings;
  {
    g_autoptr(GSettingsSchemaSource) schema_source;
    g_autoptr(GSettingsSchema) schema;
    schema_source = g_settings_schema_source_new_from_directory("@EDS@", g_settings_schema_source_get_default(), TRUE, NULL);
    schema = g_settings_schema_source_lookup(schema_source, SELF_UID_PATH_ID, FALSE);
    settings = g_settings_new_full(schema, NULL, NULL);
  }
  g_object_unref(settings);
}

void schema_id_autoptr() {
  g_autoptr(GSettings) settings = NULL;
  {
    g_autoptr(GSettingsSchemaSource) schema_source;
    g_autoptr(GSettingsSchema) schema;
    schema_source = g_settings_schema_source_new_from_directory("@EVO@", g_settings_schema_source_get_default(), TRUE, NULL);
    schema = g_settings_schema_source_lookup(schema_source, "org.gnome.evolution.calendar", FALSE);
    settings = g_settings_new_full(schema, NULL, NULL);
  }
}

void schema_id_with_backend() {
  GSettings *settings;
  {
    g_autoptr(GSettingsSchemaSource) schema_source;
    g_autoptr(GSettingsSchema) schema;
    schema_source = g_settings_schema_source_new_from_directory("@EDS@", g_settings_schema_source_get_default(), TRUE, NULL);
    schema = g_settings_schema_source_lookup(schema_source, "org.gnome.evolution-data-server.addressbook", FALSE);
    settings = g_settings_new_full(schema, g_settings_backend_get_default(), NULL);
  }
  g_object_unref(settings);
}

void schema_id_with_backend_and_path() {
  GSettings *settings;
  {
    g_autoptr(GSettingsSchemaSource) schema_source;
    g_autoptr(GSettingsSchema) schema;
    schema_source = g_settings_schema_source_new_from_directory("@SEANAUT@", g_settings_schema_source_get_default(), TRUE, NULL);
    schema = g_settings_schema_source_lookup(schema_source, "org.gnome.seahorse.nautilus.window", FALSE);
    settings = g_settings_new_full(schema, g_settings_backend_get_default(), "/org/gnome/seahorse/nautilus/windows/123/");
  }
  g_object_unref(settings);
}

void schema_id_with_path() {
  GSettings *settings;
  {
    g_autoptr(GSettingsSchemaSource) schema_source;
    g_autoptr(GSettingsSchema) schema;
    schema_source = g_settings_schema_source_new_from_directory("@SEANAUT@", g_settings_schema_source_get_default(), TRUE, NULL);
    schema = g_settings_schema_source_lookup(schema_source, "org.gnome.seahorse.nautilus.window", FALSE);
    settings = g_settings_new_full(schema, NULL, "/org/gnome/seahorse/nautilus/windows/123/");
  }
  g_object_unref(settings);
}

void exists_fn_guard() {
  if (!TRUE) {
    return;
  }

  g_autoptr(GSettings) settings = NULL;
  {
    g_autoptr(GSettingsSchemaSource) schema_source;
    g_autoptr(GSettingsSchema) schema;
    schema_source = g_settings_schema_source_new_from_directory("@EVO@", g_settings_schema_source_get_default(), TRUE, NULL);
    schema = g_settings_schema_source_lookup(schema_source, "org.gnome.evolution.calendar", FALSE);
    settings = g_settings_new_full(schema, NULL, NULL);
  }
}

void exists_fn_nested() {
  if (TRUE) {
    g_autoptr(GSettings) settings = NULL;
    {
      g_autoptr(GSettingsSchemaSource) schema_source;
      g_autoptr(GSettingsSchema) schema;
      schema_source = g_settings_schema_source_new_from_directory("@EVO@", g_settings_schema_source_get_default(), TRUE, NULL);
      schema = g_settings_schema_source_lookup(schema_source, "org.gnome.evolution.calendar", FALSE);
      settings = g_settings_new_full(schema, NULL, NULL);
    }
  }
}

void exists_fn_unknown() {
  if (TRUE) {
    g_autoptr(GSettings) settings = NULL;
    {
      g_autoptr(GSettingsSchemaSource) schema_source;
      g_autoptr(GSettingsSchema) schema;
      schema_source = g_settings_schema_source_new_from_directory("@EVO@", g_settings_schema_source_get_default(), TRUE, NULL);
      schema = g_settings_schema_source_lookup(schema_source, "org.gnome.evolution.calendar", FALSE);
      settings = g_settings_new_full(schema, NULL, NULL);
    }
  }
}

int main() {
  schema_id_literal();
  schema_id_from_constant();
  schema_id_autoptr();
  schema_id_with_backend();
  schema_id_with_backend_and_path();
  schema_id_with_path();
  exists_fn_guard();
  exists_fn_nested();
  exists_fn_unknown();

  return 0;
}
