{fetchurl, stdenv, replace, curl, expat, zlib
, useNcurses ? false, ncurses, useQt4 ? false, qt4}:

let
  os = stdenv.lib.optionalString;
  majorVersion = "2.8";
  minorVersion = "1";
  version = "${majorVersion}.${minorVersion}";
in
stdenv.mkDerivation rec {
  name = "cmake-${os useNcurses "cursesUI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "${meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
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
    platforms = if useQt4 then qt4.meta.platforms else stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
