{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "procps-${version}";
  version = "3.3.12";

  src = fetchurl {
    url = "mirror://sourceforge/procps-ng/procps-ng-${version}.tar.xz";
    sha256 = "1m57w6jmry84njd5sgk5afycbglql0al80grx027kwqqcfw5mmkf";
  };

  buildInputs = [ ncurses ];

  makeFlags = "usrbin_execdir=$(out)/bin";

  enableParallelBuilding = true;

  # Too red
  configureFlags = [ "--disable-modern-top" ];

  meta = {
    homepage = http://sourceforge.net/projects/procps-ng/;
    description = "Utilities that give information about processes using the /proc filesystem";
    priority = 10; # less than coreutils, which also provides "kill" and "uptime"
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux ++ lib.platforms.cygwin;
  };
}
