{
  lib,
  stdenv,
  fetchurl,
  kernel,
  srcOnly,
  kmod,
  linuxHeaders,
  fetchFromGitHub,
  which,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  name = "ixgbe-${version}-${kernel.version}";
  version = "6.0.6";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ethernet-linux-ixgbe";
    sha256 = "sha256-pIuyYuGyDKXywb8R5wF0j13OWkO+E5dPbJh+tm+DYXA=";
    rev = "v6.0.6";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ which ];

  hardeningDisable = [ "pic" ];

  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  KVER = "${kernel.modDirVersion}";
  KHEADERS = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/source";

  configurePhase = ''
    cd src
    substituteInPlace common.mk --replace /sbin/depmod ${kmod}/bin/depmod
    # prevent host system kernel introspection
    substituteInPlace common.mk --replace /boot/System.map /not-exists
    substituteInPlace kcompat-generator.sh --replace 'cd "''${KSRC}"' 'cd "''${KHEADERS}"'
  '';

  preBuild = ''
    export src=$(pwd)
    export INSTALL_MOD_PATH=$out
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Intel 82599 Ethernet Driver";
    homepage = "https://github.com/intel/ethernet-linux-ixgbe";
    license = licenses.gpl2Only;
    priority = 20;
  };
}
