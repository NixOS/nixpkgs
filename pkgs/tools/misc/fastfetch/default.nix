{ cmake
, lib
, pkg-config
, stdenv
, fetchFromGitHub
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
, chafa
, darwin
, dbus
, dconf
, egl-wayland
, glibc
, gsettings-desktop-schemas
, imagemagick
, libglvnd
, libnma
, libpulseaudio
, mesa
, ocl-icd
, opencl-headers
, pciutils
, rpm
, sqlite
, util-linux
, vulkan-headers
, vulkan-loader
, wayland
, xorg
, xfce
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    rev = "${finalAttrs.version}";
    sha256 = "l9fIm7+dBsOqGoFUYtpYESAjDy3496rDTUDQjbNU4U0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    imagemagick
    chafa
    sqlite
  ]
  ++ lib.optionals stdenv.isLinux [
    dbus
    dconf
    egl-wayland
    glibc
    gsettings-desktop-schemas
    libglvnd
    libnma
    libpulseaudio
    mesa
    ocl-icd
    opencl-headers
    pciutils
    rpm
    util-linux
    vulkan-headers
    vulkan-loader
    wayland
    xfce.xfconf
    zlib
    (with xorg; [ libxcb libXrandr ])
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
    darwin.moltenvk
  ];

  #
  NIX_CFLAGS_COMPILE = [
    "-Wno-macro-redefined"
    "-Wno-implicit-int-float-conversion"
  ];

  patches = [ ./no-install.patch ];

  cmakeFlags = [ "--no-warn-unused-cli" ];

  meta = {
    description = "Fastfetch is a neofetch-like tool for fetching system information and displaying them in a pretty way. It is written mainly in C, with performance and customizability in mind";
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ khaneliman ];
    license = lib.licenses.mit;
  };
})
