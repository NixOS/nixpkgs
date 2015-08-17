{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "procps-3.3.11";

  src = fetchurl {
    url = mirror://sourceforge/procps-ng/procps-ng-3.3.11.tar.xz;
    sha256 = "1va4n0mpsq327ca9dqp4hnrpgs6821rp0f2m0jyc1bfjl9lk2jg9";
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
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
