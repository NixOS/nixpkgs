{ lib
, stdenv
, fetchFromGitHub
, qmake
, vulkan-loader
, wrapQtAppsHook
, withX11 ? true
, qtx11extras
}:

stdenv.mkDerivation rec {
  pname = "vulkan-caps-viewer";
  version = "3.27";

  src = fetchFromGitHub {
    owner = "SaschaWillems";
    repo = "VulkanCapsViewer";
    rev = version;
    hash = "sha256-B/FBX63JnBdshNLVMPA0qGnm0c/RGilIahX3VjJnpkI=";
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
  ] ++ lib.lists.optionals withX11 [ qtx11extras ];

  patchPhase = ''
    substituteInPlace vulkanCapsViewer.pro \
      --replace '/usr/' "/"
  '';

  qmakeFlags = [
    "DEFINES+=wayland"
    "CONFIG+=release"
  ]  ++ lib.lists.optionals withX11 [ "DEFINES+=X11" ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with lib; {
    mainProgram = "vulkanCapsViewer";
    description = "Vulkan hardware capability viewer";
    longDescription = ''
      Client application to display hardware implementation details for GPUs supporting the Vulkan API by Khronos.
      The hardware reports can be submitted to a public online database that allows comparing different devices, browsing available features, extensions, formats, etc.
    '';
    homepage    = "https://vulkan.gpuinfo.org/";
    platforms   = platforms.unix;
    license     = licenses.gpl2Only;
    maintainers = with maintainers; [ pedrohlc ];
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}
