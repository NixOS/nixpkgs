{ lib, stdenv, fetchurl, zig, ncurses }:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "2.1.2";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-ng1u8DYYo8MWcmv0khe37+Rc7HWLLJF86JLe10Myxtw=";
  };

  XDG_CACHE_HOME="Cache"; # FIXME This should be set in stdenv

  nativeBuildInputs = [
    zig
  ];

  buildInputs = [ ncurses ];

  PREFIX = placeholder "out";

  meta = with lib; {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdu";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub SuperSandro2000 ];
  };
}
