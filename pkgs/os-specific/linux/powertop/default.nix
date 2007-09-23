{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "powertop-1.8";
  src = fetchurl {
    url = http://linuxpowertop.org/download/powertop-1.8.tar.gz;
    sha256 = "0fmdbg00yfzhw5ldc5g6il602lvpmhi9dri4l0pc2ndgwm3fl9bk";
  };
  patches = [./powertop-1.8.patch];
  buildInputs = [ncurses];
}
