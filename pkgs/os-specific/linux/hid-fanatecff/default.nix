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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "gotzl";
    repo = "hid-fanatecff";
    tag = finalAttrs.version;
    hash = "sha256-aVuTnrxw7zWMZ1U21DUKDvcYlIp7iHJHaX8ijmUd/TE=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  postPatch = ''
    mkdir -p $out/{lib/udev/rules.d,${moduleDir}}

    sed -i '/depmod/d' Makefile
    substituteInPlace Makefile \
      --replace-fail '/etc/udev/rules.d' "$out/lib/udev/rules.d"

    substituteInPlace fanatec.rules \
      --replace-fail '/usr/bin/evdev-joystick' '${lib.getExe' linuxConsoleTools "evdev-joystick"}' \
      --replace-fail '/bin/sh' '${lib.getExe bashNonInteractive}'
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "KVERSION=${kernel.modDirVersion}"
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MODULEDIR=$(out)/${moduleDir}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux module driver for Fanatec driving wheels";
    homepage = "https://github.com/gotzl/hid-fanatecff";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ rake5k ];
    platforms = lib.platforms.linux;
    mainProgram = "hid-fanatecff";
  };
})
