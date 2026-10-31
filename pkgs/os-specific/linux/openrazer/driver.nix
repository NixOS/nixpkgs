{
  coreutils,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  stdenv,
  lib,
  udevCheckHook,
  util-linux,
}:

let
  common = import ../../../development/python-modules/openrazer/common.nix {
    inherit lib fetchFromGitHub;
  };
in
stdenv.mkDerivation (
  common
  // {
    pname = "openrazer";
    version = "${common.version}-${kernel.version}";

    nativeBuildInputs = [ udevCheckHook ] ++ kernel.moduleBuildDependencies;

    makeFlags = kernelModuleMakeFlags ++ [
      "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "INSTALL_MOD_PATH=${placeholder "out"}"
      "INSTALL_MOD_DIR=kernel/drivers/hid"
      "INSTALL_MOD_STRIP=1"
      "DEPMOD=true"
    ];

    doInstallCheck = true;

    installTargets = [ "modules_install" ];

    installFlags = [
      "-C"
      "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "M=$(PWD)/driver"
    ];

    postInstall = ''
      RAZER_MOUNT_OUT="$out/bin/razer_mount"
      RAZER_RULES_OUT="$out/etc/udev/rules.d/99-razer.rules"
      install -m 644 -v -D install_files/udev/99-razer.rules $RAZER_RULES_OUT
      install -m 755 -v -D install_files/udev/razer_mount $RAZER_MOUNT_OUT
      substituteInPlace $RAZER_RULES_OUT \
        --replace razer_mount $RAZER_MOUNT_OUT \
        --replace plugdev openrazer
      substituteInPlace $RAZER_MOUNT_OUT \
        --replace /usr/bin/logger ${util-linux}/bin/logger \
        --replace chgrp ${coreutils}/bin/chgrp \
        --replace "PATH='/sbin:/bin:/usr/sbin:/usr/bin'" "" \
        --replace plugdev openrazer
    '';

    enableParallelBuilding = true;

    meta = common.meta // {
      description = "Entirely open source Linux driver that allows you to manage your Razer peripherals on GNU/Linux";
      mainProgram = "razer_mount";
      broken = kernel.kernelOlder "4.19";
    };
  }
)
