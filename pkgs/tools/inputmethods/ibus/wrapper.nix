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
    # Need to link contents so that the directories are writeable.
    "/lib/systemd"
    "/share/dbus-1/services"
    "/share/systemd/user"
    "/share/systemd/user/gnome-session.target.wants"
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

    ibusPackage="${ibus}"

    # Update services.
    for service in \
        "share/dbus-1/services/org.freedesktop.IBus.service" \
        "share/systemd/user/org.freedesktop.IBus.session.generic.service" \
        "share/systemd/user/org.freedesktop.IBus.session.GNOME.service"
    do
        unlink "$out/$service"
        substitute "$ibusPackage/$service" "$out/$service" --replace "$ibusPackage/bin" "$out/bin"
    done

    # Re-create relative symbolic links.
    for link in \
        "$out/share/systemd/user/gnome-session.target.wants/"*
    do
        target="$link"
        until [[ "''${target:0:1}" != "/" ]]; do
            target="$(readlink "$target")"
        done
        unlink "$link"
        ln -s "$target" "$link"
    done

    # Update absolute symbolic links.
    for link in \
        "$out/lib/systemd/user"
    do
        target="$(readlink -f "$link")"
        relativeTarget="''${target#$ibusPackage/}"
        if [[ "$ibusPackage/$relativeTarget" != "$target" ]]; then
            >&2 echo "File $link does not point to to a file in $ibusPackage"
            exit 1
        fi
        unlink "$link"
        ln -s "$out/$relativeTarget" "$link"
    done
  '';

  inherit (ibus) meta;
}
