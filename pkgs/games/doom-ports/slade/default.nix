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
  sfml_2,
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
  version = "3.2.7";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = version;
    hash = "sha256-+i506uzO2q/9k7en6CKs4ui9gjszrMOYwW+V9W5Lvns=";
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
    sfml_2
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
    (lib.cmakeFeature "CL_WX_CONFIG" (lib.getExe' (lib.getDev wxGTK) "wx-config"))
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GDK_BACKEND : x11
    )
  '';

  meta = {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = lib.licenses.gpl2Only; # https://github.com/sirjuddington/SLADE/issues/1754
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ abbradar ];
  };
}
