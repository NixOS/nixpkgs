{ stdenv, fetchurl, fetchpatch, pkgconfig
, bzip2, curl, expat, libarchive, xz, zlib, libuv, rhash
, buildPackages
# darwin attributes
, ps
, isBootstrap ? false
, useSharedLibraries ? (!isBootstrap && !stdenv.isCygwin)
, useNcurses ? false, ncurses
, useQt4 ? false, qt4
, withQt5 ? false, qtbase
}:

assert withQt5 -> useQt4 == false;
assert useQt4 -> withQt5 == false;

with stdenv.lib;

let
  os = stdenv.lib.optionalString;
  majorVersion = "3.13";
  minorVersion = "4";
  # from https://cmake.org/files/v3.13/cmake-3.13.4-SHA-256.txt for cmake-3.13.4.tar.gz
  sha256 = "fdd928fee35f472920071d1c7f1a6a2b72c9b25e04f7a37b409349aef3f20e9b";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "cmake-${os isBootstrap "boot-"}${os useNcurses "cursesUI-"}${os withQt5 "qt5UI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "${meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
    inherit sha256;
  };

  patches = [
    # Don't search in non-Nix locations such as /usr, but do search in our libc.
    ./search-path.patch

    # Don't depend on frameworks.
    ./application-services.patch

    # Derived from https://github.com/libuv/libuv/commit/1a5d4f08238dd532c3718e210078de1186a5920d
    ./libuv-application-services.patch
  ] ++ optional stdenv.isCygwin ./3.2.2-cygwin.patch;

  outputs = [ "out" ];
  setOutputFlags = false;

  setupHook = ./setup-hook.sh;

  buildInputs =
    [ setupHook pkgconfig ]
    ++ optionals useSharedLibraries [ bzip2 curl expat libarchive xz zlib libuv rhash ]
    ++ optional useNcurses ncurses
    ++ optional useQt4 qt4
    ++ optional withQt5 qtbase;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  propagatedBuildInputs = optional stdenv.isDarwin ps;

  preConfigure = ''
    fixCmakeFiles .
    substituteInPlace Modules/Platform/UnixPaths.cmake \
      --subst-var-by libc_bin ${getBin stdenv.cc.libc} \
      --subst-var-by libc_dev ${getDev stdenv.cc.libc} \
      --subst-var-by libc_lib ${getLib stdenv.cc.libc}
    substituteInPlace Modules/FindCxxTest.cmake \
      --replace "$""{PYTHON_EXECUTABLE}" ${stdenv.shell}
    # BUILD_CC and BUILD_CXX are used to bootstrap cmake
    configureFlags="--parallel=''${NIX_BUILD_CORES:-1} CC=$BUILD_CC CXX=$BUILD_CXX $configureFlags"
  '';

  configureFlags = [
    "--docdir=share/doc/${name}"
  ] ++ (if useSharedLibraries then [ "--no-system-jsoncpp" "--system-libs" ] else [ "--no-system-libs" ]) # FIXME: cleanup
    ++ optional (useQt4 || withQt5) "--qt-gui"
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
    "-DCMAKE_AR=${getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar"
    "-DCMAKE_RANLIB=${getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ranlib"
    "-DCMAKE_STRIP=${getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}strip"
  ]
    # Avoid depending on frameworks.
    ++ optional (!useNcurses) "-DBUILD_CursesDialog=OFF";

  # make install attempts to use the just-built cmake
  preInstall = optional (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed -i 's|bin/cmake|${buildPackages.cmake}/bin/cmake|g' Makefile
  '';

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;

  # This isn't an autoconf configure script; triples are passed via
  # CMAKE_SYSTEM_NAME, etc.
  configurePlatforms = [ ];

  doCheck = false; # fails

  meta = with stdenv.lib; {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
    platforms = if useQt4 then qt4.meta.platforms else platforms.all;
    maintainers = with maintainers; [ ttuegel lnl7 ];
    license = licenses.bsd3;
  };
}
