{ lib, newScope }:

lib.makeScope newScope (self:
let
  inherit (self) callPackage;
in
{

  hare-compress = callPackage ../development/hare-third-party/hare-compress { };
  hare-json = callPackage ../development/hare-third-party/hare-json { };
})
