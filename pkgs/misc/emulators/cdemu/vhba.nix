{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  name = "vhba-${version}";
  version = "20140928";

  src  = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${version}.tar.bz2";
    sha256 = "18jmpg2kpx87f32b8aprr1pxla9dlhf901rkj1sp3ammf94nxxa5";
  };

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" "INSTALL_MOD_PATH=$(out)" ];

  hardeningDisable = [ "pic" ];

  meta = with stdenv.lib; {
    description = "Provides a Virtual (SCSI) HBA";
    homepage = "http://cdemu.sourceforge.net/about/vhba/";
    platforms = platforms.linux;
    licenses = licenses.gpl2Plus;
  };
}
