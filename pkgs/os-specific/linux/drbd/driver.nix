{
  stdenv,
  lib,
  fetchurl,
  kernel,
  kernelModuleMakeFlags,
  nixosTests,
  flex,
  coccinelle,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drbd";
  version = "9.2.14";

  src = fetchurl {
    url = "https://pkg.linbit.com//downloads/drbd/9/drbd-${finalAttrs.version}.tar.gz";
    hash = "sha256-x8onWPTyBnKt17xofivVlU+42nq1XtCo9i14kSOSd98=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [
    kernel.moduleBuildDependencies
    flex
    coccinelle
    python3
  ];

  enableParallelBuilding = true;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KVER=${kernel.version}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "M=$(sourceRoot)"
    "SPAAS=false"
  ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile --replace 'SHELL=/bin/bash' 'SHELL=${builtins.getEnv "SHELL"}'
  '';

  passthru.tests.drbd-driver = nixosTests.drbd-driver;

  meta = with lib; {
    homepage = "https://github.com/LINBIT/drbd";
    description = "LINBIT DRBD kernel module";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ birkb ];
    longDescription = ''
      DRBD is a software-based, shared-nothing, replicated storage solution
      mirroring the content of block devices (hard disks, partitions, logical volumes, and so on) between hosts.
    '';
    broken = kernel.kernelAtLeast "6.16"; # several build errors with 6.16.x kernel versions
  };
})
