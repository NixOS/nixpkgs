{ stdenv, fetchFromGitHub, cmake
, mesa_noglu, libSM, SDL, SDL_image, SDL_ttf, glew, openalSoft
, ncurses, glib, gtk2, libsndfile, zlib
}:

stdenv.mkDerivation {
  name = "dwarf_fortress_unfuck-2016-07-13";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dwarf_fortress_unfuck";
    rev = "d6a4ee67e7b41bec1caa87548640643db35a6080";
    sha256 = "17p7jzmwd5z54wn6bxmic0i8y8mma3q359zcy3r9x2mp2wv1yd7p";
  };

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libSM SDL SDL_image SDL_ttf glew openalSoft
    ncurses gtk2 libsndfile zlib mesa_noglu
  ];

  installPhase = ''
    install -D -m755 ../build/libgraphics.so $out/lib/libgraphics.so
  '';

  enableParallelBuilding = true;

  # Breaks dfhack because of inlining.
  hardeningDisable = [ "fortify" ];

  passthru.dfVersion = "0.43.05";

  meta = with stdenv.lib; {
    description = "Unfucked multimedia layer for Dwarf Fortress";
    homepage = https://github.com/svenstaro/dwarf_fortress_unfuck;
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
