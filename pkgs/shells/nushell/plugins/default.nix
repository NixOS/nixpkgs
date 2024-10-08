{
  lib,
  callPackage,
  newScope,
  IOKit,
  CoreFoundation,
  Foundation,
  Security,
}:
lib.makeScope newScope (self: {
  gstat = callPackage ./gstat.nix { inherit Security; };
  formats = callPackage ./formats.nix { inherit IOKit Foundation; };
  polars = callPackage ./polars.nix { inherit IOKit Foundation; };
  query = callPackage ./query.nix { inherit IOKit CoreFoundation; };
  regex = throw "`nu_plugin_regex` is no longer compatible with the current Nushell release.";
  net = callPackage ./net.nix { inherit IOKit CoreFoundation; };
  dbus = callPackage ./dbus.nix { inherit IOKit; };
})
