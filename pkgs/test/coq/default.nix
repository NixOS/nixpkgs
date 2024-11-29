{ lib, callPackage }:

lib.recurseIntoAttrs {
  overrideCoqDerivation = callPackage ./overrideCoqDerivation { };
}

