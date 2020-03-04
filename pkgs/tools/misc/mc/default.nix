{ stdenv
, fetchurl
, pkgconfig
, glib
, gpm
, file
, e2fsprogs
, libX11
, libICE
, perl
, zip
, unzip
, gettext
, slang
, libssh2
, openssl
, coreutils
}:

stdenv.mkDerivation rec {
  pname = "mc";
  version = "4.8.23";

  src = fetchurl {
    url = "http://www.midnight-commander.org/downloads/${pname}-${version}.tar.xz";
    sha256 = "077z7phzq3m1sxyz7li77lyzv4rjmmh3wp2vy86pnc4387kpqzyx";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    file
    gettext
    glib
    libICE
    libX11
    libssh2
    openssl
    perl
    slang
    unzip
    zip
  ] ++ stdenv.lib.optionals (!stdenv.isDarwin) [ e2fsprogs gpm ];

  enableParallelBuilding = true;

  configureFlags = [ "--enable-vfs-smb" ];

  postPatch = ''
    substituteInPlace src/filemanager/ext.c \
      --replace /bin/rm ${coreutils}/bin/rm
  '';

  postFixup = ''
    # remove unwanted build-dependency references
    sed -i -e "s!PKG_CONFIG_PATH=''${PKG_CONFIG_PATH}!PKG_CONFIG_PATH=$(echo "$PKG_CONFIG_PATH" | sed -e 's/./0/g')!" $out/bin/mc
  '';

  meta = with stdenv.lib; {
    description = "File Manager and User Shell for the GNU Project";
    downloadPage = "http://www.midnight-commander.org/downloads/";
    homepage = "http://www.midnight-commander.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = with platforms; linux ++ darwin;
    repositories.git = git://github.com/MidnightCommander/mc.git;
    updateWalker = true;
  };
}
