{ stdenv
, fetchFromGitHub
, lib
, maven
, jdk11
, protobuf
}:

let
  pname = "hugegraph-unwrapped";
  version = "1.0.0";
  hash = "sha256-NXO/4z1/smKDtJ54LWMUBYAaeQSo9DLE5muZ/nEglvw=";
  outputHash = "sha256-5b2tH7JV+GZBVhR4hPGhBcffJph3P5djbo9zz/Mx4hc=";
  swaggerUiVersion = "4.15.5";
  fetchedMavenDeps = { pname, src, version, ... }: stdenv.mkDerivation {
    pname = "${pname}-maven-deps";
    inherit src version;

    nativeBuildInputs = [
      (maven.override { jdk = jdk11; })
      jdk11
      protobuf
    ];

    postPatch = ''
      sed -i 's|<protocArtifact>.*</protocArtifact>|<protocExecutable>${protobuf}/bin/protoc</protocExecutable>|g' hugegraph-core/pom.xml
      sed -i '/wget /d' hugegraph-dist/pom.xml
      sed -i '/tar zxvf /d' hugegraph-dist/pom.xml
      cp -r ${fetchFromGitHub {
        owner = "swagger-api";
        repo = "swagger-ui";
        rev = "v${swaggerUiVersion}";
        hash = "sha256-cadQhmgOdIGhuH2YCN+6D00KN4vfXrAE1PeyUsC0ppw=";
      }} hugegraph-dist/swagger-ui-${swaggerUiVersion}
      chmod +w -R hugegraph-dist/swagger-ui-${swaggerUiVersion}
    '';

    buildPhase = ''
      runHook preBuild
      mvn package -Dmaven.repo.local=$out -DskipTests
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      find $out -type f \
        -name \*.lastUpdated -or \
        -name resolver-status.properties -or \
        -name _remote.repositories \
        -delete
      runHook postInstall
    '';

    dontFixup = true;
    dontConfigure = true;
    outputHashMode = "recursive";
    inherit outputHash;
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-hugegraph";
    rev = "${version}";
    inherit hash;
  };
  fetchedMavenDeps = fetchedMavenDeps finalAttrs;

  inherit (finalAttrs.fetchedMavenDeps) nativeBuildInputs postPatch;

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    mvn package --offline -Dmaven.repo.local=${finalAttrs.fetchedMavenDeps} -DskipTests
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # we don't know what the name of the bin directory is:
    #  - when using a binary release, it will be 'hugegraph-<version>'
    #  - when built from unstable source code, it will be 'apache-hugegraph-incubating-<version>'
    mv $(ls -d *hugegraph*/bin | xargs dirname | head -n1) $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "A graph database with high performance and scalability";
    homepage = "https://hugegraph.apache.org/";
    mainProgram = "hugegraph-server";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.ners ];
  };
})
