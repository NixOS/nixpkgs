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
<<<<<<< HEAD
  version = "9.2.16";

  src = fetchurl {
    url = "https://pkg.linbit.com//downloads/drbd/9/drbd-${finalAttrs.version}.tar.gz";
    hash = "sha256-2ff9XtSlUnJG5y6qrRYGTgQiZdEnzywKaKR96ItF8Zw=";
=======
  version = "9.2.15";

  src = fetchurl {
    url = "https://pkg.linbit.com//downloads/drbd/9/drbd-${finalAttrs.version}.tar.gz";
    hash = "sha256-bKaL7wtjlSbUkLRlMSrGYjab0jdS8lu5bgScTbfpllE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/LINBIT/drbd";
    description = "LINBIT DRBD kernel module";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ birkb ];
=======
  meta = with lib; {
    homepage = "https://github.com/LINBIT/drbd";
    description = "LINBIT DRBD kernel module";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ birkb ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    longDescription = ''
      DRBD is a software-based, shared-nothing, replicated storage solution
      mirroring the content of block devices (hard disks, partitions, logical volumes, and so on) between hosts.
    '';
<<<<<<< HEAD
    broken = kernel.kernelOlder "5.11";
=======
    broken = kernel.kernelOlder "5.11" || kernel.kernelAtLeast "6.17";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
