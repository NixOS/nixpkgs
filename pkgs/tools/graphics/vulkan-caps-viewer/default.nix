{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  vulkan-loader,
  wayland,
  wrapQtAppsHook,
  x11Support ? !stdenv.hostPlatform.isDarwin,
  qtx11extras,
}:

stdenv.mkDerivation rec {
  pname = "vulkan-caps-viewer";
  version = "4.03";

  src = fetchFromGitHub {
    owner = "SaschaWillems";
    repo = "VulkanCapsViewer";
    rev = version;
    hash = "sha256-LaZdQ5w7QYaD3Nxl9ML30kGws8Yyr3c0jzO3ElUvJ/I=";
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
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform wayland) [ wayland ]
  ++ lib.lists.optionals x11Support [ qtx11extras ];

  patchPhase = ''
    substituteInPlace vulkanCapsViewer.pro \
      --replace-fail '/usr/' "/" \
      --replace-fail '$(VULKAN_SDK)/lib/libvulkan.dylib' '${lib.getLib vulkan-loader}/lib/libvulkan.dylib'
  '';

  qmakeFlags = [
    "CONFIG+=release"
  ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    cp -r vulkanCapsViewer.app "$out/Applications"
  '';

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
  };
}
