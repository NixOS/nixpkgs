{ stdenv, runCommand, ibus, lndir, makeWrapper, plugins, hicolor_icon_theme }:

let
  name = "ibus-with-plugins-" + (builtins.parseDrvName ibus.name).version;
  env = {
    nativeBuildInputs = [ lndir makeWrapper ];
    propagatedUserEnvPackages = [ hicolor_icon_theme ];
    paths = [ ibus ] ++ plugins;
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

    for prog in ibus ibus-daemon ibus-setup; do
        wrapProgram "$out/bin/$prog" \
          --suffix XDG_DATA_DIRS : "${hicolor_icon_theme}/share" \
          --set IBUS_COMPONENT_PATH "$out/share/ibus/component/" \
          --set IBUS_DATAROOTDIR "$out/share" \
          --set IBUS_LIBEXECDIR "$out/libexec" \
          --set IBUS_LOCALEDIR "$out/share/locale" \
          --set IBUS_PREFIX "$out" \
          --set IBUS_TABLE_BIN_PATH "$out/bin" \
          --set IBUS_TABLE_DATA_DIR "$out/share" \
          --set IBUS_TABLE_LIB_LOCATION "$out/libexec" \
          --set IBUS_TABLE_LOCATION "$out/share/ibus-table" \
          --set IBUS_TABLE_DEBUG_LEVEL 1
    done
  '';
in
  runCommand name env command
