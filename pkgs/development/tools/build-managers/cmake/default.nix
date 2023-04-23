{ lib
, stdenv
, fetchurl
, buildPackages
, bzip2
, curlMinimal
, expat
, libarchive
, libuv
, ncurses
, openssl
, pkg-config
, ps
, rhash
, sphinx
, texinfo
, xz
, zlib
, isBootstrap ? false
, useOpenSSL ? !isBootstrap
, useSharedLibraries ? (!isBootstrap && !stdenv.isCygwin)
, uiToolkits ? [] # can contain "ncurses" and/or "qt5"
, buildDocs ? !(isBootstrap || (uiToolkits == []))
, darwin
, libsForQt5
}:

let
  inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
  inherit (libsForQt5) qtbase wrapQtAppsHook;
  cursesUI = lib.elem "ncurses" uiToolkits;
  qt5UI = lib.elem "qt5" uiToolkits;
in
# Accepts only "ncurses" and "qt5" as possible uiToolkits
assert lib.subtractLists [ "ncurses" "qt5" ] uiToolkits == [];
# Minimal, bootstrap cmake does not have toolkits
assert isBootstrap -> (uiToolkits == []);
stdenv.mkDerivation rec {
  pname = "cmake"
    + lib.optionalString isBootstrap "-boot"
    + lib.optionalString cursesUI "-cursesUI"
    + lib.optionalString qt5UI "-qt5UI";
  version = "3.25.3";

  src = fetchurl {
    url = "https://cmake.org/files/v${lib.versions.majorMinor version}/cmake-${version}.tar.gz";
    sha256 = "sha256-zJlXAdWQym3rxCRemYmTkJnKUoJ91GtdNZLwk6/hkBw=";
  };

  patches = [
    # Don't search in non-Nix locations such as /usr, but do search in our libc.
    ./001-search-path.diff
    # Don't depend on frameworks.
    ./002-application-services.diff
    # Derived from https://github.com/libuv/libuv/commit/1a5d4f08238dd532c3718e210078de1186a5920d
    ./003-libuv-application-services.diff
  ]
  ++ lib.optional stdenv.isCygwin ./004-cygwin.diff
  # Derived from https://github.com/curl/curl/commit/31f631a142d855f069242f3e0c643beec25d1b51
  ++ lib.optional (stdenv.isDarwin && isBootstrap) ./005-remove-systemconfiguration-dep.diff
  # On Darwin, always set CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG.
  ++ lib.optional stdenv.isDarwin ./006-darwin-always-set-runtime-c-flag.diff;

  outputs = [ "out" ] ++ lib.optionals buildDocs [ "man" "info" ];
  setOutputFlags = false;

  setupHooks = [
    ./setup-hook.sh
    ./check-pc-files-hook.sh
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = setupHooks ++ [
    pkg-config
  ]
  ++ lib.optionals buildDocs [ texinfo ]
  ++ lib.optionals qt5UI [ wrapQtAppsHook ];

  buildInputs = lib.optionals useSharedLibraries [
    bzip2
    curlMinimal
    expat
    libarchive
    xz
    zlib
    libuv
    rhash
  ]
  ++ lib.optional useOpenSSL openssl
  ++ lib.optional cursesUI ncurses
  ++ lib.optional qt5UI qtbase
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
  ] ++ (if useSharedLibraries
        then [ "--no-system-jsoncpp" "--system-libs" ]
        else [ "--no-system-libs" ]) # FIXME: cleanup
  ++ lib.optional qt5UI "--qt-gui"
  ++ lib.optionals buildDocs [
    "--sphinx-build=${sphinx}/bin/sphinx-build"
    "--sphinx-info"
    "--sphinx-man"
  ]
  # Workaround https://gitlab.kitware.com/cmake/cmake/-/issues/20568
  ++ lib.optionals stdenv.hostPlatform.is32bit [
    "CFLAGS=-D_FILE_OFFSET_BITS=64"
    "CXXFLAGS=-D_FILE_OFFSET_BITS=64"
  ]
  ++ [
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
    "-DBUILD_CursesDialog=${if cursesUI then "ON" else "OFF"}"
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
    homepage = "https://cmake.org/";
    description = "Cross-platform, open-source build system generator";
    longDescription = ''
      CMake is an open-source, cross-platform family of tools designed to build,
      test and package software. CMake is used to control the software
      compilation process using simple platform and compiler independent
      configuration files, and generate native makefiles and workspaces that can
      be used in the compiler environment of your choice.
    '';
    changelog = "https://cmake.org/cmake/help/v${lib.versions.majorMinor version}/release/${lib.versions.majorMinor version}.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ttuegel lnl7 AndersonTorres ];
    platforms = platforms.all;
    broken = (qt5UI && stdenv.isDarwin);
  };
}
