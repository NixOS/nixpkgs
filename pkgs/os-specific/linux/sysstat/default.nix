{stdenv, fetchurl, gettext}:
   
stdenv.mkDerivation {
  name = "sysstat-7.1.1";
   
  src = fetchurl {
    url = file:///home/eelco/stuff/sysstat-7.1.1.tar.gz;
    sha256 = "1dmna652qj39z2cddasm5rj1wjngglima73pmfjqrzz254g0vx9w";
  };

  buildInputs = [gettext];

  preConfigure = "
    export PATH_CP=$(type -tp cp)
    export PATH_CHKCONFIG=/no-such-program
    makeFlagsArray=(SA_DIR=$out/var/log/sa SYSCONFIG_DIR=$out/etc CHOWN=true IGNORE_MAN_GROUP=y)
  ";
}
