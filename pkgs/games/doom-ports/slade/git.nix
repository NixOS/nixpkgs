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
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "slade";
  version = "3.2.6-unstable-2024-09-30";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "b225d41ea77332a4b7df114672ee8f430303b4bf";
    hash = "sha256-P327xzal1jOvG1uCQKnxl6T3pJHnfKL0Ti2vnVe1foA=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    sed -i '/-msse/d' src/CMakeLists.txt
  '';

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

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/sirjuddington/SLADE.git";
  };

  meta = with lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ertes ];
  };
}
