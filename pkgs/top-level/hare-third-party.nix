{ lib, newScope }:

lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    hare-compress = callPackage ../development/hare-third-party/hare-compress { };
    hare-ev = callPackage ../development/hare-third-party/hare-ev { };
    hare-http = callPackage ../development/hare-third-party/hare-http { };
    hare-json = callPackage ../development/hare-third-party/hare-json { };
    hare-ssh = callPackage ../development/hare-third-party/hare-ssh { };
    hare-toml = callPackage ../development/hare-third-party/hare-toml { };
    hare-png = callPackage ../development/hare-third-party/hare-png { };
  }
)
