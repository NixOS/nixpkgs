{ lib, newScope }:

lib.makeScope newScope (self:
let
  inherit (self) callPackage;
in
{
  harec = callPackage ../development/compilers/harec { };
  hare = callPackage ../development/compilers/hare { };
})
