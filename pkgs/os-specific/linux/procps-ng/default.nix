{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "procps-3.3.10";

  src = fetchurl {
    url = mirror://sourceforge/procps-ng/procps-ng-3.3.10.tar.xz;
    sha256 = "013z4rzy3p5m1zp6mmynpblv0c6zlcn91pw4k2vymz2djyc6ybm0";
  };

  buildInputs = [ ncurses ];

  makeFlags = "usrbin_execdir=$(out)/bin";

  enableParallelBuilding = true;

  crossAttrs = {
    CC = stdenv.cross.config + "-gcc";
  };

  # Too red
  configureFlags = [ "--disable-modern-top" ];

  meta = {
    homepage = http://sourceforge.net/projects/procps-ng/;
    description = "Utilities that give information about processes using the /proc filesystem";
    priority = 10; # less than coreutils, which also provides "kill" and "uptime"
  };
}
