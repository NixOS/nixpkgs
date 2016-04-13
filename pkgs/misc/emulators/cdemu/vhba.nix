{ stdenv, fetchurl, kernel }:
let version = "20140928";
in stdenv.mkDerivation {
  name = "vhba-${version}";
  src  = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${version}.tar.bz2";
    sha256 = "18jmpg2kpx87f32b8aprr1pxla9dlhf901rkj1sp3ammf94nxxa5";
  };
  preBuild = ''
    makeFlags="KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build INSTALL_MOD_PATH=$out";
  '';
}
