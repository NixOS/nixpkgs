{ lib
, callPackage
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, glslang
, libffi
, libX11
, libXau
, libxcb
, libXdmcp
, libXrandr
, spirv-headers
, spirv-tools
, vulkan-headers
, wayland
}:

let
  robin-hood-hashing = callPackage ./robin-hood-hashing.nix {};
in
stdenv.mkDerivation rec {
  pname = "vulkan-validation-layers";
  version = "1.3.224.0";

  # If we were to use "dev" here instead of headers, the setupHook would be
  # placed in that output instead of "out".
  outputs = ["out" "headers"];
  outputInclude = "headers";

  src = (assert (lib.all (pkg: pkg.version == version) [vulkan-headers glslang spirv-tools spirv-headers]);
    fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "Vulkan-ValidationLayers";
      rev = "sdk-${version}";
      hash = "sha256-MmAxUuV9CVJ6LHUb6ePEiE37meDB1TqPAwLsPdHQ1u8=";
    });

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  postPatch = ''
    sed "s|\([[:space:]]*set(INSTALL_DEFINES \''${INSTALL_DEFINES} -DRELATIVE_LAYER_BINARY=\"\)\(\$<TARGET_FILE_NAME:\''${TARGET_NAME}>\")\)|\1$out/lib/\2|" -i layers/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libX11
    libXau
    libXdmcp
    libXrandr
    libffi
    libxcb
    spirv-tools
    vulkan-headers
    wayland
  ];

  cmakeFlags = [
    "-DGLSLANG_INSTALL_DIR=${glslang}"
    "-DSPIRV_HEADERS_INSTALL_DIR=${spirv-headers}"
    "-DROBIN_HOOD_HASHING_INSTALL_DIR=${robin-hood-hashing}"
    "-DBUILD_LAYER_SUPPORT_FILES=ON"
    "-DPKG_CONFIG_EXECUTABLE=${pkg-config}/bin/pkg-config"
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
