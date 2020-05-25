{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "sqlite-zandronum-3.0";

  src = fetchurl {
    url = "https://www.sqlite.org/2017/sqlite-autoconf-3180000.tar.gz";
    sha256 = "0p5cx7nbjxk7glcm277ypi5w4gv144qazw79ql47svlpccj62mrp";
  };

  phases = [ "unpackPhase" "buildPhase" ];

  buildPhase = ''
    mkdir -p $out
    cp sqlite3.c $out/
    cp sqlite3.h $out/
    cp sqlite3ext.h $out/
  '';

  meta = {
    homepage = "http://www.sqlite.org/";
    description = "A single C code file, named sqlite3.c, that contains all C code for the core SQLite library and the FTS3 and RTREE extensions";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ lib.maintainers.lassulus ];
  };
}
