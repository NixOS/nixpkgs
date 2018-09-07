{ stdenv, fetchurl, fetchpatch, pkgconfig
, bzip2, curl, expat, libarchive, xz, zlib, libuv, rhash
, majorVersion ? "3.11"
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

with (
  {
    "3.11" = {
      minorVersion = "2";
      sha256 = "0j2jpx94lnqx5w59i9xihl56hf6ghk04438rqhh7lk1bryxj5g2y";
    };
    "3.10" = {
      minorVersion = "2";
      sha256 = "80d0faad4ab56de07aa21a7fc692c88c4ce6156d42b0579c6962004a70a3218b";
    };
    "3.9" = {
      minorVersion = "6";
      sha256 = "7410851a783a41b521214ad987bb534a7e4a65e059651a2514e6ebfc8f46b218";
    };

  }.${majorVersion}
    or (abort ''Unsupported configuration for cmake: majorVersion = "${majorVersion}";'')
);

let
  os = stdenv.lib.optionalString;
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "cmake-${os isBootstrap "boot-"}${os useNcurses "cursesUI-"}${os withQt5 "qt5UI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "${meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
    # from https://cmake.org/files/v3.10/cmake-3.10.2-SHA-256.txt
    inherit sha256;
  };

  prePatch = optionalString (!useSharedLibraries) ''
    substituteInPlace Utilities/cmlibarchive/CMakeLists.txt \
      --replace '"-framework CoreServices"' '""'
  '';

  # Don't search in non-Nix locations such as /usr, but do search in our libc.
  patches = [ ./search-path-3.9.patch ]
    ++ optional (versionOlder version "3.12") (fetchpatch {
      name = "cmake-3.11-libuv-1.21.patch";
      url = https://gitlab.kitware.com/cmake/cmake/commit/889033b5c6847cf1f7bd789384405d59dc333bf6.patch;
      sha256 = "0683zbyb3bicaxqzrj4wgdan6x08k30m20kkmpjvw30nr6a8r6xq";
    })
    # Don't depend on frameworks.
    ++ optional (useSharedLibraries && majorVersion == "3.11") ./application-services.patch  # TODO: remove conditional
    ++ optional stdenv.isCygwin ./3.2.2-cygwin.patch;

  outputs = [ "out" ];
  setOutputFlags = false;

  setupHook = ./setup-hook.sh;

  buildInputs =
    [ setupHook pkgconfig ]
    ++ optionals useSharedLibraries [ bzip2 curl expat libarchive xz zlib libuv rhash ]
    ++ optional useNcurses ncurses
    ++ optional useQt4 qt4
    ++ optional withQt5 qtbase;

  propagatedBuildInputs = optional stdenv.isDarwin ps;

  preConfigure = ''
    fixCmakeFiles .
    substituteInPlace Modules/Platform/UnixPaths.cmake \
      --subst-var-by libc_bin ${getBin stdenv.cc.libc} \
      --subst-var-by libc_dev ${getDev stdenv.cc.libc} \
      --subst-var-by libc_lib ${getLib stdenv.cc.libc}
    substituteInPlace Modules/FindCxxTest.cmake \
      --replace "$""{PYTHON_EXECUTABLE}" ${stdenv.shell}
    configureFlags="--parallel=''${NIX_BUILD_CORES:-1} $configureFlags"
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
