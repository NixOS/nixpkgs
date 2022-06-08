{ lib
, buildEnv
, makeWrapper
, dconf
, hicolor-icon-theme
, ibus
, librsvg
, plugins ? [ ]
}:

buildEnv {
  name = "ibus-with-plugins-" + lib.getVersion ibus;

  paths = [ ibus ] ++ plugins;

  pathsToLink = [
    "/bin"
    "/etc"
    "/lib"
    "/libexec"
    "/share"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [ ibus ] ++ plugins;

  postBuild = ''
    for prog in ibus; do
        wrapProgram "$out/bin/$prog" \
          --set GDK_PIXBUF_MODULE_FILE ${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache \
          --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH:$out/lib/girepository-1.0" \
          --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules" \
          --set IBUS_COMPONENT_PATH "$out/share/ibus/component/" \
          --set IBUS_DATAROOTDIR "$out/share" \
          --set IBUS_LIBEXECDIR "$out/libexec" \
          --set IBUS_LOCALEDIR "$out/share/locale" \
          --set IBUS_PREFIX "$out" \
          --set IBUS_TABLE_BIN_PATH "$out/bin" \
          --set IBUS_TABLE_DATA_DIR "$out/share" \
          --set IBUS_TABLE_LIB_LOCATION "$out/libexec" \
          --set IBUS_TABLE_LOCATION "$out/share/ibus-table" \
          --prefix PYTHONPATH : "$PYTHONPATH" \
          --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
          --suffix XDG_DATA_DIRS : "${hicolor-icon-theme}/share"
    done

    for prog in ibus-daemon; do
        wrapProgram "$out/bin/$prog" \
          --set GDK_PIXBUF_MODULE_FILE ${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache \
          --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH:$out/lib/girepository-1.0" \
          --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules" \
          --set IBUS_COMPONENT_PATH "$out/share/ibus/component/" \
          --set IBUS_DATAROOTDIR "$out/share" \
          --set IBUS_LIBEXECDIR "$out/libexec" \
          --set IBUS_LOCALEDIR "$out/share/locale" \
          --set IBUS_PREFIX "$out" \
          --set IBUS_TABLE_BIN_PATH "$out/bin" \
          --set IBUS_TABLE_DATA_DIR "$out/share" \
          --set IBUS_TABLE_LIB_LOCATION "$out/libexec" \
          --set IBUS_TABLE_LOCATION "$out/share/ibus-table" \
          --prefix PYTHONPATH : "$PYTHONPATH" \
          --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
          --suffix XDG_DATA_DIRS : "${hicolor-icon-theme}/share" \
          --add-flags "--cache=refresh"
    done
  '';

  inherit (ibus) meta;
}
