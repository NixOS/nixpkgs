{ stdenv, fetchFromGitHub, cmake
, libGL, libSM, SDL, SDL_image, SDL_ttf, glew, openalSoft
, ncurses, glib, gtk2, libsndfile, zlib
}:

let dfVersion = "0.44.12"; in

stdenv.mkDerivation {
  name = "dwarf_fortress_unfuck-${dfVersion}";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dwarf_fortress_unfuck";
    rev = dfVersion;
    sha256 = "1kszkb1d1vll8p04ja41nangsaxb5lv4p3xh2jhmsmipfixw7nvz";
  };

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
  ];

  makeFlags = [
    ''CFLAGS="-fkeep-inline-functions"''
    ''CXXFLAGS="-fkeep-inline-functions"''
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libSM SDL SDL_image SDL_ttf glew openalSoft
    ncurses gtk2 libsndfile zlib libGL
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace \
      'set(CMAKE_BUILD_TYPE Release)' \
      'set(CMAKE_BUILD_TYPE Debug)'
  '';

  # Don't strip unused symbols; dfhack hooks into some of them.
  dontStrip = true;

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
