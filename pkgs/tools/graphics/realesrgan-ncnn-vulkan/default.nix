{ lib
, stdenv
, fetchzip
, fetchFromGitHub
, cmake
, spirv-headers
, vulkan-headers
, vulkan-loader
, glslang
, libgcc
, libwebp
, ncnn
}:

stdenv.mkDerivation rec {
  pname = "Real-ESRGAN-ncnn-vulkan";
  version = "0.1.3.2";

  src = fetchFromGitHub {
    owner = "xinntao";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eLAIlOl1sUxijeVPFG+NscZGxDdtrQqVkMuxhegESHk=";
  };
  sourceRoot = "source/src";

  models = fetchzip {
    # Choose the newst release from https://github.com/xinntao/Real-ESRGAN/releases to update
    url = "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.3.0/realesrgan-ncnn-vulkan-20211212-ubuntu.zip";
    stripRoot = false;
    sha256 = "sha256-17k6fewVEXxx7hi+vPXjHAOq4IIUHLh7WC80CwTeFKI=";
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
  buildInputs = [ vulkan-headers vulkan-loader glslang libgcc libwebp ncnn ];

  postPatch = ''
    substituteInPlace main.cpp --replace REPLACE_MODELS $out/share/models
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp realesrgan-ncnn-vulkan $out/bin/
    cp -r ${models}/models $out/share
  '';

  meta = with lib; {
    description = "NCNN implementation of Real-ESRGAN. Real-ESRGAN aims at developing Practical Algorithms for General Image Restoration.";
    homepage = "https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan";
    license = licenses.mit;
    maintainers = with maintainers; [ tilcreator ];
  };
}
