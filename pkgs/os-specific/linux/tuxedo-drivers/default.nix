{ lib, stdenv, fetchFromGitLab, kernel, kmod, pahole }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxedo-drivers-${kernel.version}";
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "tuxedocomputers/development/packages";
    repo = "tuxedo-drivers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IZ1K7n4OrhI52u7EH0ljVkKwc/uf53sMd9qpTLjvzls=";
  };

  buildInputs = [ pahole ];
  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = {
    broken = stdenv.isAarch64 || (lib.versionOlder kernel.version "5.5");
    description = "Drivers for several platform devices for TUXEDO notebooks";
    homepage = "https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      This driver provides support for Fn keys, brightness/color/mode for most TUXEDO
      keyboards (except white backlight-only models) and a hardware I/O driver for
      the TUXEDO Control center.
    '';
    maintainers = [ lib.maintainers.aprl ];
    platforms = lib.platforms.linux;
  };
})
