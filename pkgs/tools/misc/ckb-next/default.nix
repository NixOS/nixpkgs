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
  qtx11extras,
  libdbusmenu,
  gnused,
  withPulseaudio ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  quazip,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  version = "0.6.2";
  pname = "ckb-next";

  src = fetchFromGitHub {
    owner = "ckb-next";
    repo = "ckb-next";
    rev = "v${version}";
    hash = "sha256-lA1FpUee2SpUQwJotbYhG0QX7LT5l2PP9lJ9F3uNtdU=";
  };

  buildInputs = [
    udev
    qtbase
    zlib
    libXdmcp
    qttools
    qtx11extras
    libdbusmenu
    quazip
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
