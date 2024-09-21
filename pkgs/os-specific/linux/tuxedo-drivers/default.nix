{
  lib,
  stdenv,
  fetchFromGitLab,
  kernel,
  linuxHeaders,
  pahole,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxedo-drivers-${kernel.version}";
  version = "4.6.2";

  src = fetchFromGitLab {
    group = "tuxedocomputers";
    owner = "development/packages";
    repo = "tuxedo-drivers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HS/KGhgFW0vO2SSFYSdseQBhAZC70eAx9JvRgR6e6qs=";
  };

  buildInputs = [
    pahole
    linuxHeaders
  ];

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/modules/${kernel.modDirVersion}"

    find src/ -type f -name '*.ko' \
      -exec mv {} $out/lib/modules/${kernel.modDirVersion} \;

    runHook postInstall
  '';

  meta = {
    broken = stdenv.hostPlatform.isAarch64 || (lib.versionOlder kernel.version "5.5");
    description = "Keyboard and hardware I/O driver for TUXEDO Computers laptops";
    homepage = "https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      Drivers for several platform devices for TUXEDO notebooks:
      - Driver for Fn-keys
      - SysFS control of brightness/color/mode for most TUXEDO keyboards
      - Hardware I/O driver for TUXEDO Control Center

      Can be used with the "hardware.tuxedo-drivers" NixOS module.
    '';
    maintainers = [ lib.maintainers.blanky0230 ];
    platforms = lib.platforms.linux;
  };
})
