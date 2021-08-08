{ lib, stdenv, fetchurl, libaio }:

stdenv.mkDerivation {
  name = "blktrace-1.3.0";

  # Official source
  # "git://git.kernel.org/pub/scm/linux/kernel/git/axboe/blktrace.git"
  src = fetchurl {
    url = "http://brick.kernel.dk/snaps/blktrace-1.3.0.tar.bz2";
    sha256 = "sha256-1t7aA4Yt4r0bG5+6cpu7hi2bynleaqf3yoa2VoEacNY=";
  };

  buildInputs = [ libaio ];

  preConfigure = ''
    sed s,/usr/local,$out, -i Makefile
  '';

  meta = {
    description = "Block layer IO tracing mechanism";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
