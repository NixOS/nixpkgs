/* A set of aliases to be used in generated expressions.

   In case of ambiguity, this will pick a sensible default.

   This was initially based on cabal2nix's mapping.

   It'd be nice to generate this mapping, based on a set of derivations.
   It can not be fully automated, so it should be a expression or tool
   that makes suggestions about which pkg-config module names can be added.
 */
pkgs:

let
  inherit (pkgs) lib;
  inherit (lib)
    flip
    mapAttrs
    getAttrFromPath
    importJSON
    ;

  result = modulePkgs // overrides;

  data = importJSON ./pkg-config/pkg-config-data.json;
  inherit (data) modules;

  modulePkgs = flip mapAttrs modules (_moduleName: moduleData:
    if moduleData?attrPath then
      getAttrFromPath moduleData.attrPath pkgs
    else
      null
  );

  overrides = {
    hidapi = if pkgs.stdenv.isDarwin then pkgs.hidapi else null;
    hidapi-hidraw = if pkgs.stdenv.isDarwin then null else pkgs.hidapi;
    hidapi-libusb = if pkgs.stdenv.isDarwin then null else pkgs.hidapi;
    libpulse-mainloop-glib = if pkgs.stdenv.isDarwin then null else pkgs.libpulseaudio;
    wayland-client = if pkgs.stdenv.isDarwin then null else pkgs.wayland;
    wayland-cursor = if pkgs.stdenv.isDarwin then null else pkgs.wayland;
    egl = if pkgs.stdenv.isDarwin then null else pkgs.libGL;
    wayland-server = if pkgs.stdenv.isDarwin then null else pkgs.wayland;
  };

in
  result
