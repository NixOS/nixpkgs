{ lib, stdenv, fetchurl, libaio }:

stdenv.mkDerivation rec {
  pname = "blktrace";
  version = "1.3.0";

  # Official source
  # "https://git.kernel.org/pub/scm/linux/kernel/git/axboe/blktrace.git"
  src = fetchurl {
    url = "https://brick.kernel.dk/snaps/blktrace-${version}.tar.bz2";
    sha256 = "sha256-1t7aA4Yt4r0bG5+6cpu7hi2bynleaqf3yoa2VoEacNY=";
  };

  buildInputs = [ libaio ];

  preConfigure = ''
    sed s,/usr/local,$out, -i Makefile
  '';

  meta = with lib; {
    description = "Block layer IO tracing mechanism";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
