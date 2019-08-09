{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  name = "vhba-${version}";
  version = "20190410";

  src  = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${version}.tar.bz2";
    sha256 = "1513hq130raxp9z5grj54cwfjfxj05apipxg425j0zicii59a60c";
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
