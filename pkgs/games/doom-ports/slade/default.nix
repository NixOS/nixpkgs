{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, which
, zip
, wxGTK
, gtk3
, sfml
, fluidsynth
, curl
, freeimage
, ftgl
, glew
, lua
, mpg123
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "slade";
  version = "3.2.6";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = version;
    hash = "sha256-pcWmv1fnH18X/S8ljfHxaL1PjApo5jyM8W+WYn+/7zI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    zip
    wrapGAppsHook3
  ];

  buildInputs = [
    wxGTK
    gtk3
    sfml
    fluidsynth
    curl
    freeimage
    ftgl
    glew
    lua
    mpg123
  ];

  cmakeFlags = [
    "-DwxWidgets_LIBRARIES=${wxGTK}/lib"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GDK_BACKEND : x11
    )
  '';

  meta = with lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2Only; # https://github.com/sirjuddington/SLADE/issues/1754
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
