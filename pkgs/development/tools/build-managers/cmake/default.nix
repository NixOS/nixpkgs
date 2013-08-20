{ fetchurl, stdenv, replace, curl, expat, zlib, bzip2, libarchive
, useNcurses ? false, ncurses, useQt4 ? false, qt4
}:

with stdenv.lib;

let
  os = stdenv.lib.optionalString;
  majorVersion = "2.8";
  minorVersion = "11.2";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "cmake-${os useNcurses "cursesUI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "${meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
    sha256 = "0qh5dhd7ff08n2h569j7g9m92gb3bz14wvhwjhwl7lgx794cnamk";
  };

  enableParallelBuilding = true;

  patches =
    # See https://github.com/NixOS/nixpkgs/issues/762
    # and http://public.kitware.com/Bug/view.php?id=13887
    # Remove this patch when a CMake release contains the corresponding fix
    [ ./762-13887.patch ]
    # Don't search in non-Nix locations such as /usr, but do search in
    # Nixpkgs' Glibc. 
    ++ optional (stdenv ? glibc) ./search-path.patch;

  buildInputs = [ curl expat zlib bzip2 libarchive ]
    ++ optional useNcurses ncurses
    ++ optional useQt4 qt4;

  CMAKE_PREFIX_PATH = stdenv.lib.concatStringsSep ":" buildInputs;
  
  configureFlags =
    "--docdir=/share/doc/${name} --mandir=/share/man --system-libs"
    + stdenv.lib.optionalString useQt4 " --qt-gui";

  setupHook = ./setup-hook.sh;

  dontUseCmakeConfigure = true;

  preConfigure = optionalString (stdenv ? glibc)
    ''
      source $setupHook
      fixCmakeFiles .
      substituteInPlace Modules/Platform/UnixPaths.cmake --subst-var-by glibc ${stdenv.glibc}
    '';

  meta = {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
    platforms = if useQt4 then qt4.meta.platforms else stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
