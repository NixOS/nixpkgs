{ stdenv, fetchurl, tcl, tcllib }:

stdenv.mkDerivation {
  name = "tcl2048-0.2.6";

  src = fetchurl {
    url = https://raw.githubusercontent.com/dbohdan/2048-tcl/v0.2.6/2048.tcl;
    sha256 = "3a6466a214c538daec8e2d08e0c1467f10f770c74e5897bea642134e22016730";
  };

  builder = ./builder.sh;

  meta = {
    homepage = https://github.com/dbohdan/2048-tcl;
    description = "The game of 2048 implemented in Tcl.";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
