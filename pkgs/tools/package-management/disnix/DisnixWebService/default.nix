{stdenv, fetchurl, apacheAnt, jdk, axis2, dbus_java, fetchpatch }:

stdenv.mkDerivation {
  name = "DisnixWebService-0.8";
  src = fetchurl {
    url = https://github.com/svanderburg/DisnixWebService/files/1756703/DisnixWebService-0.8.tar.gz;
    sha256 = "05hmyz17rmqlph0i321kmhabnpw84kqz32lgc5cd4shxyzsal9hz";
  };
  buildInputs = [ apacheAnt jdk ];
  PREFIX = ''''${env.out}'';
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  DBUS_JAVA_LIB = "${dbus_java}/share/java";
  patches = [
    # Safe to remove once https://github.com/svanderburg/DisnixWebService/pull/1 is merged
    (fetchpatch {
      url = "https://github.com/mmahut/DisnixWebService/commit/cf07918b8c81b4ce01e0b489c1b5a3ef9c9a1cd6.patch";
      sha256 = "15zi1l69wzgwvvqx4492s7l444gfvc9vcm7ckgif4b6cvp837brn";
    })
  ];
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
