{ lib, stdenv, fetchurl, fetchpatch, zig, ncurses }:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "2.0";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-Zs2mgEdnsukbeM/cqCX5/a9qCkxuQAYloBrVWVQYR8w=";
  };

  patches = [
    ./c-import-order.patch # https://code.blicky.net/yorhel/ncdu/issues/183
  ];

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
