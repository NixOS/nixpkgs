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
      rev = "449bc986ba6f4c5e10e32828783f9daef2a77644"; # pin
      sha256 = "1249pvk4iz09caxm3kwckzwcx2hbw97cr2h8h770l6c061kb14z5";
    };
  });
  localGlslang = (glslang.override {
    argSpirv-tools = spirv-tools.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Tools";
        rev = "1fbed83c8aab8517d821fcb4164c08567951938f"; # pin
        sha256 = "0faz468bnxpvbg1np13gnbwf35s0hl9ad7r2p9wi9si5k336qjmj";
      };
    });
    argSpirv-headers = localSpirvHeaders;
  }).overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "glslang";
      rev = "2fb89a0072ae7316af1c856f22663fde4928128a"; # pin
      sha256 = "04kkmphv0a5mb5javhmkc4kab8r0n107kb7djakj5h238ni2j7q9";
    };
  });
  robin-hood-hashing = fetchFromGitHub {
    owner = "martinus";
    repo = "robin-hood-hashing";
    rev = "3.11.3"; # pin
    sha256 = "1gm3lwjkh6h8m7lfykzd0jzhfqjmjchindkmxc008rwvxafsd1pl";
  };
in
stdenv.mkDerivation rec {
  pname = "vulkan-validation-layers";
  version = "1.2.189.1";

  # If we were to use "dev" here instead of headers, the setupHook would be
  # placed in that output instead of "out".
  outputs = ["out" "headers"];
  outputInclude = "headers";

  src = (assert version == vulkan-headers.version;
    fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "Vulkan-ValidationLayers";
      rev = "sdk-${version}";
      sha256 = "0a5plvvffidgnqh5ymq315xscl08w298sn9da48b3x2rdbdqgw90";
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
