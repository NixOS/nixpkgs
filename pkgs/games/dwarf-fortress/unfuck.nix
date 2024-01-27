{ stdenv
, lib
, fetchFromGitHub
, cmake
, libGL
, libSM
, SDL
, SDL_image
, SDL_ttf
, glew
, openalSoft
, ncurses
, glib
, gtk2
, gtk3
, libsndfile
, zlib
, dfVersion
, pkg-config
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
    "0.47.01" = {
      unfuckRelease = "0.47.01";
      sha256 = "11xvb3qh4crdf59pwfwpi73rzm3ysd1r1xp2k1jp7527jmqapk4k";
    };
    "0.47.02" = {
      unfuckRelease = "0.47.01";
      sha256 = "11xvb3qh4crdf59pwfwpi73rzm3ysd1r1xp2k1jp7527jmqapk4k";
    };
    "0.47.04" = {
      unfuckRelease = "0.47.04";
      sha256 = "1wa990xbsyiiz7abq153xmafvvk1dmgz33rp907d005kzl1z86i9";
    };
    "0.47.05" = {
      unfuckRelease = "0.47.04";
      sha256 = "1wa990xbsyiiz7abq153xmafvvk1dmgz33rp907d005kzl1z86i9";
    };
  };

  release =
    if hasAttr dfVersion unfuck-releases
    then getAttr dfVersion unfuck-releases
    else throw "[unfuck] Unknown Dwarf Fortress version: ${dfVersion}";
in

stdenv.mkDerivation {
  pname = "dwarf_fortress_unfuck";
  version = release.unfuckRelease;

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dwarf_fortress_unfuck";
    rev = release.unfuckRelease;
    sha256 = release.sha256;
  };

  postPatch = ''
    # https://github.com/svenstaro/dwarf_fortress_unfuck/pull/27
    substituteInPlace CMakeLists.txt --replace \''${GLEW_LIBRARIES} GLEW::glew
  '';

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    libSM
    SDL
    SDL_image
    SDL_ttf
    glew
    openalSoft
    ncurses
    libsndfile
    zlib
    libGL
  ]
  # switched to gtk3 in 0.47.05
  ++ (if lib.versionOlder release.unfuckRelease "0.47.05" then [
    gtk2
  ] else [
    gtk3
  ]);

  # Don't strip unused symbols; dfhack hooks into some of them.
  dontStrip = true;

  installPhase = ''
    install -D -m755 ../build/libgraphics.so $out/lib/libgraphics.so
  '';

  # Breaks dfhack because of inlining.
  hardeningDisable = [ "fortify" ];

  passthru = { inherit dfVersion; };

  meta = with lib; {
    description = "Unfucked multimedia layer for Dwarf Fortress";
    homepage = "https://github.com/svenstaro/dwarf_fortress_unfuck";
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar numinit ];
  };
}
