{ stdenv, runCommand, makeWrapper, lndir
, dconf, hicolor_icon_theme, ibus, librsvg, plugins
}:

let
  name = "ibus-with-plugins-" + (builtins.parseDrvName ibus.name).version;
  env = {
    buildInputs = [ ibus ] ++ plugins;
    nativeBuildInputs = [ lndir makeWrapper ];
    propagatedUserEnvPackages = [ hicolor_icon_theme ];
    paths = [ ibus ] ++ plugins;
    inherit (ibus) meta;
  };
  command = ''
    for dir in bin etc lib libexec share; do
        mkdir -p "$out/$dir"
        for pkg in $paths; do
            if [ -d "$pkg/$dir" ]; then
                lndir -silent "$pkg/$dir" "$out/$dir"
            fi
        done
    done

    for prog in ibus ibus-setup; do
        wrapProgram "$out/bin/$prog" \
          --set GDK_PIXBUF_MODULE_FILE ${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache \
          --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH:$out/lib/girepository-1.0" \
          --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib dconf}/lib/gio/modules" \
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
          --suffix XDG_DATA_DIRS : "${hicolor_icon_theme}/share"
    done

    for prog in ibus-daemon; do
        wrapProgram "$out/bin/$prog" \
          --set GDK_PIXBUF_MODULE_FILE ${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache \
          --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH:$out/lib/girepository-1.0" \
          --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib dconf}/lib/gio/modules" \
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
          --suffix XDG_DATA_DIRS : "${hicolor_icon_theme}/share" \
          --add-flags "--cache=refresh"
    done
  '';
in
  runCommand name env command
