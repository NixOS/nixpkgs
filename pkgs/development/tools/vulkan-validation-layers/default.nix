{ lib
, callPackage
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, jq
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
, vulkan-utility-libraries
, wayland
}:

let
  robin-hood-hashing = callPackage ./robin-hood-hashing.nix {};
in
stdenv.mkDerivation rec {
  pname = "vulkan-validation-layers";
  version = "1.3.290.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-ValidationLayers";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-FMzQpc7mwZGib544w0Dx6LeGi64cercm5oUW45raasc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    jq
  ];

  buildInputs = [
    glslang
    libX11
    libXau
    libXdmcp
    libXrandr
    libffi
    libxcb
    robin-hood-hashing
    spirv-headers
    spirv-tools
    vulkan-headers
    vulkan-utility-libraries
    wayland
  ];

  cmakeFlags = [
    "-DBUILD_LAYER_SUPPORT_FILES=ON"
    # Hide dev warnings that are useless for packaging
    "-Wno-dev"
  ];

  # Tests require access to vulkan-compatible GPU, which isn't
  # available in Nix sandbox. Fails with VK_ERROR_INCOMPATIBLE_DRIVER.
  doCheck = false;

  separateDebugInfo = true;

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  preFixup = ''
    for f in "$out"/share/vulkan/explicit_layer.d/*.json "$out"/share/vulkan/implicit_layer.d/*.json; do
      jq <"$f" >tmp.json ".layer.library_path = \"$out/lib/\" + .layer.library_path"
      mv tmp.json "$f"
    done
  '';

  meta = with lib; {
    description = "Official Khronos Vulkan validation layers";
    homepage    = "https://github.com/KhronosGroup/Vulkan-ValidationLayers";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
