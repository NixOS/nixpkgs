{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, writeText, vulkan-headers, jq, libX11, libXrandr, libxcb, wayland }:

stdenv.mkDerivation rec {
  pname = "vulkan-extension-layer";
  version = "1.3.261";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-ExtensionLayer";
    rev = "v${version}";
    hash = "sha256-MeW7mmbjgqEvXEnAYzTNu4omC4fqq1fplIVjDpV2LcA=";
  };

  nativeBuildInputs = [ cmake pkg-config jq ];

  buildInputs = [ vulkan-headers libX11 libXrandr libxcb wayland ];

  # Help vulkan-loader find the validation layers
  setupHook = writeText "setup-hook" ''
    addToSearchPath XDG_DATA_DIRS @out@/share
  '';

  # Tests are not for gpu-less and headless environments
  cmakeFlags = [
    "-DBUILD_TESTS=false"
  ];

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  preFixup = ''
    for f in "$out"/share/vulkan/explicit_layer.d/*.json "$out"/share/vulkan/implicit_layer.d/*.json; do
      jq <"$f" >tmp.json ".layer.library_path = \"$out/lib/\" + .layer.library_path"
      mv tmp.json "$f"
    done
  '';

  meta = with lib; {
    description = "Layers providing Vulkan features when native support is unavailable";
    homepage = "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}
