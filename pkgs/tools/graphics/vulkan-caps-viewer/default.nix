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
  version = "3.25";

  src = fetchFromGitHub {
    owner = "SaschaWillems";
    repo = "VulkanCapsViewer";
    rev = "${version}";
    hash = "sha256-LNulsz/mhISu5AiMhEDaMF/FG117r4ZqyUZCgiI2O58=";
    # Note: this derivation strictly requires vulkan-header to be the same it was developed against.
    # To help they put in a git-submodule.
    # It works with older vulkan-loaders.
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
  };
}
