{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation {
  pname = "sqlite-zandronum";
  version = "3.0";

  src = fetchurl {
    url = "https://www.sqlite.org/2017/sqlite-autoconf-3180000.tar.gz";
    hash = "sha256-N1dhJGOXbn0IxenwrzAhYT/CS7z+HFEZfWd2uezprFw=";
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
