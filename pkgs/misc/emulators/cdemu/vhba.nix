{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  pname = "vhba";
  version = "20190831";

  src  = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${version}.tar.bz2";
    sha256 = "1ybbk6l06n0y11n5wnfmvdz0baizmq55l458ywimghdyz0n7g0ws";
  };

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" "INSTALL_MOD_PATH=$(out)" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  meta = with stdenv.lib; {
    description = "Provides a Virtual (SCSI) HBA";
    homepage = http://cdemu.sourceforge.net/about/vhba/;
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ bendlas ];
  };
}
