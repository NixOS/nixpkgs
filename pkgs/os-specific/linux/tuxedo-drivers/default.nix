{
  lib,
  stdenv,
  fetchFromGitLab,
  kernel,
  kmod,
  pahole,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxedo-drivers-${kernel.version}";
  version = "4.11.3";

  src = fetchFromGitLab {
    group = "tuxedocomputers";
    owner = "development/packages";
    repo = "tuxedo-drivers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ylHREVzQY9U/YHmVYQ4qO+A8tUcWXOTspS4g9qn314o=";
  };

  buildInputs = [ pahole ];
  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  # kernel makeFlags contain O=$$(buildRoot), that upstream passes through to make and causes build failure, so we filter it out here
  makeFlags =
    (lib.filter (flag: lib.head (lib.strings.splitString "=" flag) != "O") kernel.makeFlags)
    ++ [
      "KERNELRELEASE=${kernel.modDirVersion}"
      "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "INSTALL_MOD_PATH=${placeholder "out"}"
    ];

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
    maintainers = with lib.maintainers; [
      aprl
      blanky0230
      keksgesicht
      xaverdh
    ];
    platforms = lib.platforms.linux;
  };
})
