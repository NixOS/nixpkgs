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
  kernelModuleMakeFlags
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

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [which];

  hardeningDisable = [ "pic" ];

  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  # KSRC = "${linuxHeaders}";
  #KSRC="${srcOnly kernel}";
  KVER="${kernel.modDirVersion}";
  KHEADERS = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/source";

  configurePhase = ''
    cd src
    # makeFlagsArray+=(KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build INSTALL_MOD_PATH=$out MANDIR=/share/man)
    substituteInPlace common.mk --replace /sbin/depmod ${kmod}/bin/depmod
    # prevent host system kernel introspection
    substituteInPlace common.mk --replace /boot/System.map /not-exists
    #substituteInPlace common.mk --replace /lib/modules/ "${kernel.dev}/lib/modules/"
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
    # kernels ship ixgbevf driver for a long time already, maybe switch to a newest kernel?
    # broken = versionAtLeast kernel.version "5.2";
  };
}
