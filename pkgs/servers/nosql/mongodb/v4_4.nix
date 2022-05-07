{ stdenv, callPackage, lib, sasl, boost, Security, CoreFoundation, cctools, fetchpatch }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl boost Security CoreFoundation cctools;
  };
in
buildMongoDB {
  version = "4.4.13";
  sha256 = "sha256-ebg3R6P+tjRvizDzsl7mZzhTfqIaRJPfHBu0IfRvtS8=";
  patches = [
    ./forget-build-dependencies-4-4.patch
   (fetchpatch {
      name = "mongodb-4.4.1-gcc11.patch";
      url = "https://raw.githubusercontent.com/gentoo/gentoo/7168257cad6ea7c4856b01c5703d0ed5b764367c/dev-db/mongodb/files/mongodb-4.4.1-gcc11.patch";
      sha256 = "sha256-RvfCP462RG+ZVjcb23DgCuxCdfPl2/UgH8N7FgCghGI=";
    })
  ] ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4-4.patch ];
}
