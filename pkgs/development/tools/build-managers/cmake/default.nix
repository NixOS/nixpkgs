{fetchurl, stdenv, replace, curl, expat, zlib
, useNcurses ? false, ncurses, useQt4 ? false, qt4}:

stdenv.mkDerivation rec {
  name = "cmake-${majorVersion}.1";

  majorVersion = "2.8";

  src = fetchurl {
    url = "http://www.cmake.org/files/v${majorVersion}/${name}.tar.gz";
    sha256 = "0hi28blqxvir0dkhln90sgr0m3ri9n2i3hlmwdl4m5vkfsmp9bky";
  };

  buildInputs = [ curl expat zlib ]
    ++ stdenv.lib.optional useNcurses ncurses
    ++ stdenv.lib.optional useQt4 qt4;

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
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
