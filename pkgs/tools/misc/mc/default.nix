{ stdenv, fetchurl, pkgconfig, glib, gpm, file, e2fsprogs
, libX11, libICE, perl, zip, unzip, gettext, slang, libssh2, openssl}:

stdenv.mkDerivation rec {
  name = "mc-${version}";
  version = "4.8.19";

  src = fetchurl {
    url = "http://www.midnight-commander.org/downloads/${name}.tar.xz";
    sha256 = "1pzjq4nfxl2aakxipdjs5hq9n14374ly1l00s40kd2djnnxmd7pb";
  };

  buildInputs = [ pkgconfig perl glib slang zip unzip file gettext libX11 libICE
    libssh2 openssl ] ++ stdenv.lib.optionals (!stdenv.isDarwin) [ e2fsprogs gpm ];

  configureFlags = [ "--enable-vfs-smb" ];

  postFixup = ''
    # remove unwanted build-dependency references
    sed -i -e "s!PKG_CONFIG_PATH=''${PKG_CONFIG_PATH}!PKG_CONFIG_PATH=$(echo "$PKG_CONFIG_PATH" | sed -e 's/./0/g')!" $out/bin/mc
  '';

  meta = {
    description = "File Manager and User Shell for the GNU Project";
    homepage = http://www.midnight-commander.org;
    downloadPage = "http://www.midnight-commander.org/downloads/";
    repositories.git = git://github.com/MidnightCommander/mc.git;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    updateWalker = true;
  };
}
