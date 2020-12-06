{stdenv, fetchurl, apacheAnt, jdk, axis2, dbus_java }:

stdenv.mkDerivation {
  name = "DisnixWebService-0.10";
  src = fetchurl {
    url = "https://github.com/svanderburg/DisnixWebService/releases/download/DisnixWebService-0.10/DisnixWebService-0.10.tar.gz";
    sha256 = "0m451msd127ay09yb8rbflg68szm8s4hh65j99f7s3mz375vc114";
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
