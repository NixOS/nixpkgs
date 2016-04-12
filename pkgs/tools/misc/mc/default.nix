{ stdenv, fetchurl, pkgconfig, glib, gpm, file, e2fsprogs
, libX11, libICE, perl, zip, unzip, gettext, slang}:

stdenv.mkDerivation rec {
  name = "mc-4.8.16";
  
  src = fetchurl {
    url = http://www.midnight-commander.org/downloads/mc-4.8.16.tar.bz2;
    sha256 = "1y5apnp6sc9sn13m6816hlrr0dis1z7wsnffldsx7xlkvyas8zn3";
  };
  
  buildInputs = [ pkgconfig perl glib gpm slang zip unzip file gettext libX11 libICE e2fsprogs ];

  meta = {
    description = "File Manager and User Shell for the GNU Project";
    homepage = http://www.midnight-commander.org;
    repositories.git = git://github.com/MidnightCommander/mc.git;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
