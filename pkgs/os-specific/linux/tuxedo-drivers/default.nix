{
  lib,
  stdenv,
  fetchFromGitLab,
  kernel,
  kernelModuleMakeFlags,
  kmod,
  pahole,
  gitUpdater,
  udevCheckHook,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxedo-drivers-${kernel.version}";
  version = "4.18.0";

  src = fetchFromGitLab {
    group = "tuxedocomputers";
    owner = "development/packages";
    repo = "tuxedo-drivers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9XtogovzAWaMkJI5CxszY5qO3q6NOACZ7pnejyobJlY=";
  };

  patches = [ ./no-cp-usr.patch ];

  postInstall = ''
    echo "Running postInstallhook"
    substituteInPlace usr/lib/udev/rules.d/* \
      --replace-quiet "/bin/bash" "${lib.getExe bash}" \
      --replace-quiet "/bin/sh" "${lib.getExe bash}"
    install -Dm 0644 -t $out/etc/udev/rules.d usr/lib/udev/rules.d/*
  '';

  buildInputs = [ pahole ];
  nativeBuildInputs = [
    kmod
    udevCheckHook
  ]
  ++ kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  doInstallCheck = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    broken = stdenv.hostPlatform.isAarch64 || (lib.versionOlder kernel.version "5.5");
    description = "Keyboard and hardware I/O driver for TUXEDO Computers laptops";
    homepage = "https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers";
    license = lib.licenses.gpl2Plus;
    longDescription = ''
      Drivers for several platform devices for TUXEDO notebooks:
      - Driver for Fn-keys
      - SysFS control of brightness/color/mode for most TUXEDO keyboards
      - Hardware I/O driver for TUXEDO Control Center

      Can be used with the "hardware.tuxedo-drivers" NixOS module.
    '';
    maintainers = with lib.maintainers; [
      aprl
      blanky0230
      keksgesicht
      xaverdh
      XBagon
      wetisobe
    ];
    platforms = lib.platforms.linux;
  };
})
