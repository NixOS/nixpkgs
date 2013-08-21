{ stdenv, fetchurl, zlib, bzip2, openssl }:

stdenv.mkDerivation rec {
  name = "dmg2img-1.6.4";

  src = fetchurl {
    url = "http://vu1tur.eu.org/tools/${name}.tar.gz";
    sha256 = "1vcrkphrxdn6dlna8j47a5zaxvdr74msf1sqnc4ldskf35k87fyb";
  };

  buildInputs = [zlib bzip2 openssl];

  installPhase = ''
    mkdir -p $out/bin
    cp dmg2img $out/bin
  '';
}
