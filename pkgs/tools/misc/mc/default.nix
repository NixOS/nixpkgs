{ stdenv, fetchurl, pkgconfig, glib, gpm, file, e2fsprogs
, libX11, libICE, perl, zip, unzip, gettext, slang}:

stdenv.mkDerivation rec {
  name = "mc-4.8.0";
  
  src = fetchurl {
    url = http://www.midnight-commander.org/downloads/mc-4.8.0.tar.bz2;
    sha256 = "dbf077b318c13fc6d465dc67bd43958f067b9ff7e21041975bd14927dfa31b52";
  };
  
  buildInputs = [ pkgconfig perl glib gpm slang zip unzip file gettext libX11 libICE e2fsprogs ];

  meta = {
    description = "File Manager and User Shell for the GNU Project";
    homepage = http://www.midnight-commander.org;
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
