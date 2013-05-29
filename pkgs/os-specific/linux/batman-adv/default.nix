{stdenv, fetchurl, kernelDev }:

stdenv.mkDerivation rec {
  name = "batman-adv-2013.2.0";

  src = fetchurl {
    url = "http://downloads.open-mesh.org/batman/releases/${name}/${name}.tar.gz";
    sha1 = "7d2aff2ad118cbc5452de43f7e9da8374521ec0e";
  };

  preBuild = ''
    makeFlags="KERNELPATH=${kernelDev}/lib/modules/${kernelDev.modDirVersion}/build"
    sed -i -e "s,INSTALL_MOD_DIR=,INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=," \
      -e /depmod/d Makefile
  '';

  meta = {
    homepage = http://www.open-mesh.org/projects/batman-adv/wiki/Wiki;
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
