{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "procps-3.3.9";

  src = fetchurl {
    url = mirror://sourceforge/procps-ng/procps-ng-3.3.9.tar.xz;
    sha256 = "0qw69v7wx8hilwylyk9455k3h1xg8sc13vxh0pvdss7rml7wpw00";
  };

  buildInputs = [ ncurses ];

  makeFlags = "usrbin_execdir=$(out)/bin";

  enableParallelBuilding = true;

  crossAttrs = {
    CC = stdenv.cross.config + "-gcc";
  };

  meta = {
    homepage = http://sourceforge.net/projects/procps-ng/;
    description = "Utilities that give information about processes using the /proc filesystem";
    priority = 10; # less than coreutils, which also provides "kill" and "uptime"
  };
}
