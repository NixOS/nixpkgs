{ stdenv, buildEnv, fcitx, makeWrapper, plugins }:

# This is based on the pidgin-with-plugins package.
# Users should be able to configure what plugins are used
# by putting the following in their /etc/nixos/configuration.nix:
# environment.systemPackages = with pkgs; [
#     (fcitx-with-plugins.override { plugins = [ fcitx-anthy ]; })
# ]
# Or, a normal user could use it by putting the following in his
# ~/.nixpkgs/config.nix:
# packageOverrides = pkgs: with pkgs; rec {
#     (fcitx-with-plugins.override { plugins = [ fcitx-anthy ]; })
# }

let
drv = buildEnv {
  name = "fcitx-with-plugins-" + (builtins.parseDrvName fcitx.name).version;

  paths = [ fcitx ] ++ plugins;

  postBuild = ''
    # TODO: This could be avoided if buildEnv could be forced to create all directories
    if [ -L $out/bin ]; then
      rm $out/bin
      mkdir $out/bin
      for i in ${fcitx}/bin/*; do
        ln -s $i $out/bin
      done
    fi
    wrapProgram $out/bin/fcitx \
      --set FCITXDIR "$out/"
  '';
  };
in stdenv.lib.overrideDerivation drv (x : { buildInputs = x.buildInputs ++ [ makeWrapper ]; })

