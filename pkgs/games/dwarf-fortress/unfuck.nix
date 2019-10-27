{ stdenv, lib, fetchFromGitHub, cmake
, libGL, libSM, SDL, SDL_image, SDL_ttf, glew, openalSoft
, ncurses, glib, gtk2, libsndfile, zlib
, dfVersion
}:

with lib;

let
  unfuck-releases = {
    "0.43.05" = {
      unfuckRelease = "0.43.05";
      sha256 = "173dyrbxlzqvjf1j3n7vpns4gfjkpyvk9z16430xnmd5m6nda8p2";
    };
    "0.44.05" = {
      unfuckRelease = "0.44.05";
      sha256 = "00yj4l4gazxg4i6fj9rwri6vm17i6bviy2mpkx0z5c0mvsr7s14b";
    };
    "0.44.09" = {
      unfuckRelease = "0.44.09";
      sha256 = "138p0v8z2x47f0fk9k6g75ikw5wb3vxldwv5ggbkf4hhvlw6lvzm";
    };
    "0.44.10" = {
      unfuckRelease = "0.44.10";
      sha256 = "0vb19qx2ibc79j4bgbk9lskb883qfb0815zw1dfz9k7rqwal8mzj";
    };
    "0.44.11" = {
      unfuckRelease = "0.44.11.1";
      sha256 = "1kszkb1d1vll8p04ja41nangsaxb5lv4p3xh2jhmsmipfixw7nvz";
    };
    "0.44.12" = {
      unfuckRelease = "0.44.12";
      sha256 = "1kszkb1d1vll8p04ja41nangsaxb5lv4p3xh2jhmsmipfixw7nvz";
    };
  };

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
