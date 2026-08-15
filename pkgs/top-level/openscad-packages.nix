{
  lib,
  newScope,
  openscad,
}:

let
  openscadOrig = openscad;
in
lib.makeScope newScope (
  self:
  lib.recurseIntoAttrs {
    buildOpenSCADPackage = self.callPackage ../build-support/build-openscad-package { };
    openscad = openscadOrig.override { openscadPackages = self; };
    bosl = self.callPackage ../development/openscad-packages/bosl { };
    bosl2 = self.callPackage ../development/openscad-packages/bosl2 { };
  }
)
