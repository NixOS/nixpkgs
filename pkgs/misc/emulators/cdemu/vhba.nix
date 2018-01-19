{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  name = "vhba-${version}";
  version = "20170610";

  src  = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${version}.tar.bz2";
    sha256 = "1v6r0bgx0a65vlh36b1l2965xybngbpga6rp54k4z74xk0zwjw3r";
  };

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" "INSTALL_MOD_PATH=$(out)" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  meta = with stdenv.lib; {
    description = "Provides a Virtual (SCSI) HBA";
    homepage = http://cdemu.sourceforge.net/about/vhba/;
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
