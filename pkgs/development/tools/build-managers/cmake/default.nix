{ stdenv, lib, fetchurl, pkgconfig, fetchpatch
, bzip2, curl, expat, libarchive, xz, zlib, libuv, rhash
, buildPackages
# darwin attributes
, ps
, isBootstrap ? false
, useSharedLibraries ? (!isBootstrap && !stdenv.isCygwin)
, useOpenSSL ? !isBootstrap, openssl
, useNcurses ? false, ncurses
, useQt4 ? false, qt4
, withQt5 ? false, qtbase
}:

assert withQt5 -> useQt4 == false;
assert useQt4 -> withQt5 == false;

stdenv.mkDerivation rec {
  pname = "cmake"
          + lib.optionalString isBootstrap "-boot"
          + lib.optionalString useNcurses "-cursesUI"
          + lib.optionalString withQt5 "-qt5UI"
          + lib.optionalString useQt4 "-qt4UI";
  version = "3.19.1";

  src = fetchurl {
    url = "${meta.homepage}files/v${lib.versions.majorMinor version}/cmake-${version}.tar.gz";
    # compare with https://cmake.org/files/v${lib.versions.majorMinor version}/cmake-${version}-SHA-256.txt
    sha256 = "1fisi9rlijw9wd0yjzk1c6j7ljnb2yiq5iqnrz6m1xkflyinw9hx";
  };

  patches = [
    # Don't search in non-Nix locations such as /usr, but do search in our libc.
    ./search-path.patch

    # Don't depend on frameworks.
    ./application-services.patch

    # Derived from https://github.com/libuv/libuv/commit/1a5d4f08238dd532c3718e210078de1186a5920d
    ./libuv-application-services.patch

    # Fix namelink failures, can be removed in 3.19.2+
    (fetchpatch {
      url = "https://gitlab.kitware.com/cmake/cmake/-/commit/38bcb5c0a3accd2dd29fb7632c6b3bf31b990d82.patch";
      sha256 = "17yr66wrayhmavsz46b37zfwp2jcwab1zig2xqps39ysndf74qjc";
    })

  ] ++ lib.optional stdenv.isCygwin ./3.2.2-cygwin.patch;

  outputs = [ "out" ];
  setOutputFlags = false;

  setupHook = ./setup-hook.sh;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ setupHook pkgconfig ];

  buildInputs = []
    ++ lib.optionals useSharedLibraries [ bzip2 curl expat libarchive xz zlib libuv rhash ]
    ++ lib.optional useOpenSSL openssl
    ++ lib.optional useNcurses ncurses
    ++ lib.optional useQt4 qt4
    ++ lib.optional withQt5 qtbase;

  propagatedBuildInputs = lib.optional stdenv.isDarwin ps;

  preConfigure = ''
    fixCmakeFiles .
    substituteInPlace Modules/Platform/UnixPaths.cmake \
      --subst-var-by libc_bin ${lib.getBin stdenv.cc.libc} \
      --subst-var-by libc_dev ${lib.getDev stdenv.cc.libc} \
      --subst-var-by libc_lib ${lib.getLib stdenv.cc.libc}
    substituteInPlace Modules/FindCxxTest.cmake \
      --replace "$""{PYTHON_EXECUTABLE}" ${stdenv.shell}
  ''
  # CC_FOR_BUILD and CXX_FOR_BUILD are used to bootstrap cmake
  + ''
    configureFlags="--parallel=''${NIX_BUILD_CORES:-1} CC=$CC_FOR_BUILD CXX=$CXX_FOR_BUILD $configureFlags"
  '';

  configureFlags = [
    "--docdir=share/doc/${pname}${version}"
  ] ++ (if useSharedLibraries then [ "--no-system-jsoncpp" "--system-libs" ] else [ "--no-system-libs" ]) # FIXME: cleanup
    ++ lib.optional (useQt4 || withQt5) "--qt-gui"
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
    "-DBUILD_CursesDialog=${if useNcurses then "ON" else "OFF"}"
  ];

  # make install attempts to use the just-built cmake
  preInstall = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) ''
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
    changelog = "https://cmake.org/cmake/help/v${lib.versions.majorMinor version}/"
      + "release/${lib.versions.majorMinor version}.html";
    description = "Cross-Platform Makefile Generator";
    longDescription = ''
      CMake is an open-source, cross-platform family of tools designed to
      build, test and package software. CMake is used to control the software
      compilation process using simple platform and compiler independent
      configuration files, and generate native makefiles and workspaces that
      can be used in the compiler environment of your choice.
    '';
    platforms = if useQt4 then qt4.meta.platforms else platforms.all;
    maintainers = with maintainers; [ ttuegel lnl7 ];
    license = licenses.bsd3;
  };
}
