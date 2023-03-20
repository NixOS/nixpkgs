{ stdenv, fetchurl, autoconf, automake }:

let
  inherit (stdenv.lib) optional;
  sha256-default = "1ca94d156eb68160ec9b6ed8b97d70fbee996de21437f0cf7d0c3b46709fecbc";
in
stdenv.mkDerivation rec {
  pname = "tmpreaper";
  version = "1.6.17";

  buildInputs = [ autoconf automake ];

  installPhase = ''
    mkdir -p $out/sbin
    cp tmpreaper $out/sbin
    mkdir -p $out/share/man/man8
    cp tmpreaper.8 $out/share/man/man8
  '';

  doCheck = false;

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_${version}.tar.gz";
    sha256 = sha256-default;
  };
  homepage = "https://packages.debian.org/sid/tmpreaper";
  description = "Clean up files in directories based on their age";
  license = "GPL-2.0-only";
  platforms = platforms.darwin;
}
