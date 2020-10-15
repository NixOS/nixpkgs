{ stdenv
, fetchFromGitHub
, cmake
, writeText
, python3
, spirv-headers
, spirv-tools
, vulkan-headers
, vulkan-loader
, glslang
, pkgconfig
, xlibsWrapper
, libxcb
, libXrandr
, wayland
}:
# vulkan-validation-layers requires a custom glslang version, while glslang requires
# custom versions for spirv-tools and spirv-headers. The git hashes required for all
# of these deps is documented upstream here:
# https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/master/scripts/known_good.json

let
  localGlslang = (glslang.override {
    argSpirv-tools = spirv-tools.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Tools";
        rev = "e128ab0d624ce7beb08eb9656bb260c597a46d0a";
        sha256 = "0jj8zrl3dh9fq71jc8msx3f3ifb2vjcb37nl0w4sa8sdhfff74pv";
      };
    });
    argSpirv-headers = spirv-headers.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Headers";
        rev = "ac638f1815425403e946d0ab78bac71d2bdbf3be";
        sha256 = "1lkhs7pxcrfkmiizcxl0w5ajx6swwjv7w3iq586ipgh571fc75gx";
      };
    });
  }).overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "glslang";
      rev = "e00d27c6d65b7d3e72506a311d7f053da4051295";
      sha256 = "00lzvzk613gpm1vsdxffmx52z3c52ijwvzk4sfhh95p71kdydhgv";
    };
  });
in

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
    localGlslang
    localGlslang.spirv-headers
    vulkan-headers
    vulkan-loader
    libxcb
    libXrandr
    wayland
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DGLSLANG_INSTALL_DIR=${localGlslang}"
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
