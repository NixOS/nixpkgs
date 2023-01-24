{ lib
, gcc12Stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, curl
, glib
, gtk3
, libssh2
, openssl
, wxGTK32
, gitUpdater
}:

gcc12Stdenv.mkDerivation rec {
  pname = "freefilesync";
  version = "11.29";

  src = fetchFromGitHub {
    owner = "hkneptune";
    repo = "FreeFileSync";
    rev = "v${version}";
    sha256 = "sha256-UQ+CWqtcTwMGUTn6t3N+BkXs4qxddZtxDjcq7nz5F6U=";
  };

  # Patches from ROSA Linux
  patches = [
    # Disable loading of the missing Animal.dat
    (fetchpatch {
      url = "https://abf.io/import/freefilesync/raw/rosa2021.1-11.25-1/ffs_devuan.patch";
      sha256 = "sha256-o8T/tBinlhM1I82yXxm0ogZcZf+uri95vTJrca5mcqs=";
      excludes = [ "FreeFileSync/Source/ffs_paths.cpp" ];
      postFetch = ''
        substituteInPlace $out --replace " for Rosa" ""
      '';
    })
    # Fix build with GTK 3
    (fetchpatch {
      url = "https://abf.io/import/freefilesync/raw/rosa2021.1-11.25-1/ffs_devuan_gtk3.patch";
      sha256 = "sha256-NXt/+BRTcMk8bnjR9Hipv1NzV9YqRJqy0e3RMInoWsA=";
      postFetch = ''
        substituteInPlace $out --replace "-isystem/usr/include/gtk-3.0" ""
      '';
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
    glib
    gtk3
    libssh2
    openssl
    wxGTK32
  ];

  NIX_CFLAGS_COMPILE = [
    # Undef g_object_ref on GLib 2.56+
    "-DGLIB_VERSION_MIN_REQUIRED=GLIB_VERSION_2_54"
    "-DGLIB_VERSION_MAX_ALLOWED=GLIB_VERSION_2_54"
    # Define libssh2 constants
    "-DMAX_SFTP_READ_SIZE=30000"
    "-DMAX_SFTP_OUTGOING_SIZE=30000"
  ];

  buildPhase = ''
    runHook preBuild

    chmod +w FreeFileSync/Build
    cd FreeFileSync/Source
    make -j$NIX_BUILD_CORES
    cd RealTimeSync
    make -j$NIX_BUILD_CORES
    cd ../../..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R FreeFileSync/Build/* $out
    mv $out/{Bin,bin}

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Open Source File Synchronization & Backup Software";
    homepage = "https://freefilesync.org";
    license = [ licenses.gpl3Only licenses.openssl licenses.curl licenses.libssh2 ];
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.linux;
  };
}
