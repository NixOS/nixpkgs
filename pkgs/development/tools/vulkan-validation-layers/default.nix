{ stdenv, callPackage, fetchFromGitHub, cmake, writeText, python3
, vulkan-headers, vulkan-loader, glslang
, pkgconfig, xlibsWrapper, libxcb, libXrandr, wayland }:
stdenv.mkDerivation rec {
  name = "vulkan-validation-layers-${version}";
  version = "1.1.101.0"; # WARNING: glslang overrides in all-packages.nix must be updated to match known-good.json!

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-ValidationLayers";
    rev = "sdk-${version}";
    sha256 = "00gz72m393i3m3rh5hv9d0znzlz39cpw35ifchzb4cr11bi4mzyz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake python3 vulkan-headers vulkan-loader xlibsWrapper libxcb libXrandr wayland ];
  enableParallelBuilding = true;

  cmakeFlags = [ "-DGLSLANG_INSTALL_DIR=${glslang}" ];

  # Help vulkan-loader find the validation layers
  setupHook = writeText "setup-hook" ''
    export XDG_DATA_DIRS=@out@/share:$XDG_DATA_DIRS
  '';

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  patchPhase = ''
    sed "s|\([[:space:]]*set(INSTALL_DEFINES \''${INSTALL_DEFINES} -DRELATIVE_LAYER_BINARY=\"\)\(\$<TARGET_FILE_NAME:\''${TARGET_NAME}>\")\)|\1$out/lib/\2|" -i layers/CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
