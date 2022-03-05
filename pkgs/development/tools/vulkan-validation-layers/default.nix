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
  robin-hood-hashing = fetchFromGitHub {
    owner = "martinus";
    repo = "robin-hood-hashing";
    rev = "3.11.3"; # pin
    sha256 = "1gm3lwjkh6h8m7lfykzd0jzhfqjmjchindkmxc008rwvxafsd1pl";
  };
in
stdenv.mkDerivation rec {
  pname = "vulkan-validation-layers";
  version = "1.2.198.0";

  # If we were to use "dev" here instead of headers, the setupHook would be
  # placed in that output instead of "out".
  outputs = ["out" "headers"];
  outputInclude = "headers";

  src = (assert (lib.all (pkg: pkg.version == version) [vulkan-headers glslang spirv-tools spirv-headers]);
    fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "Vulkan-ValidationLayers";
      rev = "sdk-${version}";
      sha256 = "sha256-/pnXT55EQZcnjOzY2vBwp+gM6l2hktZHwB9yKP8vVTU=";
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
    "-DGLSLANG_INSTALL_DIR=${glslang}"
    "-DSPIRV_HEADERS_INSTALL_DIR=${spirv-headers}"
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
