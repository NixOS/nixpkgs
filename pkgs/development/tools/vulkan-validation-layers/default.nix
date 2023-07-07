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
, vulkan-headers
, wayland
}:

let
  robin-hood-hashing = callPackage ./robin-hood-hashing.nix {};

  # Current VVL version requires a newer spirv-headers than the latest release tag.
  # This should hopefully not be too common and the override should be removed after
  # the next SPIRV headers release.
  # FIXME: if this ever becomes common, figure out a way to pull revisions directly
  # from upstream known-good.json
  spirv-headers' = spirv-headers.overrideAttrs(_: {
    version = "unstable-2023-04-27";

    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "SPIRV-Headers";
      rev = "7f1d2f4158704337aff1f739c8e494afc5716e7e";
      hash = "sha256-DHOYIZQqP5uWDYdb+vePpMBaQDOCB5Pcg8wPBMF8itk=";
    };

    postPatch = "";
  });
in
stdenv.mkDerivation rec {
  pname = "vulkan-validation-layers";
  version = "1.3.254";

  # If we were to use "dev" here instead of headers, the setupHook would be
  # placed in that output instead of "out".
  outputs = ["out" "headers"];
  outputInclude = "headers";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-ValidationLayers";
    rev = "v${version}";
    hash = "sha256-hh/lCXSKq8xmygVsFFOGu79DvBvBPcc1l1e5wQskK7M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    jq
  ];

  buildInputs = [
    libX11
    libXau
    libXdmcp
    libXrandr
    libffi
    libxcb
    vulkan-headers
    wayland
  ];

  cmakeFlags = [
    "-DGLSLANG_INSTALL_DIR=${glslang}"
    "-DSPIRV_HEADERS_INSTALL_DIR=${spirv-headers'}"
    "-DROBIN_HOOD_HASHING_INSTALL_DIR=${robin-hood-hashing}"
    "-DBUILD_LAYER_SUPPORT_FILES=ON"
    "-DPKG_CONFIG_EXECUTABLE=${pkg-config}/bin/pkg-config"
    # Hide dev warnings that are useless for packaging
    "-Wno-dev"
  ];

  # Tests require access to vulkan-compatible GPU, which isn't
  # available in Nix sandbox. Fails with VK_ERROR_INCOMPATIBLE_DRIVER.
  doCheck = false;

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  preFixup = ''
    for f in "$out"/share/vulkan/explicit_layer.d/*.json "$out"/share/vulkan/implicit_layer.d/*.json; do
      jq <"$f" >tmp.json ".layer.library_path = \"$out/lib/\" + .layer.library_path"
      mv tmp.json "$f"
    done
  '';

  meta = with lib; {
    description = "The official Khronos Vulkan validation layers";
    homepage    = "https://github.com/KhronosGroup/Vulkan-ValidationLayers";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
