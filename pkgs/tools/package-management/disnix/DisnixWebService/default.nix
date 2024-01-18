{lib, stdenv, fetchFromGitHub, fetchpatch, apacheAnt, jdk, axis2, dbus_java }:

stdenv.mkDerivation rec {
  pname = "DisnixWebService";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "DisnixWebService";
    rev = "refs/tags/DisnixWebService-${version}";
    hash = "sha256-zcYr2Ytx4pevSthTQLpnQ330wDxN9dWsZA20jbO6PxQ=";
  };

  patches = [
    # Correct the DisnixWebService build for compatibility with Axis2 1.8.1
    # See https://github.com/svanderburg/DisnixWebService/pull/2
    (fetchpatch {
      url = "https://github.com/svanderburg/DisnixWebService/commit/cee99c6af744b5dda16728a70ebd2800f61871a0.patch";
      hash = "sha256-4rSEN8AwivUXUCIUYFBRIoE19jVDv+Vpgakmy8fR06A=";
    })
  ];

  buildInputs = [ apacheAnt jdk ];
  PREFIX = "\${env.out}";
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
    homepage = "https://github.com/svanderburg/DisnixWebService";
    changelog = "https://github.com/svanderburg/DisnixWebService/blob/DisnixWebService-${version}/NEWS.txt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
