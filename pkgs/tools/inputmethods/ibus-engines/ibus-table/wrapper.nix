{ stdenv, buildEnv, ibus-table }:

# Intended usage:
# Add something like the following in /etc/nixos/configuration.nix:
# i18n.inputMethod = {
#   enabled = "ibus";
#   ibus.engines = with pkgs.ibus-engines; [
#     (table-with-plugins [ table-others ])
#   ];
# };

plugins:

stdenv.lib.overrideDerivation ibus-table (self: {
  name = "ibus-table-with-plugins-" + self.version;

  paths = plugins;

  postInstall = ''
    for plugin in $paths
    do
      for t in $plugin/share/ibus-table/tables/*
      do
        ln -s "$t" "$out/share/ibus-table/tables"
      done

      for i in $plugin/share/ibus-table/icons/*
      do
        ln -s "$i" "$out/share/ibus-table/icons"
      done
    done
  '';
})
