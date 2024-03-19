{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapGAppsHook

, curl
, freetype
, glew
, gtk3
, libGL
, libjpeg
, libpng
, SDL2
, SDL2_gfx
, SDL2_image
, SDL2_mixer
, SDL2_ttf
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "principia";
  version = "2024.02.29";

  src = fetchFromGitHub {
    owner = "Bithack";
    repo = "principia";
    rev = finalAttrs.version;
    hash = "sha256-L37H261IGCcH2K7RhX8iTdHRkle83vKhgpyssRmSKN0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    curl
    freetype
    glew
    gtk3
    libGL
    libjpeg
    libpng
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  cmakeFlags = [
    # Remove when https://github.com/NixOS/nixpkgs/issues/144170 is fixed
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
  ];

  meta = with lib; {
    changelog = "https://principia-web.se/wiki/Changelog#${lib.replaceStrings ["."] ["-"] finalAttrs.version}";
    description = "Physics-based sandbox game";
    mainProgram = "principia";
    homepage = "https://principia-web.se/";
    downloadPage = "https://principia-web.se/download";
    license = licenses.bsd3;
    maintainers = [ maintainers.fgaz ];
    platforms = platforms.linux;
  };
})
