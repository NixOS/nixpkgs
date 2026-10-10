{ lib, newScope }:

lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    hare-adwaita = callPackage ../development/hare-third-party/hare-adwaita { };
    hare-compress = callPackage ../development/hare-third-party/hare-compress { };
    hare-ev = callPackage ../development/hare-third-party/hare-ev { };
    hare-gi = callPackage ../development/hare-third-party/hare-gi { };
    hare-gtk4-layer-shell = callPackage ../development/hare-third-party/hare-gtk4-layer-shell { };
    hare-http = callPackage ../development/hare-third-party/hare-http { };
    hare-json = callPackage ../development/hare-third-party/hare-json { };
    hare-ssh = callPackage ../development/hare-third-party/hare-ssh { };
    hare-toml = callPackage ../development/hare-third-party/hare-toml { };
    hare-png = callPackage ../development/hare-third-party/hare-png { };
    hare-xml = callPackage ../development/hare-third-party/hare-xml { };
  }
)
