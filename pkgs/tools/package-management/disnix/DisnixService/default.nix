{stdenv, fetchurl, apacheAnt, jdk, axis2, dbus_java}:

stdenv.mkDerivation {
  name = "DisnixService-0.1";
  src = fetchurl {
    url = http://hydra.nixos.org/build/337920/download/1/DisnixService-0.1.tar.bz2;
    sha256 = "18526dh5axmicbahwma2m71hw7j0nkxmmhgl4kd76r61wdiiblx7";
  };
  buildInputs = [ apacheAnt ];
  PREFIX = ''''${env.out}'';
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  DBUS_JAVA_LIB = "${dbus_java}/share/java";
  patchPhase = ''
    sed -i -e "s|#JAVA_HOME=|JAVA_HOME=${jdk}|" \
           -e "s|#AXIS2_LIB=|AXIS2_LIB=${axis2}/lib|" \
	   scripts/disnix-soap-client
  '';
  buildPhase = "ant";
  installPhase = "ant install";
}
