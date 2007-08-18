{stdenv, fetchurl, libX11, gtk, flex, libICE, bison, libXi,
	mesa, libXcursor, libXinerama, libXrandr, 
	libXrender, libXxf86vm, alsaLib, ncurses, libjpeg,
	lcms}:

stdenv.mkDerivation {
  name = "wine-0.9.43";

  src = fetchurl {
    url = http://switch.dl.sourceforge.net/sourceforge/wine/wine-0.9.43.tar.bz2;
    sha256 = "0r6rz3zi5p7razn957lf2zy290hp36jrlfz4cpy23y9179r8i66x";
  };

  buildInputs = [libX11 libICE gtk flex bison libXi mesa libXcursor
	libXinerama libXrandr libXrender libXxf86vm alsaLib ncurses
	libjpeg lcms];
}
