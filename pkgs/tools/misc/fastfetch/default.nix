{ lib
, stdenv
, fetchFromGitHub
, chafa
, cmake
, dbus
, dconf
, glib
, imagemagick_light
, libglvnd
, libpulseaudio
, libxcb
, libXrandr
, makeBinaryWrapper
, networkmanager
, nix-update-script
, ocl-icd
, opencl-headers
, pciutils
, pkg-config
, rpm
, sqlite
, testers
, vulkan-loader
, wayland
, xfce
, zlib
, AppKit
, Cocoa
, CoreDisplay
, CoreVideo
, CoreWLAN
, DisplayServices
, Foundation
, IOBluetooth
, MediaRemote
, OpenCL
, moltenvk
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    rev = finalAttrs.version;
    hash = "sha256-l9fIm7+dBsOqGoFUYtpYESAjDy3496rDTUDQjbNU4U0=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    chafa
    imagemagick_light
    sqlite
  ]
  ++ lib.optionals stdenv.isLinux [
    dbus
    dconf
    glib
    libglvnd
    libpulseaudio
    libxcb
    libXrandr
    networkmanager
    ocl-icd
    opencl-headers
    pciutils
    rpm
    vulkan-loader
    wayland
    xfce.xfconf
    zlib
  ]
  ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    CoreDisplay
    CoreVideo
    CoreWLAN
    DisplayServices
    Foundation
    IOBluetooth
    MediaRemote
    OpenCL
    moltenvk
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_SYSCONFDIR=${placeholder "out"}/etc"
  ];

  postInstall = ''
    wrapProgram $out/bin/fastfetch \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    wrapProgram $out/bin/flashfetch \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "fastfetch -v | cut -d '(' -f 1";
      version = "fastfetch ${finalAttrs.version}";
    };
  };

  meta = {
    description = "Like neofetch, but much faster because written in C";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gerg-l khaneliman ];
    platforms = lib.platforms.all;
    mainProgram = "fastfetch";
  };
})
