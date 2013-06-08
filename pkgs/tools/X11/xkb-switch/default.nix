{ stdenv, fetchgit, cmake, libX11 }:

stdenv.mkDerivation rec {
  name = "xkb-switch-1.2";

  src = fetchgit {
    url = https://github.com/ierton/xkb-switch.git;
    rev = "4c90511ecf2cacc040c97f034a13254c3fa9dfef";
    sha256 = "1jxya67v1qnvbzd0cd5gj7xrwvxyfy1rpa70l8p30p9cmw3ahk41";
  };

  buildInputs = [ cmake libX11 ];

  meta = {
    description = "Switch X layouts from the command line";
    homepage = https://github.com/ierton/xkb-switch.git;
    maintainers = with stdenv.lib.maintainers; [smironov];
    platforms = stdenv.lib.platforms.gnu;
    license = "BSD";
  };
}

