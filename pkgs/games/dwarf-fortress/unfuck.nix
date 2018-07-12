{ stdenv, lib, fetchFromGitHub, cmake
, libGL, libSM, SDL, SDL_image, SDL_ttf, glew, openalSoft
, ncurses, glib, gtk2, libsndfile, zlib
, dfVersion
}:

with lib;

let
  unfuck-releases = builtins.fromJSON (builtins.readFile ./unfuck.json);

  release = if hasAttr dfVersion unfuck-releases
            then getAttr dfVersion unfuck-releases
            else throw "[unfuck] Unknown Dwarf Fortress version: ${dfVersion}";
in

stdenv.mkDerivation {
  name = "dwarf_fortress_unfuck-${release.unfuckRelease}";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dwarf_fortress_unfuck";
    rev = release.unfuckRelease;
    sha256 = release.sha256;
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
    maintainers = with maintainers; [ abbradar numinit ];
  };
}
