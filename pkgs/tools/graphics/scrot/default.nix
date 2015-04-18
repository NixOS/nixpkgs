{ stdenv, fetchurl, giblib, x11 }:

stdenv.mkDerivation rec {
  name = "scrot-0.8";

  src = fetchurl {
    url = "http://linuxbrit.co.uk/downloads/${name}.tar.gz";
    sha256 = "1wll744rhb49lvr2zs6m93rdmiq59zm344jzqvijrdn24ksiqgb1";
  };

  buildInputs = [ giblib x11 ];

  meta = {
    homepage = http://linuxbrit.co.uk/scrot/;
    description = "A command-line screen capture utility";
    platforms = stdenv.lib.platforms.linux;
  };
}
