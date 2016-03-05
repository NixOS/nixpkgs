{ stdenv, fetchFromGitHub, cmake
, mesa, SDL, SDL_image, SDL_ttf, glew, openalSoft
, ncurses, glib, gtk2, libsndfile
}:

stdenv.mkDerivation {
  name = "dwarf_fortress_unfuck-2016-02-11";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dwarf_fortress_unfuck";
    rev = "2ba59c87bb63bea598825a73bdc896b0e041e2d5";
    sha256 = "0q2rhigvaabdknmb2c84gg71qz7xncmx04npzx4bki9avyxsrpcl";
  };

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2}/lib/gtk-2.0/include"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    mesa SDL SDL_image SDL_ttf glew openalSoft
    ncurses gtk2 libsndfile
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
