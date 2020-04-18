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
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "mc";
  version = "4.8.24";

  src = fetchurl {
    url = "https://www.midnight-commander.org/downloads/${pname}-${version}.tar.xz";
    sha256 = "0ikd2yql44p7nagmb08dmjqdwadclnvgr7ri9pmzc2s5f301r7w5";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

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
    downloadPage = "https://www.midnight-commander.org/downloads/";
    homepage = "https://www.midnight-commander.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = with platforms; linux ++ darwin;
    repositories.git = "https://github.com/MidnightCommander/mc.git";
    updateWalker = true;
  };
}
