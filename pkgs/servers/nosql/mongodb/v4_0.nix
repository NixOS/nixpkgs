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
  version = "4.0.27";
  sha256 = "sha256-ct33mnK4pszhYM4Is7j0GZQRyi8i8Qmy0wcklyq5LjM=";
  patches = [
    ./forget-build-dependencies.patch
    ./mozjs-45_fix-3-byte-opcode.patch
    ./patches/mongodb-4.0-glibc-2.34.patch # https://github.com/NixOS/nixpkgs/issues/171928
    (fetchpatch {
      name = "mongodb-4.4.1-gcc11.patch";
      url = "https://raw.githubusercontent.com/gentoo/gentoo/7168257cad6ea7c4856b01c5703d0ed5b764367c/dev-db/mongodb/files/mongodb-4.4.1-gcc11.patch";
      sha256 = "sha256-RvfCP462RG+ZVjcb23DgCuxCdfPl2/UgH8N7FgCghGI=";
    })
  ]
    ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view.patch ];
}
