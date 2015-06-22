{stdenv, fetchurl, autoreconfHook, pkgconfig, pcre, zlib, lzma}:

stdenv.mkDerivation rec {
  name = "silver-searcher-${version}";
  version = "0.30.0";

  src = fetchurl {
    url = "https://github.com/ggreer/the_silver_searcher/archive/${version}.tar.gz";
    sha256 = "1nx5glgd0x55z073qcaazav5sm0jfvxai2bykkldniv6z601pdm3";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  buildInputs = [ autoreconfHook pkgconfig pcre zlib lzma ];

  meta = with stdenv.lib; {
    homepage = https://github.com/ggreer/the_silver_searcher/;
    description = "A code-searching tool similar to ack, but faster";
    maintainers = with maintainers; [ madjar jgeerds ];
    platforms = platforms.all;
    license = licenses.asl20;
  };
}
