{
  lib,
  stdenv,
  fetchurl,
  kernel,
  kmod,
}:

stdenv.mkDerivation rec {
  name = "ixgbevf-${version}-${kernel.version}";
  version = "4.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/e1000/ixgbevf-${version}.tar.gz";
    sha256 = "0h8a2g4hm38wmr13gvi2188r7nlv2c5rx6cal9gkf1nh6sla181c";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  configurePhase = ''
    cd src
    makeFlagsArray+=(KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build INSTALL_MOD_PATH=$out MANDIR=/share/man)
    substituteInPlace common.mk --replace /sbin/depmod ${kmod}/bin/depmod
    # prevent host system kernel introspection
    substituteInPlace common.mk --replace /boot/System.map /not-exists
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Intel 82599 Virtual Function Driver";
    homepage = "https://sourceforge.net/projects/e1000/files/ixgbevf%20stable/";
    license = licenses.gpl2Only;
    priority = 20;
    # kernels ship ixgbevf driver for a long time already, maybe switch to a newest kernel?
    broken = versionAtLeast kernel.version "5.2";
  };
}
