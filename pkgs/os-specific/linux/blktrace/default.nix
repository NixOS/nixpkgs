{ stdenv, fetchurl, libaio }:

stdenv.mkDerivation {
  name = "blktrace-1.2.0";

  # Official source
  # "git://git.kernel.org/pub/scm/linux/kernel/git/axboe/blktrace.git"
  src = fetchurl {
    url = "http://brick.kernel.dk/snaps/blktrace-1.2.0.tar.bz2";
    sha256 = "0i9z7ayh9qx4wi0ihyz15bhr1c9aknjl8v5i8c9mx3rhyy41i5i6";
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
