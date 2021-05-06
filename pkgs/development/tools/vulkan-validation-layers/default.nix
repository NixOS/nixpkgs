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
  localSpirvHeaders = spirv-headers.overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "SPIRV-Headers";
      rev = "75b30a659c8a4979104986652c54cc421fc51129";
      sha256 = "1yzdp3m50zxabkg93j1lmazs45wjp20szvxiv8ifgcdjxmyzi5ji";
    };
  });
  localGlslang = (glslang.override {
    argSpirv-tools = spirv-tools.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Tools";
        rev = "c79edd260c2b503f0eca57310057b4a100999cc5";
        sha256 = "01qq5g2a8c5ljn1j6yqh3v90kbhavibh45dcnasixvpf5q7k2ary";
      };
    });
    argSpirv-headers = localSpirvHeaders;
  }).overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "glslang";
      rev = "e56beaee736863ce48455955158f1839e6e4c1a1";
      sha256 = "062v3zq88dvgpy3xlb86lj4skk9472jh7hv835d8gs8zbyy0s3aw";
    };
  });
  robin-hood-hashing = fetchFromGitHub {
    owner = "martinus";
    repo = "robin-hood-hashing";
    rev = "eee46f9985c3c65a05b35660c6866f8f8f1a3ba3";
    sha256 = "0h2ljqxnc1gr3p3iqk627n65c7pixpzxhd9vaybr24f90f069lmw";
  };
in
stdenv.mkDerivation rec {
  pname = "vulkan-validation-layers";
  version = "1.2.176.0";

  # If we were to use "dev" here instead of headers, the setupHook would be
  # placed in that output instead of "out".
  outputs = ["out" "headers"];
  outputInclude = "headers";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-ValidationLayers";
    rev = "sdk-${version}";
    sha256 = "1mp110a686lwl6wfplg79vwnlrvbz2pd5mjkgyg9i3jyfs65lr33";
  };

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
