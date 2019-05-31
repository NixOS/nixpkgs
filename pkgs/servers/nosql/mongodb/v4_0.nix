{ stdenv, callPackage, lib, sasl, boost, Security }:

let
  buildMongoDB = callPackage ./mongodb.nix { inherit sasl; inherit boost; inherit Security; };
in
  buildMongoDB {
    version = "4.0.9";
    sha256 = "0klm6dl1pr9wq4ghm2jjn3wzs1zpj1aabqjqjfddanxq2an7scph";
    patches = [
      ./forget-build-dependencies.patch
    ];
  }
