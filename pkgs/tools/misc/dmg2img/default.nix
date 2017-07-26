{ stdenv, fetchurl, zlib, bzip2, openssl }:

stdenv.mkDerivation rec {
  name = "dmg2img-1.6.7";

  src = fetchurl {
    url = "http://vu1tur.eu.org/tools/${name}.tar.gz";
    sha256 = "066hqhg7k90xcw5aq86pgr4l7apzvnb4559vj5s010avbk8adbh2";
  };

  buildInputs = [zlib bzip2 openssl];

  installPhase = ''
    mkdir -p $out/bin
    cp dmg2img $out/bin
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
    description = "An Apple's compressed dmg to standard (hfsplus) image disk file convert tool.";
    license = stdenv.lib.licenses.gpl3;
  };
}
