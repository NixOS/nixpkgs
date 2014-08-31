{ stdenv, fetchurl, tcl, tcllib }:

stdenv.mkDerivation {
  name = "tcl2048-0.2.5";

  src = fetchurl {
    url = https://raw.githubusercontent.com/dbohdan/2048-tcl/v0.2.5/2048.tcl;
    sha256 = "b0d6e8a31dce8c1ca8dbbb8c513b50fbfb9cd6a313201941fa15531165bf68ce";
  };

  builder = ./builder.sh;

  meta = {
    homepage = https://github.com/dbohdan/2048-tcl;
    description = "The game of 2048 implemented in Tcl.";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
