{ lib, stdenv, fetchFromGitHub, cmake, writeText, vulkan-headers, jq }:

stdenv.mkDerivation rec {
  pname = "vulkan-extension-layer";
  version = "1.2.182.0";

  src = (assert version == vulkan-headers.version;
    fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "Vulkan-ExtensionLayer";
      rev = "sdk-${version}";
      sha256 = "0by2kp48jbd55xk26rmlvc4wm77g1zvidx8czn1587ng2yzi7acr";
    });

  nativeBuildInputs = [ cmake jq ];

  buildInputs = [ vulkan-headers ];

  # Help vulkan-loader find the validation layers
  setupHook = writeText "setup-hook" ''
    export XDG_DATA_DIRS=@out@/share:$XDG_DATA_DIRS
  '';

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
