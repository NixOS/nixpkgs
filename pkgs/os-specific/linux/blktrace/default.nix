{ stdenv, fetchurl, libaio }:

stdenv.mkDerivation {
  name = "blktrace-1.1.0";

  # Official source
  # "git://git.kernel.org/pub/scm/linux/kernel/git/axboe/blktrace.git"
  src = fetchurl {
    url = "http://brick.kernel.dk/snaps/blktrace-1.1.0.tar.bz2";
    sha256 = "15cj9aki7z5i5y6bnchqry6yp40r4lmgmam6ar5gslnx0smgm8jl";
  };

  buildInputs = [ libaio ];

  preConfigure = ''
    sed s,/usr/local,$out, -i Makefile
  '';

  meta = {
    description = "Block layer IO tracing mechanism";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
