{ stdenv, fetchurl, pkgconfig, glib, gpm, file, e2fsprogs
, libX11, libICE, perl, zip, unzip, gettext, slang, libssh2, openssl}:

stdenv.mkDerivation rec {
  name = "mc-${version}";
  version = "4.8.18";
  
  src = fetchurl {
    url = "http://www.midnight-commander.org/downloads/${name}.tar.xz";
    sha256 = "1kmysm1x7smxs9k483nin6bx1rx0av8xrqjx9yf73hc7r4anhqzp";
  };
  
  buildInputs = [ pkgconfig perl glib gpm slang zip unzip file gettext libX11 libICE e2fsprogs
    libssh2 openssl ];

  configureFlags = [ "--enable-vfs-smb" ];

  meta = {
    description = "File Manager and User Shell for the GNU Project";
    homepage = http://www.midnight-commander.org;
    downloadPage = "http://www.midnight-commander.org/downloads/";
    repositories.git = git://github.com/MidnightCommander/mc.git;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.linux;
    updateWalker = true;
  };
}
