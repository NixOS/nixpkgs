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
  version = "4.2.24";
  sha256 = "sha256-O6nR4wfmupuc/Vjm72Vt8WFmbGm9GHR3p1GlEtgEJpg=";
  patches = [
    ./forget-build-dependencies-4-2.patch
    (fetchpatch {
      name = "mongodb-4.4.1-gcc11.patch";
      url = "https://raw.githubusercontent.com/gentoo/gentoo/7168257cad6ea7c4856b01c5703d0ed5b764367c/dev-db/mongodb/files/mongodb-4.4.1-gcc11.patch";
      sha256 = "sha256-RvfCP462RG+ZVjcb23DgCuxCdfPl2/UgH8N7FgCghGI=";
    })
    (fetchpatch {
      name = "mongodb-4.4.15-adjust-the-cache-alignment-assumptions.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/mongodb-4.4.15-adjust-cache-alignment-assumptions.patch.arm64?h=mongodb44";
      sha256 = "Ah4zdSFgXUJ/HSN8VRLJqDpNy3CjMCBnRqlpALXzx+g=";
    })
  ] ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4-2.patch ];
}
