{ stdenv, fetchurl, zlib, bzip2, openssl }:

stdenv.mkDerivation rec {
  name = "dmg2img-1.6.5";

  src = fetchurl {
    url = "http://vu1tur.eu.org/tools/${name}.tar.gz";
    sha256 = "021ka05vq7lsdngsglmv93r2j0vfakrkx964xslzhaybwp5ic2j0";
  };

  buildInputs = [zlib bzip2 openssl];

  installPhase = ''
    mkdir -p $out/bin
    cp dmg2img $out/bin
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
