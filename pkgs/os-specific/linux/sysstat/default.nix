{stdenv, fetchurl, gettext}:
   
stdenv.mkDerivation {
  name = "sysstat-8.0.4.1";
   
  src = fetchurl {
    url = http://perso.orange.fr/sebastien.godard/sysstat-8.0.4.1.tar.bz2;
    sha256 = "17bzyz6bp63br4pns40ypc0qac0299lh90p7fhis5sn31sx811rf";
  };

  buildInputs = [gettext];

  preConfigure = ''
    export PATH_CP=$(type -tp cp)
    export PATH_CHKCONFIG=/no-such-program
    makeFlagsArray=(SA_DIR=$out/var/log/sa SYSCONFIG_DIR=$out/etc CHOWN=true IGNORE_MAN_GROUP=y)
  '';
}
