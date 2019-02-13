{ stdenv, fetchFromGitHub, cmake, writeText, python3
, vulkan-headers, vulkan-loader, glslang
, pkgconfig, xlibsWrapper, libxcb, libXrandr, wayland }:

stdenv.mkDerivation rec {
  name = "vulkan-validation-layers-${version}";
  version = "1.1.85.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-ValidationLayers";
    rev = "sdk-${version}";
    sha256 = "1y5ny587h62139fxnz760hsyv1dmw29m1a9vq096sn8qafh3jzbz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake python3 vulkan-headers vulkan-loader xlibsWrapper libxcb libXrandr wayland ];
  enableParallelBuilding = true;

  cmakeFlags = [ "-DGLSLANG_INSTALL_DIR=${glslang}" ];

  # Help vulkan-loader find the validation layers
  setupHook = writeText "setup-hook" ''
    export XDG_DATA_DIRS=@out@/share:$XDG_DATA_DIRS
  '';

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  patchPhase = ''
    sed "s|\([[:space:]]*set(INSTALL_DEFINES \''${INSTALL_DEFINES} -DRELATIVE_LAYER_BINARY=\"\)\(\$<TARGET_FILE_NAME:\''${TARGET_NAME}>\")\)|\1$out/lib/\2|" -i layers/CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
