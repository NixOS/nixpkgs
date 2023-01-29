{ lib
, stdenv
, fetchFromGitHub
, cmake
, vulkan-headers
, vulkan-loader
, glslang
, libgcc
, libwebp
, ncnn
}:

stdenv.mkDerivation rec {
  pname = "waifu2x-ncnn-vulkan";
  version = "20220419";

  src = fetchFromGitHub {
    owner = "nihui";
    repo = pname;
    rev = version;
    sha256 = "sha256-cyPqbVEbASZdbUTHnlC8zDmDMiziwbEL9WDcCdN4GFo=";
  };
  sourceRoot = "source/src";

  patches = [
    # Fixes missing target SPIRV-Tools-opt
    ./cmakelists.patch
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_NCNN=1"
    "-DUSE_SYSTEM_WEBP=1"
    "-DGLSLANG_TARGET_DIR=${glslang}/lib/cmake"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ vulkan-headers vulkan-loader glslang libwebp ncnn ]
    ++ lib.optional (!stdenv.isDarwin) libgcc;

  installPhase = ''
    runHook preInstall
    # The models are expected to be next to the executable, so symlink the binary as to not pollute `$out/bin`.
    mkdir -p $out/bin $out/share $out/opt
    install -Dm755 waifu2x-ncnn-vulkan $out/opt
    ln -s $out/opt/waifu2x-ncnn-vulkan $out/bin
    cp -r ${src}/models $out/share
    ln -s $out/share/models/* $out/opt
    runHook postInstall
  '';

  meta = with lib; {
    description = "NCNN implementation of waifu2x converter";
    homepage = "https://github.com/nihui/waifu2x-ncnn-vulkan";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
