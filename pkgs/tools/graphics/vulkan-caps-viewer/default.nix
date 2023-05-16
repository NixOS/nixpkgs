{ lib
, stdenv
, fetchFromGitHub
, qmake
, vulkan-loader
, wayland
, wrapQtAppsHook
<<<<<<< HEAD
, x11Support ? true
=======
, withX11 ? true
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, qtx11extras
}:

stdenv.mkDerivation rec {
  pname = "vulkan-caps-viewer";
<<<<<<< HEAD
  version = "3.32";
=======
  version = "3.29";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SaschaWillems";
    repo = "VulkanCapsViewer";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-SPz8AurANjNwtsPHdZ2lCaC3VEcEAKn93st/7DJ0oyU=";
=======
    hash = "sha256-c7jvlwvz85cf8lUlBPyRYvDkSlvkzSW6Jc6wlyKnHBc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # Note: this derivation strictly requires vulkan-header to be the same it was developed against.
    # To help us, they've put it in a git-submodule.
    # The result will work with any vulkan-loader version.
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    vulkan-loader
    wayland
<<<<<<< HEAD
  ] ++ lib.lists.optionals x11Support [ qtx11extras ];
=======
  ] ++ lib.lists.optionals withX11 [ qtx11extras ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  patchPhase = ''
    substituteInPlace vulkanCapsViewer.pro \
      --replace '/usr/' "/"
  '';

  qmakeFlags = [
    "CONFIG+=release"
  ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with lib; {
    mainProgram = "vulkanCapsViewer";
    description = "Vulkan hardware capability viewer";
    longDescription = ''
      Client application to display hardware implementation details for GPUs supporting the Vulkan API by Khronos.
      The hardware reports can be submitted to a public online database that allows comparing different devices, browsing available features, extensions, formats, etc.
    '';
    homepage = "https://vulkan.gpuinfo.org/";
    platforms = platforms.unix;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pedrohlc ];
    changelog = "https://github.com/SaschaWillems/VulkanCapsViewer/releases/tag/${version}";
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}
