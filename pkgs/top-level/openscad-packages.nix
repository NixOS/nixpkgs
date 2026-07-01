{
  lib,
  newScope,
  openscad,
  buildOpenSCADPackage,
}:

lib.makeScope newScope (
  self:
  lib.recurseIntoAttrs {
    inherit openscad buildOpenSCADPackage;
  }
)
