{stdenv, fetchurl, gettext}:
   
stdenv.mkDerivation {
  name = "sysstat-8.0.0";
   
  src = fetchurl {
    url = http://perso.orange.fr/sebastien.godard/sysstat-8.0.0.tar.bz2;
    md5 = "cb579d5c5d5bc1386cc09193e15765bf";
  };

  buildInputs = [gettext];

  preConfigure = "
    export PATH_CP=$(type -tp cp)
    export PATH_CHKCONFIG=/no-such-program
    makeFlagsArray=(SA_DIR=$out/var/log/sa SYSCONFIG_DIR=$out/etc CHOWN=true IGNORE_MAN_GROUP=y)
  ";
}
