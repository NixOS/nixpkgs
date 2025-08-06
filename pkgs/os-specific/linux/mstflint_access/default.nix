{
  lib,
  stdenv,
  fetchurl,
  kernel,
  kmod,
  mstflint,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "mstflint_access";
  inherit (mstflint) version;

  src = fetchurl {
    url = "https://github.com/Mellanox/mstflint/releases/download/v${version}/kernel-mstflint-${version}.tar.gz";
    hash = "sha256-kQBv/67miw6lSHIcCVYy66B7OHVofFs2N+evtsQ3Ovk=";
  };

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  installTargets = [ "modules_install" ];
  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "M=$(PWD)"
  ]
  ++ makeFlags;

  meta = with lib; {
    description = "Kernel module for Nvidia NIC firmware update";
    homepage = "https://github.com/Mellanox/mstflint";
    license = [ licenses.gpl2Only ];
    maintainers = with maintainers; [ thillux ];
    platforms = platforms.linux;
  };
}
