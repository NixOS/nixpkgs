{ stdenv, buildEnv, ibus, makeWrapper, plugins, hicolor_icon_theme }:

let
drv = buildEnv {
  name = "ibus-with-plugins-" + (builtins.parseDrvName ibus.name).version;

  paths = [ ibus hicolor_icon_theme ] ++ plugins;

  postBuild = ''
    # TODO: This could be avoided if buildEnv could be forced to create all directories
    if [ -L $out/bin ]; then
      rm $out/bin
      mkdir $out/bin
      for i in ${ibus}/bin/*; do
        ln -s $i $out/bin
      done
    fi
    wrapProgram $out/bin/ibus \
      --set IBUS_COMPONENT_PATH "$out/share/ibus/component/"
    wrapProgram $out/bin/ibus-daemon \
      --set IBUS_COMPONENT_PATH "$out/share/ibus/component/"
  '';
  };
in stdenv.lib.overrideDerivation drv (x : { buildInputs = x.buildInputs ++ [ makeWrapper ]; })
