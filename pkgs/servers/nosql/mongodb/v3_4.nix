{ stdenv, callPackage, lib, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl;
    inherit boost;
    inherit Security;
    inherit CoreFoundation;
    inherit cctools;
  };
in buildMongoDB {
  version = "3.4.24";
  sha256 = "0j6mvgv0jnsnvgkl8505bl88kbxkba66qijlpi1la0dd5pd1imfr";
  patches = [ ./forget-build-dependencies-3-4.patch ];
  license = stdenv.lib.licenses.agpl3;
}
