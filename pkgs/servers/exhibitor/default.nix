{ fetchFromGitHub, fetchMavenDeps, maven, jdk, makeWrapper, stdenv, ... }:
stdenv.mkDerivation rec {
  pname = "exhibitor";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "soabase";
    repo = "exhibitor";
    sha256 = "07vikhkldxy51jbpy3jgva6wz75jksch6bjd6dqkagfgqd6baw45";
    rev = "5fcdb411d06e8638c2380f7acb72a8a6909739cd";
  };

  fetchedMavenDeps = fetchMavenDeps {
    inherit pname version src nativeBuildInputs;
    configurePhase = "cd ${pomFileDir}";
    sha256 = "00r69n9hwvrn5cbhxklx7w00sjmqvcxs7gvhbm150ggy7bc865qv";
  };

  # The purpose of this is to fetch the jar file out of public Maven and use Maven
  # to build a monolithic, standalone jar, rather than build everything from source
  # (given the state of Maven support in Nix). We're not actually building any java
  # source here.
  pomFileDir = "exhibitor-standalone/src/main/resources/buildscripts/standalone/maven";
  nativeBuildInputs = [ maven ];
  buildInputs = [ makeWrapper ];
  buildPhase = ''
      cd ${pomFileDir}
      mvn package --offline -Dmaven.repo.local=$(cp -dpR ${fetchedMavenDeps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2
  '';
  meta = with stdenv.lib; {
    homepage = https://github.com/soabase/exhibitor;
    description = "ZooKeeper co-process for instance monitoring, backup/recovery, cleanup and visualization";
    license = licenses.asl20;
    platforms = platforms.unix;
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java
    mv target/$name.jar $out/share/java/
    makeWrapper ${jdk}/bin/java $out/bin/startExhibitor.sh --add-flags "-jar $out/share/java/$name.jar" --suffix PATH : ${stdenv.lib.makeBinPath [ jdk ]}
  '';

}
