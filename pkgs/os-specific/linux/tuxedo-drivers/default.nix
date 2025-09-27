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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxedo-drivers-${kernel.version}";
  version = "4.15.4";

  src = fetchFromGitLab {
    group = "tuxedocomputers";
    owner = "development/packages";
    repo = "tuxedo-drivers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WJeju+czbCw03ALW7yzGAFENCEAvDdKqHvedchd7NVY=";
  };

  patches = [ ./no-cp-etc-usr.patch ];

  postInstall = ''
    echo "Running postInstallhook"
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
    ];
    platforms = lib.platforms.linux;
  };
})
