{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "sqlite-zandronum";
  version = "3.0";

  src = fetchurl {
    url = "https://www.sqlite.org/2021/sqlite-autoconf-3360000.tar.gz";
    sha256 = "1qxwkfvd185dfcqbakrzikrsw6ffr5jp1gl3dch9dsdyjvmw745x";
  };

  buildPhase = ''
    mkdir -p $out
    cp sqlite3.c $out/
    cp sqlite3.h $out/
    cp sqlite3ext.h $out/
  '';

  meta = {
    homepage = "http://www.sqlite.org/";
    description = "A single C code file, named sqlite3.c, that contains all C code for the core SQLite library and the FTS3 and RTREE extensions";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.lassulus ];
  };
}
