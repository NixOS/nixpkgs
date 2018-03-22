{stdenv, fetchurl, SDL, SDL_image, libGLU_combined} :

stdenv.mkDerivation {
  name = "kobodeluxe-0.5.1";
  src = fetchurl {
    url = http://olofson.net/kobodl/download/KoboDeluxe-0.5.1.tar.bz2;
    sha256 = "0f7b910a399d985437564af8c5d81d6dcf22b96b26b01488d72baa6a6fdb5c2c";
  };

  buildInputs = [ SDL SDL_image libGLU_combined ];

  prePatch = ''
    sed -e 's/char \*tok/const char \*tok/' -i graphics/window.cpp
  '';

  patches = [ ./glibc29.patch ];

  meta = {
    homepage = http://olofson.net/kobodl/;
    description = "Enhanced version of Akira Higuchi's game XKobo  for Un*x systems with X11";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
