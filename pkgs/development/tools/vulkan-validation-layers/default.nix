{ lib, stdenv
, fetchFromGitHub
, cmake
, writeText
, python3
, spirv-headers
, spirv-tools
, vulkan-headers
, vulkan-loader
, glslang
, pkg-config
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
  localSpirvHeaders = spirv-headers.overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "SPIRV-Headers";
      rev = "f027d53ded7e230e008d37c8b47ede7cd308e19d";
      sha256 = "12gp2mqcar6jj57jw9isfr62yn72kmvdcl0zga4gvrlyfhnf582q";
    };
  });
  localGlslang = (glslang.override {
    argSpirv-tools = spirv-tools.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Tools";
        rev = "c9c1f54330d13a0bec1aa3f08d436249d8e35596";
        sha256 = "0r5whsw9x8j4199xwxv293ar2ga73pm2s7rngw732ylh6rw3bkly";
      };
    });
    argSpirv-headers = localSpirvHeaders;
  }).overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "glslang";
      rev = "dd69df7f3dac26362e10b0f38efb9e47990f7537";
      sha256 = "1iafbh524avsjg4pjiq156b62pck2rwlfl2pjnml8sjy285506rk";
    };
  });
in

stdenv.mkDerivation rec {
  pname = "vulkan-validation-layers";
  version = "1.2.162.0";

  # If we were to use "dev" here instead of headers, the setupHook would be
  # placed in that output instead of "out".
  outputs = ["out" "headers"];
  outputInclude = "headers";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-ValidationLayers";
    rev = "sdk-${version}";
    sha256 = "1mpqmxh9zm20jdar59lp4yjpqfzxn2pwds6bkvnzihfy0pymf15k";
  };

  nativeBuildInputs = [
    pkg-config
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

  cmakeFlags = [
    "-DGLSLANG_INSTALL_DIR=${localGlslang}"
    "-DSPIRV_HEADERS_INSTALL_DIR=${localSpirvHeaders}"
    "-DBUILD_LAYER_SUPPORT_FILES=ON"
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

  meta = with lib; {
    description = "The official Khronos Vulkan validation layers";
    homepage    = "https://github.com/KhronosGroup/Vulkan-ValidationLayers";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
