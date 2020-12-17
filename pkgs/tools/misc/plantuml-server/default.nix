{ stdenv, fetchFromGitHub, maven, jdk }:

let
  version = "1.2020.14";

  src = fetchFromGitHub {
    owner = "plantuml";
    repo = "plantuml-server";
    rev = "v${version}";
    sha256 = "08g6ddpkly5yhjhw7gpsanyspar1752jy9cypwxsqrdzqrv738b8";
  };

  # perform fake build to make a fixed-output derivation out of the files downloaded from maven central
  deps = stdenv.mkDerivation {
    name = "plantuml-server-${version}-deps";
    inherit src;
    buildInputs = [ jdk maven ];
    buildPhase = ''
      while mvn package -Dmaven.repo.local=$out/.m2; [ $? = 1 ]; do
        echo "timeout, restart maven to continue downloading"
      done
    '';
    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete'';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "1wwgyjalhlj5azggs9vvsrr54pg7gl8p36pgf6pk12rsszzl7a97";
  };
in

stdenv.mkDerivation rec {
  pname = "plantuml-server";
  inherit version;
  inherit src;

  buildInputs = [ jdk maven ];

  buildPhase = ''
    # 'maven.repo.local' must be writable so copy it out of nix store
    cp -R $src repo
    chmod +w -R repo
    cd repo
    mvn package --offline -Dmaven.repo.local=$(cp -dpR ${deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2
  '';

  installPhase = ''
    mkdir -p "$out/webapps"
    cp "target/plantuml.war" "$out/webapps/plantuml.war"
  '';

  meta = with stdenv.lib; {
    description = "A web application to generate UML diagrams on-the-fly.";
    homepage = "https://plantuml.com/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ truh ];
  };
}
