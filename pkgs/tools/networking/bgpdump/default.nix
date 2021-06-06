{ lib, stdenv, fetchurl, autoreconfHook, zlib, bzip2 }:

stdenv.mkDerivation rec {
  pname = "bgpdump";
  version = "1.6.0";

  src = fetchurl {
    url = "https://ris.ripe.net/source/bgpdump/libbgpdump-1.6.0.tgz";
    sha256 = "144369gj35mf63nz4idqwsvgsirw7fybm8kkk07yymrjp8jr3aqk";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib bzip2 ];

  meta = {
    homepage = "https://bitbucket.org/ripencc/bgpdump/";
    description = "Analyze dump files produced by Zebra/Quagga or MRT";
    license = lib.licenses.hpnd;
    maintainers = with lib.maintainers; [ lewo ];
    platforms = with lib.platforms; linux;
  };
}
