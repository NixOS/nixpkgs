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
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.9.18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "LunarG";
    repo = "gfxreconstruct";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-dOmkNKURYgphbDHOmzcWf9PsIKMkPyN7ve579BE7fR0=";
=======
    hash = "sha256-9MDmeHid/faHeBjBfPgpRMjMMXZeHKP0VZZJtEQgBhs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    platforms = platforms.linux;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
