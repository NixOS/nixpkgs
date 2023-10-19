{ stdenv, callPackage, lib, fetchpatch, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl boost Security CoreFoundation cctools stdenv;
  };
in
buildMongoDB {
  version = "6.0.10";
  sha256 = "sha256-7YJ0Ndyl635ebDWuIGfC5DFIGUXr518ghC/0Qq42HEM=";
  patches = [
    (fetchpatch {
      name = "mongodb-6.1.0-rc-more-specific-cache-alignment-types.patch";
      url = "https://github.com/mongodb/mongo/commit/5435f9585f857f6145beaf6d31daf336453ba86f.patch";
      sha256 = "sha256-gWlE2b/NyGe2243iNCXzjcERIY8/4ZWI4Gjh5SF0tYA=";
    })
  ];
}
