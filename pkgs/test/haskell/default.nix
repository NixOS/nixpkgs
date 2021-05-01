{ lib, callPackage }:

lib.recurseIntoAttrs {
  shellFor = callPackage ./shellFor { };
  documentationTarball = callPackage ./documentationTarball { };
}
