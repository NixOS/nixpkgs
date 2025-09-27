{
  lib,
  wrapQtAppsHook,
  fetchFromGitHub,
  replaceVars,
  udev,
  stdenv,
  pkg-config,
  qtbase,
  cmake,
  zlib,
  kmod,
  libXdmcp,
  qttools,
  gnused,
  withPulseaudio ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  quazip,
  udevCheckHook,
  qtwayland,
  wayland-protocols,
}:

let
  rev = "4bf942dba5e73c2778ef797b6b8dd6b0239aca9a";
in
stdenv.mkDerivation {
  version = "source-${builtins.substring 0 7 rev}";
  pname = "ckb-next";

  src = fetchFromGitHub {
    owner = "ckb-next";
    repo = "ckb-next";
    inherit rev;
    hash = "sha256-sKgA1LZXZ64OixhbBWYUyCN4y29DRG0O0b/bAMd1I8M=";
  };

  buildInputs = [
    udev
    qtbase
    zlib
    libXdmcp
    qttools
    quazip
    qtwayland
    wayland-protocols
  ]
  ++ lib.optional withPulseaudio libpulseaudio;

  nativeBuildInputs = [
    wrapQtAppsHook
    pkg-config
    cmake
    udevCheckHook
  ];

  cmakeFlags = [
    "-DINSTALL_DIR_ANIMATIONS=libexec"
    "-DUDEV_RULE_DIRECTORY=lib/udev/rules.d"
    "-DFORCE_INIT_SYSTEM=systemd"
    "-DDISABLE_UPDATER=1"
  ];

  patches = [
    ./install-dirs.patch
    (replaceVars ./modprobe.patch {
      inherit kmod;
    })
  ];

  doInstallCheck = true;

  postInstall = ''
    substituteInPlace "$out/lib/udev/rules.d/99-ckb-next-daemon.rules" \
      --replace-fail "/usr/bin/env sed" "${lib.getExe gnused}"
  '';

  meta = with lib; {
    description = "Driver and configuration tool for Corsair keyboards and mice";
    homepage = "https://github.com/ckb-next/ckb-next";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    mainProgram = "ckb-next";
    maintainers = [ ];
  };
}
