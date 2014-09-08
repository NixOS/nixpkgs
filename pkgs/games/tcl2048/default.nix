{ stdenv, fetchurl, tcl, tcllib }:

stdenv.mkDerivation {
  name = "tcl2048-0.2.6";

  src = fetchurl {
    url = https://raw.githubusercontent.com/dbohdan/2048-tcl/v0.2.6/2048.tcl;
    sha256 = "481eac7cccc37d1122c3069da6186f584906bd27b86b8d4ae1a2d7e355c1b6b2";
  };

  builder = ./builder.sh;

  meta = {
    homepage = https://github.com/dbohdan/2048-tcl;
    description = "The game of 2048 implemented in Tcl.";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
