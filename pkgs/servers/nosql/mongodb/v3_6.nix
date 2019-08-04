{ stdenv, callPackage, lib, sasl, boost, Security }:

let
  buildMongoDB = callPackage ./mongodb.nix { inherit sasl; inherit boost; inherit Security; };
in
  buildMongoDB {
    version = "3.6.13";
    sha256 = "1mbvk4bmabrswjdm01jssxcygjpq5799zqyx901nsi12vlcymwg4";
    patches = [
      ./forget-build-dependencies.patch
    ];
  }
