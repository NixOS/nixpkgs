{stdenv, fetchurl, apacheAnt, jdk, axis2, dbus_java}:

stdenv.mkDerivation {
  name = "DisnixWebService-0.2";
  src = fetchurl {
    url = http://hydra.nixos.org/build/792274/download/3/DisnixWebService-0.2.tar.bz2;
    sha256 = "1ccgrab896cs7bg5m99iam4cyvdj9q3gkmjkg9awqb710l9168sh";
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
