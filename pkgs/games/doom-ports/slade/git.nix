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
  ftgl,
  glew,
  lua,
  mpg123,
  wrapGAppsHook3,
  unstableGitUpdater,
  libwebp,
}:

stdenv.mkDerivation {
  pname = "slade";
  version = "3.2.7-unstable-2025-08-08";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "e39df3a8809508bede6d0342932d0cb8f8a440f2";
    hash = "sha256-BZllLj50LpUntpYWyUBI9K64wb7vHTwBWzW20GeJRXQ=";
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
    ftgl
    glew
    lua
    mpg123
    libwebp
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

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/sirjuddington/SLADE.git";
  };

  meta = {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = lib.licenses.gpl2Only; # https://github.com/sirjuddington/SLADE/issues/1754
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ertes ];
  };
}
