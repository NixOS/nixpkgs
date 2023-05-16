{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, jq
, expat
<<<<<<< HEAD
, jsoncpp
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "1.3.261";
=======
  version = "1.3.249";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
   owner = "LunarG";
   repo = "VulkanTools";
   rev = "v${version}";
<<<<<<< HEAD
   hash = "sha256-Kem3nWVaMeDEsidKYMsWr9Bu0yBgjjennDB0sKBDogA=";
=======
   hash = "sha256-yQE6tjUxIZEMspxDaO9AoSjoEHQl2eDAc0E/aVQZnxQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
   fetchSubmodules = true;
 };

  nativeBuildInputs = [ cmake python3 jq which pkg-config ];

  buildInputs = [
    expat
<<<<<<< HEAD
    jsoncpp
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD

    substituteInPlace via/CMakeLists.txt --replace "jsoncpp_static" "jsoncpp"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  preFixup = ''
    for f in "$out"/etc/vulkan/explicit_layer.d/*.json "$out"/etc/vulkan/implicit_layer.d/*.json; do
      jq <"$f" >tmp.json ".layer.library_path = \"$out/lib/\" + .layer.library_path"
      mv tmp.json "$f"
    done
  '';

<<<<<<< HEAD
  patches = [
    ./gtest.patch
  ];
=======
  patches = [ ./gtest.patch ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
  };
}
