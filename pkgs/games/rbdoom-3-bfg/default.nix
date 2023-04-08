{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, directx-shader-compiler
, libGLU
, libpng
, libjpeg_turbo
, openal
, rapidjson
, SDL2
, vulkan-headers
, vulkan-loader
, zlib
}:

stdenv.mkDerivation rec {
  pname = "rbdoom-3-bfg";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "RobertBeckebans";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-r/dvTirgFXdBJ+Gjl6zpHoGCTPoo0tRmOCV9oCdnltI=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "remove-jpeg_internals-define.patch";
      url = "https://github.com/RobertBeckebans/RBDOOM-3-BFG/commit/de6ab9d31ffcd6eba26df69f8c77da38a0ab4722.diff";
      hash = "sha256-3XbWmQtY/8a90IqDtN5TNT5EOa+i5mFOH+H9tuZqTmU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    directx-shader-compiler
  ];

  buildInputs = [
    libGLU
    libpng
    libjpeg_turbo
    openal
    rapidjson
    SDL2
    vulkan-headers
    vulkan-loader
    zlib
  ];

  cmakeDir = "../neo";
  cmakeFlags = [
    "-DFFMPEG=OFF"
    "-DBINKDEC=ON"
    "-DUSE_SYSTEM_LIBGLEW=ON"
    "-DUSE_SYSTEM_LIBPNG=ON"
    "-DUSE_SYSTEM_LIBJPEG=ON"
    "-DUSE_SYSTEM_RAPIDJSON=ON"
    "-DUSE_SYSTEM_ZLIB=ON"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install RBDoom3BFG $out/bin/RBDoom3BFG

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/RobertBeckebans/RBDOOM-3-BFG";
    description = "Doom 3 BFG Edition with modern engine features";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Zaechus ];
    platforms = platforms.unix;
  };
}
