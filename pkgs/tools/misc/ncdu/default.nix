{ lib, stdenv, fetchurl, zig, ncurses }:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "2.2.2";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    hash = "sha256-kNkgAk51Ixi0aXds5X4Ds8cC1JMprZglruqzbDur+ZM=";
  };

  XDG_CACHE_HOME="Cache"; # FIXME This should be set in stdenv

  nativeBuildInputs = [
    zig
  ];

  buildInputs = [ ncurses ];

  PREFIX = placeholder "out";

  ZIG_FLAGS = "-Drelease-safe";

  meta = with lib; {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdu";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub SuperSandro2000 rodrgz ];
  };
}
