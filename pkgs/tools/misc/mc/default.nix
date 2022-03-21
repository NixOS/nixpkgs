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

# updater only
, writeScript
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
    slang
    zip
  ] ++ lib.optionals (!stdenv.isDarwin) [ e2fsprogs gpm ];

  enableParallelBuilding = true;

  configureFlags = [ "--enable-vfs-smb" "PERL=${perl}/bin/perl" ];

  postPatch = ''
    substituteInPlace src/filemanager/ext.c \
      --replace /bin/rm ${coreutils}/bin/rm

    substituteInPlace misc/ext.d/misc.sh.in \
      --replace /bin/cat ${coreutils}/bin/cat
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

  passthru.updateScript = writeScript "update-mc" ''
   #!/usr/bin/env nix-shell
   #!nix-shell -i bash -p curl pcre common-updater-scripts

   set -eu -o pipefail

   # Expect the text in format of "Current version is: 4.8.27; ...".
   new_version="$(curl -s https://midnight-commander.org/ | pcregrep -o1 'Current version is: (([0-9]+\.?)+);')"
   update-source-version mc "$new_version"
 '';

  meta = with lib; {
    description = "File Manager and User Shell for the GNU Project";
    downloadPage = "https://www.midnight-commander.org/downloads/";
    homepage = "https://www.midnight-commander.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = with platforms; linux ++ darwin;
    repositories.git = "https://github.com/MidnightCommander/mc.git";
  };
}
