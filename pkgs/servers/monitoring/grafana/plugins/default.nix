{ newScope, pkgs, lib }:

let
  callPackage = newScope (pkgs // plugins);

  grafanaPlugin = callPackage ./grafana-plugin.nix { };
  pluginData = builtins.fromJSON (builtins.readFile ./plugins.json);

  grafanaPlatformToNix = {
    darwin-amd64 = "x86_64-darwin";
    darwin-arm64 = "aarch64-darwin";
    linux-amd64 = "x86_64-linux";
    linux-arm64 = "aarch64-linux";
  };

  plugins = lib.listToAttrs (builtins.map (plugin: {
    name = plugin.slug;
    value = grafanaPlugin {
      pname = plugin.slug;
      version = plugin.version;
      zipHash = if lib.hasAttr "any" plugin.packages
      then
        plugin.packages.any.sha256
      else
        lib.mapAttrs' (platform: value: { name = grafanaPlatformToNix.${platform}; value = value.sha256; }) (lib.filterAttrs (name: _: lib.hasAttr name grafanaPlatformToNix) plugin.packages);
      meta = {
        description = plugin.description;
      };
    };
  }) pluginData);
in
{
  inherit callPackage;
  inherit grafanaPlugin;
} // plugins
