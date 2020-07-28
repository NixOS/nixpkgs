{ stdenv, fetchFromGitHub, cmake, writeText, python3
, vulkan-headers, vulkan-loader, glslang, spirv-headers
, pkgconfig, xlibsWrapper, libxcb, libXrandr, wayland }:

stdenv.mkDerivation rec {
  pname = "vulkan-validation-layers";
  version = "1.2.141.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-ValidationLayers";
    rev = "sdk-${version}";
    sha256 = "1yfas7q122kx74nbjk3wxlyacysgncvlvq081a5dp238m88vkmbj";
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
    python3
  ];

  buildInputs = [
    glslang
    spirv-headers
    vulkan-headers
    vulkan-loader
    libxcb
    libXrandr
    wayland
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DGLSLANG_INSTALL_DIR=${glslang}"
  ];

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
    homepage    = "https://www.lunarg.com";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
