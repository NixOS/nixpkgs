{ lib, stdenv, fetchFromGitHub, fetchpatch, ant, jdk, xmlstarlet, axis2, dbus_java }:

stdenv.mkDerivation (finalAttrs: {
  pname = "DisnixWebService";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "DisnixWebService";
    rev = "DisnixWebService-${finalAttrs.version}";
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

  nativeBuildInputs = [
    ant
    jdk
    xmlstarlet
  ];

  env = {
    PREFIX = "\${env.out}";
    AXIS2_LIB = "${axis2}/lib";
    AXIS2_WEBAPP = "${axis2}/webapps/axis2";
    DBUS_JAVA_LIB = "${dbus_java}/share/java";
  };

  prePatch = ''
    # add modificationtime="0" to the <jar> and <war> tasks to achieve reproducibility
    xmlstarlet ed -L -a "//jar|//war" -t attr -n "modificationtime" -v "0" build.xml

    sed -i -e "s|#JAVA_HOME=|JAVA_HOME=${jdk}|" \
       -e "s|#AXIS2_LIB=|AXIS2_LIB=${axis2}/lib|" \
        scripts/disnix-soap-client
  '';

  buildPhase = ''
    runHook preBuild
    ant
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ant install
    runHook postInstall
  '';

  meta = {
    description = "SOAP interface and client for Disnix";
    mainProgram = "disnix-soap-client";
    homepage = "https://github.com/svanderburg/DisnixWebService";
    changelog = "https://github.com/svanderburg/DisnixWebService/blob/${finalAttrs.src.rev}/NEWS.txt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
})
