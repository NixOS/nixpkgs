{ lib, fetchFromGitHub, maven, makeWrapper, jdk }:

maven.buildMavenPackage rec {
  pname = "exhibitor";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "soabase";
    repo = "exhibitor";
    rev = "v${version}";
    hash = "sha256-PZRT2C4CfYCbaHE9tEnwpyzEsJ6ZaS//zUDweR4YKrI=";
  };

  # The purpose of this is to fetch the jar file out of public Maven and use Maven
  # to build a monolithic, standalone jar, rather than build everything from source
  # (given the state of Maven support in Nix). We're not actually building any java
  # source here.
  sourceRoot = "source/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven";
  mvnFetchExtraArgs = {
    inherit sourceRoot;
  };
  mvnHash = "sha256-xhLnjtaF5eFUuBo5aHdp0j2sPfxYhFEZYJwVQlkqARs=";

  nativeBuildInputs = [ maven makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java
    filename=$(basename target/*.jar)
    mv target/$filename $out/share/java/
    makeWrapper ${jdk}/bin/java $out/bin/startExhibitor.sh --add-flags "-jar $out/share/java/$filename" --suffix PATH : ${lib.makeBinPath [ jdk ]}
  '';

  meta = with lib; {
    description = "ZooKeeper co-process for instance monitoring, backup/recovery, cleanup and visualization";
    homepage = "https://github.com/soabase/exhibitor";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    mainProgram = "startExhibitor.sh";
    platforms = platforms.unix;
  };
}
