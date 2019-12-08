{ coreutils
, fetchFromGitHub
, kernel
, stdenv
, utillinux
}:

let
  common = import ../../../development/python-modules/openrazer/common.nix { inherit stdenv fetchFromGitHub; };
in
stdenv.mkDerivation (common // {
  name = "openrazer-${common.version}-${kernel.version}";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    binDir="$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid"
    mkdir -p "$binDir"
    cp -v driver/*.ko "$binDir"
    RAZER_MOUNT_OUT="$out/bin/razer_mount"
    RAZER_RULES_OUT="$out/etc/udev/rules.d/99-razer.rules"
    install -m 644 -v -D install_files/udev/99-razer.rules $RAZER_RULES_OUT
    install -m 755 -v -D install_files/udev/razer_mount $RAZER_MOUNT_OUT
    substituteInPlace $RAZER_RULES_OUT \
      --replace razer_mount $RAZER_MOUNT_OUT
    substituteInPlace $RAZER_MOUNT_OUT \
      --replace /usr/bin/logger ${utillinux}/bin/logger \
      --replace chgrp ${coreutils}/bin/chgrp \
      --replace "PATH='/sbin:/bin:/usr/sbin:/usr/bin'" ""
  '';

  meta = common.meta // {
    description = "An entirely open source Linux driver that allows you to manage your Razer peripherals on GNU/Linux";
  };
})
