{ stdenv, fetchFromGitHub, cmake, writeText, vulkan-headers, jq }:

stdenv.mkDerivation rec {
  pname = "vulkan-extension-layer";
  version = "2020-11-20";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-ExtensionLayer";
    rev = "7474cb8e1f70e9f4a8bf382708a7f15465453af5";
    sha256 = "1lxkgcnv32wqk4hlckv13xy84g38jzgc4qxp9vsbkrgz87hkdvwj";
  };

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

  meta = with stdenv.lib; {
    description = "Layers providing Vulkan features when native support is unavailable";
    homepage = "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}
