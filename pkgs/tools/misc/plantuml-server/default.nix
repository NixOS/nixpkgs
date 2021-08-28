{ lib, stdenv, fetchFromGitHub, maven, jdk8_headless }:

let
  version = "1.2021.6";

  src = fetchFromGitHub {
    owner = "plantuml";
    repo = "plantuml-server";
    rev = "v${version}";
    sha256 = "sha256:1v69vabdq9pv75wzb6n5s198iy5ijfcx6lgjqwxz7n5ns3blf6sz";
  };

  # perform fake build to make a fixed-output derivation out of the files downloaded from maven central
  deps = stdenv.mkDerivation {
    name = "plantuml-server-${version}-deps";
    inherit src;
    nativeBuildInputs = [ jdk8_headless maven ];
    buildPhase = ''
      runHook preBuild

      while mvn package -Dmaven.repo.local=$out/.m2; [ $? = 1 ]; do
        echo "timeout, restart maven to continue downloading"
      done

      runHook postBuild
    '';
    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete'';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256:1fvir7yvg4a4dc4kiv2d5q081cygj7s2lmxj90j8zzkggyq7v8zh";
  };
in

stdenv.mkDerivation rec {
  pname = "plantuml-server";
  inherit version;
  inherit src;

  nativeBuildInputs = [ jdk8_headless maven ];

  buildPhase = ''
    runHook preBuild

    # 'maven.repo.local' must be writable so copy it out of nix store
    cp -R $src repo
    chmod +w -R repo
    cd repo
    mvn package --offline -Dmaven.repo.local=$(cp -dpR ${deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/webapps"
    cp "target/plantuml.war" "$out/webapps/plantuml.war"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A web application to generate UML diagrams on-the-fly.";
    homepage = "https://plantuml.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ truh ];
  };
}
