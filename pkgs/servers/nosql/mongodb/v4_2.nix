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
  version = "4.2.19";
  sha256 = "sha256-fngTHd+fSdHqiqQYOYS7o6P5eHybeZy3iNKkGzFmjTw=";
  patches = [
    ./forget-build-dependencies-4-2.patch
    (fetchpatch {
      name = "mongodb-4.4.1-gcc11.patch";
      url = "https://raw.githubusercontent.com/gentoo/gentoo/7168257cad6ea7c4856b01c5703d0ed5b764367c/dev-db/mongodb/files/mongodb-4.4.1-gcc11.patch";
      sha256 = "sha256-RvfCP462RG+ZVjcb23DgCuxCdfPl2/UgH8N7FgCghGI=";
    })
  ] ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4-2.patch ];
}
