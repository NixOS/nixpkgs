{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  linuxConsoleTools,
  nix-update-script,
}:

let
  moduleDir = "lib/modules/${kernel.modDirVersion}/kernel/drivers/hid";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hid-fanatecff";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "gotzl";
    repo = "hid-fanatecff";
    tag = finalAttrs.version;
    hash = "sha256-M2jm8pyxHRiswV4iJEawo57GkJ2XOclIo3NxEFgK+q0=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  patchPhase = ''
    mkdir -p $out/{lib/udev/rules.d,${moduleDir}}

    sed -i '/depmod/d' Makefile
    substituteInPlace Makefile \
      --replace-fail '/etc/udev/rules.d' "$out/lib/udev/rules.d"

    substituteInPlace fanatec.rules \
      --replace-fail '/usr/bin/evdev-joystick' '${linuxConsoleTools}/bin/evdev-joystick' \
      --replace-fail '/bin/sh' '${stdenv.shell}'
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
