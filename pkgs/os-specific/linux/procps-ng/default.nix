{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "procps-ng-3.3.6";

  src = fetchurl {
    url = mirror://sourceforge/procps-ng/procps-ng-3.3.6.tar.xz;
    sha256 = "0k0j3ilzfpw8n3y058ymgfmafdfqqqwpqm7nh7a35xlk6zgw96nh";
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
