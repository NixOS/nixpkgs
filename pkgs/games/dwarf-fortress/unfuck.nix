{ stdenv, fetchFromGitHub, cmake
, libGL, libSM, SDL, SDL_image, SDL_ttf, glew, openalSoft
, ncurses, glib, gtk2, libsndfile, zlib
}:

let dfVersion = "0.44.10"; in

stdenv.mkDerivation {
  name = "dwarf_fortress_unfuck-${dfVersion}";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dwarf_fortress_unfuck";
    rev = dfVersion;
    sha256 = "0vb19qx2ibc79j4bgbk9lskb883qfb0815zw1dfz9k7rqwal8mzj";
  };

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libSM SDL SDL_image SDL_ttf glew openalSoft
    ncurses gtk2 libsndfile zlib libGL
  ];

  installPhase = ''
    install -D -m755 ../build/libgraphics.so $out/lib/libgraphics.so
  '';

  enableParallelBuilding = true;

  # Breaks dfhack because of inlining.
  hardeningDisable = [ "fortify" ];

  passthru = { inherit dfVersion; };

  meta = with stdenv.lib; {
    description = "Unfucked multimedia layer for Dwarf Fortress";
    homepage = https://github.com/svenstaro/dwarf_fortress_unfuck;
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
