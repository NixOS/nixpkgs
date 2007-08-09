{stdenv, fetchurl, libX11, gtk, flex, libICE, bison, libXi,
	mesa, libXcursor, libXinerama, libXrandr, 
	libXrender, libXxf86vm, alsaLib, ncurses, libjpeg,
	lcms}:
stdenv.mkDerivation {
  name = "wine-0.9.42";

  src = fetchurl {
    url = http://switch.dl.sourceforge.net/sourceforge/wine/wine-0.9.42.tar.bz2;
    sha256 = "1hjqpnwvnpgsc776jdxyl4qw38zilwcfi8krvxlv4wsq0c4isr9v";
  };

  buildInputs = [libX11 libICE gtk flex bison libXi mesa libXcursor
	libXinerama libXrandr libXrender libXxf86vm alsaLib ncurses
	libjpeg lcms];
}
