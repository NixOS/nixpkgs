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
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "RobertBeckebans";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bjjeTdbQDWTibSrIWhCnr6F0Ef17efLgWGQAAwezjUw=";
    fetchSubmodules = true;
  };

  patches = fetchpatch {
    name = "replace-HLSL-ternary-operators.patch";
    url = "https://github.com/RobertBeckebans/RBDOOM-3-BFG/commit/feffa4a4dd9a2a5f3c608f720cde41bea37797d3.patch";
    hash = "sha256-aR1eoWZL3+ps7P7yFXFvGsMFxpUSBDiyBsja/ISin4I=";
  };

  postPatch = ''
    substituteInPlace neo/extern/nvrhi/tools/shaderCompiler/CMakeLists.txt \
      --replace "AppleClang" "Clang"
  '';

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

  # it caused build failure
  hardeningDisable = [ "fortify3" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install RBDoom3BFG $out/bin/RBDoom3BFG

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/RobertBeckebans/RBDOOM-3-BFG";
    description = "Doom 3 BFG Edition with modern engine features";
    mainProgram = "RBDoom3BFG";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Zaechus ];
    platforms = platforms.unix;
  };
}
