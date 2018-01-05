{ stdenv, fetchurl, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "ixgbevf-${version}-${kernel.version}";
  version = "4.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/e1000/ixgbevf-${version}.tar.gz";
    sha256 = "1666hsavaspjmf45ij396mkndzk6g0n3ibr2glfdhjfqhfy35zb8";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  configurePhase = ''
    cd src
    makeFlagsArray+=(KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build INSTALL_MOD_PATH=$out MANDIR=/share/man)
    substituteInPlace common.mk --replace /sbin/depmod ${kmod}/bin/depmod
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Intel 82599 Virtual Function Driver";
    homepage = https://sourceforge.net/projects/e1000/files/ixgbevf%20stable/;
    license = stdenv.lib.licenses.gpl2;
    priority = 20;
    broken = (stdenv.lib.versionOlder kernel.version "4.9");
  };
}
