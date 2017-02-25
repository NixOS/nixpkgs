{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  name = "vhba-${version}";
  version = "20161009";

  src  = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${version}.tar.bz2";
    sha256 = "1n9k3z8hppnl5b5vrn41b69wqwdpml6pm0rgc8vq3jqwss5js1nd";
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
