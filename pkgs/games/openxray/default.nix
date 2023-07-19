{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, glew
, freeimage
, liblockfile
, openal
, libtheora
, SDL2
, lzo
, libjpeg
, libogg
, pcre
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openxray";
  version = "1747-january-2023-rc3";

  src = fetchFromGitHub {
    owner = "OpenXRay";
    repo = "xray-16";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-ip9CruOWk5T/dBDMcn9aOHbYaaZ+7VJw9U5GayiE7AE=";
  };

  patches = [
    # Fix OpenGL shader lookup & linking
    # Remove when in a tag
    (fetchpatch {
      name = "0001-openxray-Fix-resource-linking-again.patch";
      url = "https://github.com/OpenXRay/xray-16/commit/88d2302b490ff62344c5ab4f8ba77260402cf4f4.patch";
      hash = "sha256-JvOwnqTThYB41ndpGrW1jVUp7rcysCTHNCEyq1fTlrY=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    glew
    freeimage
    liblockfile
    openal
    libtheora
    SDL2
    lzo
    libjpeg
    libogg
    pcre
  ];

  # Crashes can happen, we'd like them to be reasonably debuggable
  cmakeBuildType = "RelWithDebInfo";
  dontStrip = true;

  postInstall = ''
    # needed because of SDL_LoadObject library loading code
    wrapProgram $out/bin/xr_3da \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = with lib; {
    mainProgram = "xr_3da";
    description = "Improved version of the X-Ray Engine, the game engine used in the world-famous S.T.A.L.K.E.R. game series by GSC Game World";
    homepage = "https://github.com/OpenXRay/xray-16/";
    license = licenses.unfree // {
      url = "https://github.com/OpenXRay/xray-16/blob/${version}/License.txt";
    };
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
  };
})
