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
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "slade";
  version = "unstable-2024-02-09";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "1af7d45e8d8770189b8066a99f704740a0f1278b";
    sha256 = "sha256-l6/ik/c84XLFl/PyskSA/fxESPQlG6FLeVvrNtP0spQ=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    sed -i '/-msse/d' src/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    zip
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

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/sirjuddington/SLADE.git";
  };

  meta = with lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ertes ];
  };
}
