{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  which,
  zip,
  wxGTK,
  gtk3,
  sfml,
  fluidsynth,
  curl,
  freeimage,
  ftgl,
  glew,
  lua,
  mpg123,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "slade";
  version = "3.2.5";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = version;
    sha256 = "sha256-FBpf1YApwVpWSpUfa2LOrkS1Ef34sKCIZ6ic+Pczs14=";
  };

  postPatch = ''
    substituteInPlace dist/CMakeLists.txt \
      --replace "PK3_OUTPUT" "PK3_DESTINATION"
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
    "-DBUILD_PK3=ON"
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
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
