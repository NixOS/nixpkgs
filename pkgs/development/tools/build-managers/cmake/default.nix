{fetchurl, stdenv, replace, curl, expat, zlib, bzip2, libarchive
, useNcurses ? false, ncurses, useQt4 ? false, qt4}:

let
  os = stdenv.lib.optionalString;
  inherit (stdenv.lib) optional;
  majorVersion = "2.8";
  minorVersion = "3";
  version = "${majorVersion}.${minorVersion}";
in
stdenv.mkDerivation rec {
  name = "cmake-${os useNcurses "cursesUI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "${meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
    sha256 = "1262bz0c0g5c57ba7rbbrs72xa42xs26fwf72mazmkmmhqkx17k8";
  };

  buildInputs = [ curl expat zlib bzip2 libarchive ]
    ++ optional useNcurses ncurses
    ++ optional useQt4 qt4;

  CMAKE_PREFIX_PATH = stdenv.lib.concatStringsSep ":" buildInputs;
  configureFlags =
    "--docdir=/share/doc/${name} --mandir=/share/man --system-libs"
    + stdenv.lib.optionalString useQt4 " --qt-gui";

  setupHook = ./setup-hook.sh;

  postUnpack = ''
    dontUseCmakeConfigure=1
    source $setupHook
    fixCmakeFiles $sourceRoot
  '';

  meta = {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
    platforms = if useQt4 then qt4.meta.platforms else (with stdenv.lib.platforms; linux ++ freebsd);
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
