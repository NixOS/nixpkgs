{ stdenv, fetchurl, kernel }:

#assert stdenv.lib.versionOlder kernel.version "3.17";

let base = "batman-adv-2016.5"; in

stdenv.mkDerivation rec {
  name = "${base}-${kernel.version}";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/${base}/${base}.tar.gz";
    sha256 = "1dqdzpxdrgqpgkc6bqfvbvx5x18bpd9y459j0iyva47lqj8gr86h";
  };

  hardeningDisable = [ "pic" ];

  preBuild = ''
    makeFlags="KERNELPATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    sed -i -e "s,INSTALL_MOD_DIR=,INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=," \
      -e /depmod/d Makefile
  '';

  meta = {
    homepage = http://www.open-mesh.org/projects/batman-adv/wiki/Wiki;
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ viric fpletz ];
    platforms = with stdenv.lib.platforms; linux;
    broken = (kernel.features.grsecurity or false);
  };
}
