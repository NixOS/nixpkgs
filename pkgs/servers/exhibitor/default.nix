{ fetchFromGitHub, maven, jdk, makeWrapper, lib, stdenv, ... }:
stdenv.mkDerivation rec {
  pname = "exhibitor";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "soabase";
    repo = "exhibitor";
    sha256 = "07vikhkldxy51jbpy3jgva6wz75jksch6bjd6dqkagfgqd6baw45";
    rev = "5fcdb411d06e8638c2380f7acb72a8a6909739cd";
  };
  mavenDependenciesSha256 = "00r69n9hwvrn5cbhxklx7w00sjmqvcxs7gvhbm150ggy7bc865qv";
  # This is adapted from https://github.com/volth/nixpkgs/blob/6aa470dfd57cae46758b62010a93c5ff115215d7/pkgs/applications/networking/cluster/hadoop/default.nix#L20-L32
  fetchedMavenDeps = stdenv.mkDerivation {
    name = "exhibitor-${version}-maven-deps";
    inherit src nativeBuildInputs;
    buildPhase = ''
      cd ${pomFileDir};
      while timeout --kill-after=21m 20m mvn package -Dmaven.repo.local=$out/.m2; [ $? = 124 ]; do
        echo "maven hangs while downloading :("
      done
    '';
    installPhase = ''find $out/.m2 -type f \! -regex '.+\(pom\|jar\|xml\|sha1\)' -delete''; # delete files with lastModified timestamps inside
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = mavenDependenciesSha256;
  };

  # The purpose of this is to fetch the jar file out of public Maven and use Maven
  # to build a monolithic, standalone jar, rather than build everything from source
  # (given the state of Maven support in Nix). We're not actually building any java
  # source here.
  pomFileDir = "exhibitor-standalone/src/main/resources/buildscripts/standalone/maven";
  nativeBuildInputs = [ maven makeWrapper ];
  buildPhase = ''
      cd ${pomFileDir}
      mvn package --offline -Dmaven.repo.local=$(cp -dpR ${fetchedMavenDeps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2
  '';
  meta = with lib; {
    description = "ZooKeeper co-process for instance monitoring, backup/recovery, cleanup and visualization";
    homepage = "https://github.com/soabase/exhibitor";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    mainProgram = "startExhibitor.sh";
    platforms = platforms.unix;
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java
    mv target/$name.jar $out/share/java/
    makeWrapper ${jdk}/bin/java $out/bin/startExhibitor.sh --add-flags "-jar $out/share/java/$name.jar" --suffix PATH : ${lib.makeBinPath [ jdk ]}
  '';

}
