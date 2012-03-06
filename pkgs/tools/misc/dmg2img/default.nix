{ stdenv, fetchurl, zlib, bzip2, openssl }:

stdenv.mkDerivation rec {
  name = "dmg2img-1.6.2";

  src = fetchurl {
    url = "http://vu1tur.eu.org/tools/${name}.tar.gz";
    sha256 = "1ibxjsrl9g877qi3jjpv0zdgl4x8j1vnd4y27q17a8my1jkhh5cg";
  };
 
  buildInputs = [zlib bzip2 openssl];

  installPhase = ''
    mkdir -p $out/bin
    cp dmg2img $out/bin
  '';
}
