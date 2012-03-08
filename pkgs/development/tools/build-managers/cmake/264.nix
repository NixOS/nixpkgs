{ fetchurl, stdenv, replace, curl, expat, zlib, bzip2, libarchive
, useNcurses ? false, ncurses, useQt4 ? false, qt4, xmlrpc_c
, darwinInstallNameToolUtility }:

with stdenv.lib;

let
  os = stdenv.lib.optionalString;
  majorVersion = "2.6";
  minorVersion = "4";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "cmake-${os useNcurses "cursesUI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "${meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
    sha256 = "1wpxr5x4aggaqrqzjq3kg4hh09f0vyr1njik1pad01bvwd923pcw";
  };

  patches =
    # Don't search in non-Nix locations such as /usr, but do search in
    # Nixpkgs' Glibc.
    optional (stdenv ? glibc) ./search-path-264.patch;

  buildInputs = [ curl expat zlib bzip2 libarchive xmlrpc_c ]
    ++ optional stdenv.isDarwin darwinInstallNameToolUtility
    ++ optional useNcurses ncurses
    ++ optional useQt4 qt4;

  CMAKE_PREFIX_PATH = stdenv.lib.concatStringsSep ":" buildInputs;
  
  configureFlags =
    "--docdir=/share/doc/${name} --mandir=/share/man --system-libs"
    + stdenv.lib.optionalString useQt4 " --qt-gui";

  setupHook = ./setup-hook.sh;

   postPatch =
    ''
      dontUseCmakeConfigure=1
      source $setupHook
      fixCmakeFiles .
    '';

  preConfigure = optionalString (stdenv ? glibc)
    ''
      substituteInPlace Modules/Platform/UnixPaths.cmake --subst-var-by glibc ${stdenv.glibc}
    '';

  meta = {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
    platforms = if useQt4 then qt4.meta.platforms else stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
