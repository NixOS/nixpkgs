{ stdenv, fetchurl, pkgconfig
, bzip2, curl, expat, libarchive, xz, zlib, libuv
, useNcurses ? false, ncurses, useQt4 ? false, qt4
, wantPS ? false, ps ? null
}:

with stdenv.lib;

assert wantPS -> (ps != null);
assert stdenv ? cc;
assert stdenv.cc ? libc;

let
  os = stdenv.lib.optionalString;
  majorVersion = "3.7";
  minorVersion = "1";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "cmake-${os useNcurses "cursesUI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "${meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
    # from https://cmake.org/files/v3.7/cmake-3.7.1-SHA-256.txt
    sha256 = "449a5bce64dbd4d5b9517ebd1a1248ed197add6ad27934478976fd5f1f9330e1";
  };

  # Don't search in non-Nix locations such as /usr, but do search in our libc.
  patches = [ ./search-path-3.2.patch ]
    ++ optional stdenv.isCygwin ./3.2.2-cygwin.patch;

  outputs = [ "out" ];
  setOutputFlags = false;

  setupHook = ./setup-hook.sh;

  buildInputs =
    [ setupHook pkgconfig bzip2 curl expat libarchive xz zlib libuv ]
    ++ optional useNcurses ncurses
    ++ optional useQt4 qt4;

  propagatedBuildInputs = optional wantPS ps;

  preConfigure = with stdenv; ''
      fixCmakeFiles .
      substituteInPlace Modules/Platform/UnixPaths.cmake \
        --subst-var-by libc_bin ${getBin cc.libc} \
        --subst-var-by libc_dev ${getDev cc.libc} \
        --subst-var-by libc_lib ${getLib cc.libc}
      substituteInPlace Modules/FindCxxTest.cmake \
        --replace "$""{PYTHON_EXECUTABLE}" ${stdenv.shell}
      configureFlags="--parallel=''${NIX_BUILD_CORES:-1} $configureFlags"
    '';
  configureFlags =
    [ "--docdir=share/doc/${name}"
      "--no-system-jsoncpp"
    ]
    ++ optional (!stdenv.isCygwin) "--system-libs"
    ++ optional useQt4 "--qt-gui"
    ++ ["--"]
    ++ optional (!useNcurses) "-DBUILD_CursesDialog=OFF";

  dontUseCmakeConfigure = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
    platforms = if useQt4 then qt4.meta.platforms else platforms.all;
    maintainers = with maintainers; [ urkud mornfall ttuegel ];
  };
}
