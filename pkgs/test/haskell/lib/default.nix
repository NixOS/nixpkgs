{
  lib,
  callPackage,
}:

lib.recurseIntoAttrs {
  combineInputs = callPackage ./combineInputs { };
}
