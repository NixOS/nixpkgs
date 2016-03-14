{ stdenv, fetchurl, gettext, bzip2 }:

stdenv.mkDerivation rec {
  name = "sysstat-11.0.7";

  src = fetchurl {
    url = "http://perso.orange.fr/sebastien.godard/${name}.tar.xz";
    sha256 = "12j55rdx1hyhsc5qm0anx9h9siaa58lhh9dchp40q4ag2wxamp1r";
  };

  buildInputs = [ gettext ];

  preConfigure = ''
    export PATH_CP=$(type -tp cp)
    export PATH_CHKCONFIG=/no-such-program
    export BZIP=${bzip2.bin}/bin/bzip2
    export SYSTEMCTL=systemctl
  '';

  makeFlags = "SYSCONFIG_DIR=$(out)/etc IGNORE_MAN_GROUP=y CHOWN=true";
  installTargets = "install_base install_nls install_man";

  patches = [ ./install.patch ];

  meta = {
    homepage = http://sebastien.godard.pagesperso-orange.fr/;
    description = "A collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
