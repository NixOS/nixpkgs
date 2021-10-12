{ lib, stdenv
, fetchurl
, pkg-config
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
, autoSignDarwinBinariesHook
}:

stdenv.mkDerivation rec {
  pname = "mc";
  version = "4.8.27";

  src = fetchurl {
    url = "https://www.midnight-commander.org/downloads/${pname}-${version}.tar.xz";
    sha256 = "sha256-Mb5ZIl/6mSCBbpqLO+CrIloW0Z5Pr0aJDyW9/6AqT/Q=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook unzip ]
    # The preFixup hook rewrites the binary, which invaliates the code
    # signature. Add the fixup hook to sign the output.
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      autoSignDarwinBinariesHook
    ];

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
    zip
  ] ++ lib.optionals (!stdenv.isDarwin) [ e2fsprogs gpm ];

  enableParallelBuilding = true;

  configureFlags = [ "--enable-vfs-smb" ];

  postPatch = ''
    substituteInPlace src/filemanager/ext.c \
      --replace /bin/rm ${coreutils}/bin/rm
  '';

  preFixup = ''
    # remove unwanted build-dependency references
    sed -i -e "s!PKG_CONFIG_PATH=''${PKG_CONFIG_PATH}!PKG_CONFIG_PATH=$(echo "$PKG_CONFIG_PATH" | sed -e 's/./0/g')!" $out/bin/mc
  '';

  postFixup = lib.optionalString (!stdenv.isDarwin) ''
    # libX11.so is loaded dynamically so autopatch doesn't detect it
    patchelf \
      --add-needed ${libX11}/lib/libX11.so \
      $out/bin/mc
  '';

  meta = with lib; {
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
