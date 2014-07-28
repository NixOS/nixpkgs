{ stdenv, fetchurl, gettext }:
   
stdenv.mkDerivation rec {
  name = "sysstat-10.1.1";
   
  src = fetchurl {
    url = "http://perso.orange.fr/sebastien.godard/${name}.tar.bz2";
    sha256 = "1ig6k4yjkkazddjr90hykiapl30s9r9c1gy1h8hqzn2c3xgkm7p3";
  };

  buildInputs = [ gettext ];

  preConfigure = ''
    export PATH_CP=$(type -tp cp)
    export PATH_CHKCONFIG=/no-such-program
    makeFlagsArray=(SA_DIR=/var/log/sa SYSCONFIG_DIR=$out/etc CHOWN=true IGNORE_MAN_GROUP=y)
  '';

  patches = [ ./no-install-statedir.patch ];

  meta = {
    homepage = http://sebastien.godard.pagesperso-orange.fr/;
    description = "A collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
