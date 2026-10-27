{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bashNonInteractive,
  linuxConsoleTools,
  nix-update-script,
}:

let
  moduleDir = "lib/modules/${kernel.modDirVersion}/kernel/drivers/hid";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hid-fanatecff";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "gotzl";
    repo = "hid-fanatecff";
    tag = finalAttrs.version;
    hash = "sha256-lJ+Pn1OLgZK+T1dsV1mwzAwJJgsouFFwDH7bFUD1SGI=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  postInstall = ''
    install -Dm644 fanatec.rules \
      "$out/lib/udev/rules.d/99-fanatec.rules"
  '';

  postPatch = ''
    substituteInPlace fanatec.rules \
      --replace-fail '/usr/bin/evdev-joystick' '${lib.getExe' linuxConsoleTools "evdev-joystick"}' \
      --replace-fail '/bin/sh' '${lib.getExe bashNonInteractive}'
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "KVERSION=${kernel.modDirVersion}"
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=kernel/drivers/hid"
  ];

  installTargets = [ "modules_install" ];

  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];

  passthru.updateScript = nix-update-script { };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Linux module driver for Fanatec driving wheels";
    homepage = "https://github.com/gotzl/hid-fanatecff";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ rake5k ];
    platforms = lib.platforms.linux;
    mainProgram = "hid-fanatecff";
    broken = lib.versionOlder kernel.version "6.1";
  };
})
