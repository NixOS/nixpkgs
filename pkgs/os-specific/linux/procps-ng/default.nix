{ stdenv, fetchurl, pkgconfig, ncurses, systemd }:

stdenv.mkDerivation rec {
  name = "procps-ng-3.3.10";

  src = fetchurl {
    url = "mirror://sourceforge/procps-ng/${name}.tar.xz";
    sha256 = "013z4rzy3p5m1zp6mmynpblv0c6zlcn91pw4k2vymz2djyc6ybm0";
  };

  buildInputs = [ pkgconfig ncurses systemd ];

  makeFlags = "usrbin_execdir=$(out)/bin";

  enableParallelBuilding = true;

  crossAttrs = {
    CC = stdenv.cross.config + "-gcc";
  };

  # Too red
  configureFlags = [
    "--disable-modern-top"
    "--enable-watch8bit"
    "--with-systemd"
    "--enable-skill"
    "--enable-oomem"
    "--enable-sigwinch"
  ];

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/projects/procps-ng/;
    description = "Utilities that give information about processes using the /proc filesystem";
    priority = 10; # less than coreutils, which also provides "kill" and "uptime"
    maintainers = with maintainers; [ wkennington ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
