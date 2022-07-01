{ stdenv, fetchurl, patchelf }:

stdenv.mkDerivation rec {
  pname = "patchelf";
  version = "0.9";

  src = fetchurl {
    url = "https://nixos.org/releases/patchelf/patchelf-${version}/patchelf-${version}.tar.bz2";
    sha256 = "a0f65c1ba148890e9f2f7823f4bedf7ecad5417772f64f994004f59a39014f83";
  };

  setupHook = [ ./setup-hook.sh ];

  doCheck = false; # fails 8 out of 24 tests, problems when loading libc.so.6

  inherit (patchelf) meta;
}
