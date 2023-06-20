{ lib, stdenv, fetchFromGitHub
, jdk, maven
, makeWrapper
}:

let
  platform =
    if stdenv.isLinux then "linux"
    else if stdenv.isDarwin then "mac"
    else if stdenv.isWindows then "windows"
    else throw "unsupported platform";
in
maven.buildMavenPackage rec {
  pname = "java-language-server";
  version = "0.2.38";

  src = fetchFromGitHub {
    owner = "georgewfraser";
    repo = pname;
    # commit hash is used as owner sometimes forgets to set tags. See https://github.com/georgewfraser/java-language-server/issues/104
    rev = "1dfdc54d1f1e57646a0ec9c0b3f4a4f094bd9f17";
    sha256 = "sha256-zkbl/SLg09XK2ZhJNzWEtvFCQBRQ62273M/2+4HV1Lk=";
  };

  mvnFetchExtraArgs.dontConfigure = true;
  mvnParameters = "-DskipTests";
  mvnHash = "sha256-bzYBSrCS9Kp+qnVO60h915Or1VWabphwLEu6lcBULuc=";

  nativeBuildInputs = [ maven jdk makeWrapper ];

  dontConfigure = true;
  preBuild = ''
    jlink \
      ${lib.optionalString (!stdenv.isDarwin) "--module-path './jdks/${platform}/jdk-13/jmods'"} \
      --add-modules java.base,java.compiler,java.logging,java.sql,java.xml,jdk.compiler,jdk.jdi,jdk.unsupported,jdk.zipfs \
      --output dist/${platform} \
      --no-header-files \
      --no-man-pages \
      --compress 2
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java/java-language-server
    cp -r dist/classpath dist/*${platform}* $out/share/java/java-language-server

    # a link is not used as lang_server_${platform}.sh makes use of "dirname $0" to access other files
    makeWrapper $out/share/java/java-language-server/lang_server_${platform}.sh $out/bin/java-language-server

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Java language server based on v3.0 of the protocol and implemented using the Java compiler API";
    homepage = "https://github.com/georgewfraser/java-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ hqurve ];
    platforms = platforms.all;
  };
}
