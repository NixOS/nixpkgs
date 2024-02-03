{ stdenv, callPackage, lib, fetchpatch, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl boost Security CoreFoundation cctools;
  };
in
buildMongoDB {
  version = "4.4.25";
  sha256 = "sha256-oE5bs9M0E43e+8tmZaRkA/GtbKG5uZ+3Pf0sJiddTJk=";
  patches = [
    ./forget-build-dependencies-4-4.patch
    ./fix-build-with-boost-1.79-4_4.patch
    (fetchpatch {
      name = "mongodb-4.4.15-adjust-the-cache-alignment-assumptions.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/mongodb-4.4.15-adjust-cache-alignment-assumptions.patch.arm64?h=mongodb44";
      sha256 = "Ah4zdSFgXUJ/HSN8VRLJqDpNy3CjMCBnRqlpALXzx+g=";
    })
  ] ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4-4.patch ];
}
