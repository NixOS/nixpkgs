{ stdenv, fetchurl, pkgconfig
, bzip2, curl, expat, libarchive, xz, zlib, libuv, rhash
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
  majorVersion = "3.9";
  minorVersion = "2";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "cmake-${os isBootstrap "boot-"}${os useNcurses "cursesUI-"}${os withQt5 "qt5UI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "${meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
    # from https://cmake.org/files/v3.9/cmake-3.9.2-SHA-256.txt
    sha256 = "954a5801a456ee48e76f01107c9a4961677dd0f3e115275bbd18410dc22ba3c1";
  };

  prePatch = optionalString (!useSharedLibraries) ''
    substituteInPlace Utilities/cmlibarchive/CMakeLists.txt \
      --replace '"-framework CoreServices"' '""'
  '';

  # Don't search in non-Nix locations such as /usr, but do search in our libc.
  patches = [ ./search-path-3.9.patch ]
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

  configureFlags = [ "--docdir=share/doc/${name}" ]
    ++ (if useSharedLibraries then [ "--no-system-jsoncpp" "--system-libs" ] else [ "--no-system-libs" ]) # FIXME: cleanup
    ++ optional (useQt4 || withQt5) "--qt-gui"
    ++ optionals (!useNcurses) [ "--" "-DBUILD_CursesDialog=OFF" ];

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
    platforms = if useQt4 then qt4.meta.platforms else platforms.all;
    maintainers = with maintainers; [ mornfall ttuegel lnl7 ];
  };
}
