{ stdenv, callPackage, fetchpatch
, sasl, boost, Security, CoreFoundation, cctools
, avxSupport ? stdenv.hostPlatform.avxSupport
}:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl boost Security CoreFoundation cctools stdenv;
  };
in
buildMongoDB {
  inherit avxSupport;
  version = "6.0.16";
  sha256 = "sha256-DdMWacJTx6sxgIKG2M8DkboSBr0fD2w91M+ZYt75hQI=";
  patches = [
    # Patches a bug that it couldn't build MongoDB 6.0 on gcc 13 because a include in ctype.h was missing
    ./fix-gcc-13-ctype-6_0.patch

    (fetchpatch {
      name = "mongodb-6.1.0-rc-more-specific-cache-alignment-types.patch";
      url = "https://github.com/mongodb/mongo/commit/5435f9585f857f6145beaf6d31daf336453ba86f.patch";
      sha256 = "sha256-gWlE2b/NyGe2243iNCXzjcERIY8/4ZWI4Gjh5SF0tYA=";
    })
  ];
  # passthru.tests = { inherit (nixosTests) mongodb; }; # currently tests mongodb-5_0
}
