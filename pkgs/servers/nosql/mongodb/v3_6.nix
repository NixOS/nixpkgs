{ stdenv, callPackage, fetchpatch, lib, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl;
    inherit boost;
    inherit Security;
    inherit CoreFoundation;
    inherit cctools;
  };
in buildMongoDB {
  version = "3.6.23";
  sha256 = "sha256-EJpIerW4zcGJvHfqJ65fG8yNsLRlUnRkvYfC+jkoFJ4=";
  patches = [ ./forget-build-dependencies.patch ]
    ++ lib.optionals stdenv.isDarwin [
      (fetchpatch {
        name = "fix double link of isNamedError.";
        url = "https://github.com/mongodb/mongo/commit/9c6751b9765d269b667324bb2efe1ca76a916d20.patch";
        sha256 = "sha256-4mcafqhBh7039ocEI9d/gXWck51X68PqtWtz4dapwwI=";
       })
      ];
}
