{stdenv, fetchurl, apacheAnt, jdk, axis2, dbus_java }:

stdenv.mkDerivation {
  name = "DisnixWebService-0.9";
  src = fetchurl {
    url = "https://github.com/svanderburg/DisnixWebService/releases/download/DisnixWebService-0.9/DisnixWebService-0.9.tar.gz";
    sha256 = "1z7w44bf023c0aqchjfi4mla3qbhsh87mdzx7pqn0sy74cjfgqvl";
  };
  buildInputs = [ apacheAnt jdk ];
  PREFIX = ''''${env.out}'';
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  DBUS_JAVA_LIB = "${dbus_java}/share/java";
  prePatch = ''
    sed -i -e "s|#JAVA_HOME=|JAVA_HOME=${jdk}|" \
       -e "s|#AXIS2_LIB=|AXIS2_LIB=${axis2}/lib|" \
        scripts/disnix-soap-client
  '';
  buildPhase = "ant";
  installPhase = "ant install";
  
  meta = {
    description = "A SOAP interface and client for Disnix";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.linux;
  };
}
