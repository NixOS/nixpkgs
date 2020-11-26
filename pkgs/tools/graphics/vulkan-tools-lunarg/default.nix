{ stdenv, cmake, expat, fetchFromGitHub, jq, lib, libXdmcp, libXrandr, libffi
, libxcb, pkgconfig, python3, symlinkJoin, vulkan-headers, vulkan-loader
, vulkan-validation-layers, wayland, writeText, xcbutilkeysyms, xcbutilwm
, xlibsWrapper }:

stdenv.mkDerivation rec {
  pname = "vulkan-tools-lunarg";
  # The version must match that in vulkan-headers
  version = "1.2.141.0";

  src = (assert version == vulkan-headers.version; fetchFromGitHub {
    owner = "LunarG";
    repo = "VulkanTools";
    rev = "sdk-${version}";
    sha256 = "1zsgc1hdmivdahzrarx7a5byhgnmm5ahz366l92fmdb8pffgq42g";
    fetchSubmodules = true;
  });

  nativeBuildInputs = [ cmake pkgconfig python3 jq ];

  buildInputs = [
    expat
    libXdmcp
    libXrandr
    libffi
    libxcb
    wayland
    xcbutilkeysyms
    xcbutilwm
    xlibsWrapper
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

  enableParallelBuilding = true;

  # Same as vulkan-validation-layers
  libraryPath = lib.strings.makeLibraryPath [ vulkan-loader ];
  dontPatchELF = true;

  # Help vulkan-loader find the validation layers
  setupHook = writeText "setup-hook" ''
    export XDG_CONFIG_DIRS=@out@/etc''${XDG_CONFIG_DIRS:+:''${XDG_CONFIG_DIRS}}
  '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan Tools and Utilities";
    longDescription = ''
      Tools to aid in Vulkan development including useful layers, trace and
      replay, and tests.
    '';
    homepage = "https://github.com/LunarG/VulkanTools";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = [ maintainers.expipiplus1 ];
  };
}
