{ stdenv, fetchFromGitHub, cmake
, mesa, SDL, SDL_image, SDL_ttf, glew, openalSoft
, ncurses, glib, gtk2, libsndfile, zlib
}:

stdenv.mkDerivation {
  name = "dwarf_fortress_unfuck-2016-04-22";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dwarf_fortress_unfuck";
    rev = "dde40a2c619eac119b6db1bcd0c8d8612472f866";
    sha256 = "12bqh3k4wsk1c0bz2zly8h0ilbsdmsbwr9cdjc6i7liwg9906g7i";
  };

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    mesa SDL SDL_image SDL_ttf glew openalSoft
    ncurses gtk2 libsndfile zlib
  ];

  installPhase = ''
    install -D -m755 ../build/libgraphics.so $out/lib/libgraphics.so
  '';

  enableParallelBuilding = true;

  passthru.dfVersion = "0.42.06";

  meta = with stdenv.lib; {
    description = "Unfucked multimedia layer for Dwarf Fortress";
    homepage = https://github.com/svenstaro/dwarf_fortress_unfuck;
    license = licenses.free;
    platforms = [ "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
