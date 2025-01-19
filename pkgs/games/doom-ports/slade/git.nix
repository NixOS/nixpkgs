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

stdenv.mkDerivation {
  pname = "slade";
  version = "3.2.6-unstable-2024-11-26";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "f8ca52edf98e649c6455f6cc32f7aa361e41babe";
    hash = "sha256-h43kYVLDxr1Z3vKJ+IZaDmvkerUdGJFLzJrPj0b2VUI=";
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

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/sirjuddington/SLADE.git";
  };

  meta = with lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2Only; # https://github.com/sirjuddington/SLADE/issues/1754
    platforms = platforms.linux;
    maintainers = with maintainers; [ ertes ];
  };
}
