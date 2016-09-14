{ stdenv, fetchurl, pkgconfig, glib, gpm, file, e2fsprogs
, libX11, libICE, perl, zip, unzip, gettext, slang, libssh2, openssl}:

stdenv.mkDerivation rec {
  name = "mc-${version}";
  version = "4.8.17";
  
  src = fetchurl {
    url = "http://www.midnight-commander.org/downloads/${name}.tar.bz2";
    sha256 = "0fvqzffppj0aja9hi0k1xdjg5m6s99immlla1y9yzn5fp8vwpl36";    
  };
  
  buildInputs = [ pkgconfig perl glib gpm slang zip unzip file gettext libX11 libICE e2fsprogs
    libssh2 openssl ];

  configureFlags = [ "--enable-vfs-smb" ];

  meta = {
    description = "File Manager and User Shell for the GNU Project";
    homepage = http://www.midnight-commander.org;
    repositories.git = git://github.com/MidnightCommander/mc.git;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.linux;
  };
}
