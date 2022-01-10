{ lib, stdenv, fetchurl, fetchpatch, kernel }:

stdenv.mkDerivation rec {
  pname = "vhba";
  version = "20211218";

  src  = fetchurl {
    url = "mirror://sourceforge/cdemu/vhba-module-${version}.tar.xz";
    sha256 = "1dkprnnya0i8121p7ip4g8cww99drk7fzbwcxx65x02jqk0siibj";
  };

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" "INSTALL_MOD_PATH=$(out)" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  meta = with lib; {
    description = "Provides a Virtual (SCSI) HBA";
    homepage = "https://cdemu.sourceforge.io/about/vhba/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bendlas ];
  };
}
