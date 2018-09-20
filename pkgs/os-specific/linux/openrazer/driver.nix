{ coreutils
, fetchFromGitHub
, kernel
, stdenv
, utillinux
}:

let
  openrazerSrc = import ./src.nix;
in
stdenv.mkDerivation rec {
  inherit (openrazerSrc) version;
  name = "openrazer-${version}-${kernel.version}";

  src = fetchFromGitHub openrazerSrc.github;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.version}/build"
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

  meta = with stdenv.lib; {
    description = "An entirely open source driver and user-space daemon that allows you to manage your Razer peripherals on GNU/Linux";
    homepage = https://openrazer.github.io/;
    license = licenses.gpl2;
    maintainers =  with maintainers; [ roelvandijk ];
    platforms = platforms.linux;
  };
}
