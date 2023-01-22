{ stdenv
, fetchFromGitHub
, lib
, cmake
, makeWrapper
, pkg-config
, python3
, wayland
, libX11
, libxcb
, lz4
, vulkan-loader
, xcbutilkeysyms
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "gfxreconstruct";
  version = "0.9.17";

  src = fetchFromGitHub {
    owner = "LunarG";
    repo = "gfxreconstruct";
    rev = "v${version}";
    hash = "sha256-CkZxxMoV2cqyh4ck81ODPxTYuSeQ8Q33a/4lL7UOfIY=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libX11
    libxcb
    lz4
    python3
    wayland
    xcbutilkeysyms
    zlib
    zstd
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  # The python script searches in subfolders, but we want to search in the same bin directory
  prePatch = ''
    substituteInPlace tools/gfxrecon/gfxrecon.py \
      --replace "scriptdir, '..', cmd" 'scriptdir'
  '';

  # Fix the path to the layer library
  postInstall = ''
    substituteInPlace $out/share/vulkan/explicit_layer.d/VkLayer_gfxreconstruct.json \
      --replace 'libVkLayer_gfxreconstruct.so' "$out/lib/libVkLayer_gfxreconstruct.so"
    wrapProgram $out/bin/gfxrecon-replay \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = with lib; {
    description = "Graphics API Capture and Replay Tools";
    homepage = "https://github.com/LunarG/gfxreconstruct/";
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi ];
  };
}
