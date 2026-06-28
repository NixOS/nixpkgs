{ lib, newScope }:

lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    hare-update = callPackage ../development/tools/hare-tools/hare-update { };
  }
)
