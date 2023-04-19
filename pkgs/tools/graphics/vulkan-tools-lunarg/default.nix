{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, jq
, expat
, libX11
, libXdmcp
, libXrandr
, libffi
, libxcb
, pkg-config
, wayland
, which
, xcbutilkeysyms
, xcbutilwm
, vulkan-headers
, vulkan-loader
, symlinkJoin
, vulkan-validation-layers
, writeText
}:

stdenv.mkDerivation rec {
  pname = "vulkan-tools-lunarg";
  # The version must match that in vulkan-headers
  version = "1.3.243.0";

  src = fetchFromGitHub {
   owner = "LunarG";
   repo = "VulkanTools";
   rev = "sdk-${version}";
   hash = "sha256-mvBP6wD1Z0VNLZ0mC4bA3i2IaBDtDr7K6XjHz4S3UA4=";
   fetchSubmodules = true;
 };

  nativeBuildInputs = [ cmake python3 jq which pkg-config ];

  buildInputs = [
    expat
    libX11
    libXdmcp
    libXrandr
    libffi
    libxcb
    wayland
    xcbutilkeysyms
    xcbutilwm
  ];

  cmakeFlags = [
    "-DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}"
    "-DVULKAN_LOADER_INSTALL_DIR=${vulkan-loader}"
    "-DVULKAN_VALIDATIONLAYERS_INSTALL_DIR=${
      symlinkJoin {
        name = "vulkan-validation-layers-merged";
        paths = [ vulkan-validation-layers.headers vulkan-validation-layers ];
      }
    }"
    # Hide dev warnings that are useless for packaging
    "-Wno-dev"
  ];

  preConfigure = ''
    # We need to run this update script which generates some source files,
    # Remove the line in it which calls 'git submodule update' though.
    # Also patch the scripts in ./scripts
    update=update_external_sources.sh
    patchShebangs $update
    patchShebangs scripts/*
    sed -i '/^git /d' $update
    ./$update
  '';

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  preFixup = ''
    for f in "$out"/etc/vulkan/explicit_layer.d/*.json "$out"/etc/vulkan/implicit_layer.d/*.json; do
      jq <"$f" >tmp.json ".layer.library_path = \"$out/lib/\" + .layer.library_path"
      mv tmp.json "$f"
    done
  '';

  patches = [ ./gtest.patch ];

  # Same as vulkan-validation-layers
  dontPatchELF = true;

  # Help vulkan-loader find the validation layers
  setupHook = writeText "setup-hook" ''
    export XDG_CONFIG_DIRS=@out@/etc''${XDG_CONFIG_DIRS:+:''${XDG_CONFIG_DIRS}}
  '';

  meta = with lib; {
    description = "LunarG Vulkan Tools and Utilities";
    longDescription = ''
      Tools to aid in Vulkan development including useful layers, trace and
      replay, and tests.
    '';
    homepage = "https://github.com/LunarG/VulkanTools";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = [ maintainers.expipiplus1 ];
    broken = (version != vulkan-headers.version);
  };
}
