{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
, yyjson
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
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    rev = finalAttrs.version;
    hash = "sha256-mXbkzPlX1OsK+ahUSJWktV5D7Mo2zkhXgXP54QjbIR4=";
  };

  patches = [
    # Don't fetch yyjson.
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-misc/fastfetch/files/fastfetch-2.0.0-dont-fetch-yyjson.patch";
      hash = "sha256-mOykwXSuad8BrUBmjX39EmQb0/hnKezgmWe8cpAybsw=";
    })
  ];

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
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gerg-l khaneliman ];
    platforms = lib.platforms.all;
    mainProgram = "fastfetch";
  };
})
