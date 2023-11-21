{ lib
, stdenv
, fetchFromGitHub
, chafa
, cmake
, dbus
, dconf
, ddcutil
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
, yyjson
, zlib
, Apple80211
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
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    rev = finalAttrs.version;
    hash = "sha256-JaD0R1vfHoWMhipMtTW0dlggR7RbD2evHfHrjoZJBmk=";
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
    yyjson
  ]
  ++ lib.optionals stdenv.isLinux [
    dbus
    dconf
    ddcutil
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
    Apple80211
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
    "-DENABLE_SYSTEM_YYJSON=YES"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=uninitialized"
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
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gerg-l khaneliman federicoschonborn ];
    platforms = lib.platforms.all;
    mainProgram = "fastfetch";
  };
})
