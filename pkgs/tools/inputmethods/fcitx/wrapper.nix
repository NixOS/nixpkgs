{ stdenv, symlinkJoin, fcitx, fcitx-configtool, makeWrapper, plugins, kde5 }:

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

symlinkJoin {
  name = "fcitx-with-plugins-${fcitx.version}";

  paths = [ fcitx fcitx-configtool kde5.fcitx-qt5 ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/fcitx \
      --set FCITXDIR "$out/"
  '';
}

