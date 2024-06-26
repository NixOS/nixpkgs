{
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  vulkan-loader,
  glslang,
  libwebp,
  ncnn,
}:

stdenv.mkDerivation rec {
  pname = "Real-ESRGAN-ncnn-vulkan";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "xinntao";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F+NfkAbk8UtAKzsF42ppPF2UGjK/M6iFfBsRRBbCmcI=";
  };
  sourceRoot = "${src.name}/src";

  models = fetchzip {
    # Choose the newst release from https://github.com/xinntao/Real-ESRGAN/releases to update
    url = "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-ubuntu.zip";
    stripRoot = false;
    sha256 = "sha256-1YiPzv1eGnHrazJFRvl37+C1F2xnoEbN0UQYkxLT+JQ=";
  };

  patches = [
    ./cmakelists.patch
    ./models_path.patch
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_NCNN=1"
    "-DUSE_SYSTEM_WEBP=1"

    "-DGLSLANG_TARGET_DIR=${glslang}/lib/cmake"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    vulkan-headers
    vulkan-loader
    glslang
    libwebp
    ncnn
  ];

  postPatch = ''
    substituteInPlace main.cpp --replace REPLACE_MODELS $out/share/models
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share

    cp realesrgan-ncnn-vulkan $out/bin/
    cp -r ${models}/models $out/share
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/realesrgan-ncnn-vulkan --add-needed libvulkan.so
  '';

  meta = with lib; {
    description = "NCNN implementation of Real-ESRGAN. Real-ESRGAN aims at developing Practical Algorithms for General Image Restoration";
    homepage = "https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan";
    license = licenses.mit;
    maintainers = with maintainers; [
      tilcreator
      iynaix
    ];
    platforms = platforms.all;
    mainProgram = "realesrgan-ncnn-vulkan";
  };
}
