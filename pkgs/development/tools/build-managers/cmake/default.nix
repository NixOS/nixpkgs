{ stdenv, lib, fetchurl, pkg-config
, bzip2, curlMinimal, expat, libarchive, xz, zlib, libuv, rhash
, buildPackages
# darwin attributes
, SystemConfiguration
, ps
, isBootstrap ? false
, useSharedLibraries ? (!isBootstrap && !stdenv.isCygwin)
, useOpenSSL ? !isBootstrap, openssl
, useNcurses ? false, ncurses
, withQt5 ? false, qtbase, wrapQtAppsHook
, buildDocs ? (!isBootstrap && (useNcurses || withQt5)), sphinx, texinfo
}:

stdenv.mkDerivation rec {
  pname = "cmake"
    + lib.optionalString isBootstrap "-boot"
    + lib.optionalString useNcurses "-cursesUI"
    + lib.optionalString withQt5 "-qt5UI";
  version = "3.22.3";

  src = fetchurl {
    url = "https://cmake.org/files/v${lib.versions.majorMinor version}/cmake-${version}.tar.gz";
    sha256 = "sha256-n4RpFm+UVTtpeKFu4pIn7Emi61zrYIJ13sQNiuDRtaA=";
  };

  patches = [
    # Don't search in non-Nix locations such as /usr, but do search in our libc.
    ./search-path.patch

    # Don't depend on frameworks.
    ./application-services.patch

    # Derived from https://github.com/libuv/libuv/commit/1a5d4f08238dd532c3718e210078de1186a5920d
    ./libuv-application-services.patch

  ] ++ lib.optional stdenv.isCygwin ./3.2.2-cygwin.patch
  # Derived from https://github.com/curl/curl/commit/31f631a142d855f069242f3e0c643beec25d1b51
  ++ lib.optional (stdenv.isDarwin && isBootstrap) ./remove-systemconfiguration-dep.patch
  # On Darwin, always set CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG.
  ++ lib.optional stdenv.isDarwin ./darwin-always-set-runtime-c-flag.patch;

  outputs = [ "out" ]
    ++ lib.optionals buildDocs [ "man" "info" ];
  setOutputFlags = false;

  setupHook = ./setup-hook.sh;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ setupHook pkg-config ]
    ++ lib.optionals buildDocs [ texinfo ]
    ++ lib.optionals withQt5 [ wrapQtAppsHook ];

  buildInputs = lib.optionals useSharedLibraries [ bzip2 curlMinimal expat libarchive xz zlib libuv rhash ]
    ++ lib.optional useOpenSSL openssl
    ++ lib.optional useNcurses ncurses
    ++ lib.optional withQt5 qtbase
    ++ lib.optional (stdenv.isDarwin && !isBootstrap) SystemConfiguration;

  propagatedBuildInputs = lib.optional stdenv.isDarwin ps;

  preConfigure = ''
    fixCmakeFiles .
    substituteInPlace Modules/Platform/UnixPaths.cmake \
      --subst-var-by libc_bin ${lib.getBin stdenv.cc.libc} \
      --subst-var-by libc_dev ${lib.getDev stdenv.cc.libc} \
      --subst-var-by libc_lib ${lib.getLib stdenv.cc.libc}
    # CC_FOR_BUILD and CXX_FOR_BUILD are used to bootstrap cmake
    configureFlags="--parallel=''${NIX_BUILD_CORES:-1} CC=$CC_FOR_BUILD CXX=$CXX_FOR_BUILD $configureFlags"
  '';

  configureFlags = [
    "CXXFLAGS=-Wno-elaborated-enum-base"
    "--docdir=share/doc/${pname}${version}"
  ] ++ (if useSharedLibraries then [ "--no-system-jsoncpp" "--system-libs" ] else [ "--no-system-libs" ]) # FIXME: cleanup
  ++ lib.optional withQt5 "--qt-gui"
  ++ lib.optionals buildDocs [
    "--sphinx-build=${sphinx}/bin/sphinx-build"
    "--sphinx-man"
    "--sphinx-info"
  ]
  # Workaround https://gitlab.kitware.com/cmake/cmake/-/issues/20568
  ++ lib.optionals stdenv.hostPlatform.is32bit [
    "CFLAGS=-D_FILE_OFFSET_BITS=64"
    "CXXFLAGS=-D_FILE_OFFSET_BITS=64"
  ] ++ [
    "--"
    # We should set the proper `CMAKE_SYSTEM_NAME`.
    # http://www.cmake.org/Wiki/CMake_Cross_Compiling
    #
    # Unfortunately cmake seems to expect absolute paths for ar, ranlib, and
    # strip. Otherwise they are taken to be relative to the source root of the
    # package being built.
    "-DCMAKE_CXX_COMPILER=${stdenv.cc.targetPrefix}c++"
    "-DCMAKE_C_COMPILER=${stdenv.cc.targetPrefix}cc"
    "-DCMAKE_AR=${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar"
    "-DCMAKE_RANLIB=${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ranlib"
    "-DCMAKE_STRIP=${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}strip"

    "-DCMAKE_USE_OPENSSL=${if useOpenSSL then "ON" else "OFF"}"
    # Avoid depending on frameworks.
    "-DBUILD_CursesDialog=${if useNcurses then "ON" else "OFF"}"
  ];

  # make install attempts to use the just-built cmake
  preInstall = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed -i 's|bin/cmake|${buildPackages.cmakeMinimal}/bin/cmake|g' Makefile
  '';

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;

  # This isn't an autoconf configure script; triples are passed via
  # CMAKE_SYSTEM_NAME, etc.
  configurePlatforms = [ ];

  doCheck = false; # fails

  meta = with lib; {
    broken = (withQt5 && stdenv.isDarwin);
    homepage = "https://cmake.org/";
    changelog = "https://cmake.org/cmake/help/v${lib.versions.majorMinor version}/release/${lib.versions.majorMinor version}.html";
    description = "Cross-Platform Makefile Generator";
    longDescription = ''
      CMake is an open-source, cross-platform family of tools designed to
      build, test and package software. CMake is used to control the software
      compilation process using simple platform and compiler independent
      configuration files, and generate native makefiles and workspaces that
      can be used in the compiler environment of your choice.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel lnl7 ];
    license = licenses.bsd3;
  };
}
