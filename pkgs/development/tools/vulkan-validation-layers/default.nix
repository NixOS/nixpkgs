{ lib
, stdenv
, fetchFromGitHub
, cmake
, glslang
, libX11
, libxcb
, libXrandr
, spirv-headers
, spirv-tools
, vulkan-headers
, wayland
}:

let
  # vulkan-validation-layers requires a custom glslang & robin-hood-hashing
  # version, while glslang requires custom versions for spirv-tools and spirv-headers.
  #
  # The git hashes required for all of these deps is documented upstream here:
  # https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/master/scripts/known_good.json
  # and https://github.com/KhronosGroup/glslang/blob/master/known_good.json
  localSpirvHeaders = spirv-headers.overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "SPIRV-Headers";
      rev = "dafead1765f6c1a5f9f8a76387dcb2abe4e54acd"; # pin
      sha256 = "1kj6wcx9y7r1xyg8n7ai2pzrg9ira7hbakr45wh5p4zyxh0m45n8";
    };
  });
  localGlslang = (glslang.override {
    argSpirv-tools = spirv-tools.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Tools";
        rev = "dc72924cb31cd9f3dbc3eb47e9d926cf641e3a07"; # pin
        sha256 = "0pxgbq6xapw9hgrzb3rk5cylzgg1y1bkqz5wxzwqls63pwga5912";
      };
    });
    argSpirv-headers = localSpirvHeaders;
  }).overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "glslang";
      rev = "18eef33bd7a4bf5ad8c69f99cb72022608cf6e73"; # pin
      sha256 = "0wwj7q509pkp8wj7120g1n2ddl4x2r03ljf5czd9794ji6yraidn";
    };
  });
  robin-hood-hashing = fetchFromGitHub {
    owner = "martinus";
    repo = "robin-hood-hashing";
    rev = "3.11.2"; # pin
    sha256 = "0103mnqpmka1smy0arnrbihlvi7i8xr5im0px8wn4faw4flikkcm";
  };
in
stdenv.mkDerivation rec {
  pname = "vulkan-validation-layers";
  version = "1.2.182.0";

  # If we were to use "dev" here instead of headers, the setupHook would be
  # placed in that output instead of "out".
  outputs = ["out" "headers"];
  outputInclude = "headers";

  src = (assert version == vulkan-headers.version;
    fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "Vulkan-ValidationLayers";
      rev = "sdk-${version}";
      sha256 = "1fnmb7vbm7y1x67bf1xiwdrpj9j4lkvhk9xhb6hp6x2aryvcyrnc";
    });

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  postPatch = ''
    sed "s|\([[:space:]]*set(INSTALL_DEFINES \''${INSTALL_DEFINES} -DRELATIVE_LAYER_BINARY=\"\)\(\$<TARGET_FILE_NAME:\''${TARGET_NAME}>\")\)|\1$out/lib/\2|" -i layers/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libX11
    libxcb
    libXrandr
    vulkan-headers
    wayland
  ];

  cmakeFlags = [
    "-DGLSLANG_INSTALL_DIR=${localGlslang}"
    "-DSPIRV_HEADERS_INSTALL_DIR=${localSpirvHeaders}"
    "-DROBIN_HOOD_HASHING_INSTALL_DIR=${robin-hood-hashing}"
    "-DBUILD_LAYER_SUPPORT_FILES=ON"
    # Hide dev warnings that are useless for packaging
    "-Wno-dev"
  ];

  # Tests require access to vulkan-compatible GPU, which isn't
  # available in Nix sandbox. Fails with VK_ERROR_INCOMPATIBLE_DRIVER.
  doCheck = false;

  meta = with lib; {
    description = "The official Khronos Vulkan validation layers";
    homepage    = "https://github.com/KhronosGroup/Vulkan-ValidationLayers";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
