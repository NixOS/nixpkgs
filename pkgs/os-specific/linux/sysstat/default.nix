{ stdenv, fetchurl, gettext }:
   
stdenv.mkDerivation rec {
  name = "sysstat-9.0.6.1";
   
  src = fetchurl {
    url = "http://perso.orange.fr/sebastien.godard/${name}.tar.bz2";
    sha256 = "061r616cc0wfjkrk5ywqcwh5gwvm3gw92phfkj9bhlzxhi9srkr7";
  };

  buildInputs = [ gettext ];

  preConfigure = ''
    export PATH_CP=$(type -tp cp)
    export PATH_CHKCONFIG=/no-such-program
    makeFlagsArray=(SA_DIR=$out/var/log/sa SYSCONFIG_DIR=$out/etc CHOWN=true IGNORE_MAN_GROUP=y)
  '';

  meta = {
    homepage = http://sebastien.godard.pagesperso-orange.fr/;
    description = "A collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
