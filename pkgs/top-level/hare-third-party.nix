{ lib, newScope }:

lib.makeScope newScope (self:
let
  inherit (self) callPackage;
in
{
  hare-json = callPackage ../development/hare-packages/hare-json { };

  hare-compress = callPackage ../development/hare-third-party/hare-compress {};
})
