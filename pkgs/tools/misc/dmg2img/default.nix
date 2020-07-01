{ stdenv, fetchurl, zlib, bzip2, openssl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "dmg2img-1.6.7";

  src = fetchurl {
    url = "http://vu1tur.eu.org/tools/${name}.tar.gz";
    sha256 = "066hqhg7k90xcw5aq86pgr4l7apzvnb4559vj5s010avbk8adbh2";
  };

  buildInputs = [ zlib bzip2 openssl ];

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/dmg2img/openssl-1.1.diff";
      sha256 = "076sz69hf3ryylplg025vl8sj991cb81g3yazsmrf8anrd7ffmxx";
    })
  ];

  patchFlags = [ "-p0" ];

  installPhase = ''
    install -D dmg2img $out/bin/dmg2img
    install -D vfdecrypt $out/bin/vfdecrypt
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
    description = "An Apple's compressed dmg to standard (hfsplus) image disk file convert tool.";
    license = stdenv.lib.licenses.gpl3;
  };
}
