{ lib
, stdenv
, callPackage
, maven
, jdk
, jre
, buildMaven
, makeWrapper
, git
, fetchFromGitHub
, graphviz
, ensureNewerSourcesHook
}:

let
  version = "6.1.1-SNAPSHOT";
  pname = "schemaspy";

  src = fetchFromGitHub {
    owner = "schemaspy";
    repo = "schemaspy";
    rev = "110b1614f9ae4aec0e4dc4e8f0e7c647274d3af6";
    sha256 = "sha256-X5B34zGhD/NxcK8TQvwdk1NljGJ1HwfBp47ocbE4HiU=";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-${version}-deps";
    inherit src;

    nativeBuildInputs = [ jdk maven git ];
    buildInputs = [ jre ];

    buildPhase = ''
      mvn package -Dmaven.test.skip=true -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000
    '';

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete
      find $out/.m2 -type f -iname '*.pom' -exec sed -i -e 's/\r\+$//' {} \;
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-CUFA9L6qqjo3Jp5Yy1yCqbS9QAEb9PElys4ArPa9VhA=";

    doCheck = false;
  };
in
stdenv.mkDerivation rec {
  inherit version pname src;

  buildInputs = [
    maven
  ];

  nativeBuildInputs = [
    makeWrapper
    # the build system gets angry if it doesn't see git (even though it's not
    # actually in a git repository)
    git

    # springframework boot gets angry about 1970 sources
    # fix from https://github.com/nix-community/mavenix/issues/25
    (ensureNewerSourcesHook { year = "1980"; })
  ];

  wrappedPath = lib.makeBinPath [
    graphviz
  ];

  buildPhase = ''
    VERSION=${version}
    SEMVER_STR=${version}

    mvn package --offline -Dmaven.test.skip=true -Dmaven.repo.local=$(cp -dpR ${deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2
  '';

  installPhase = ''
    install -D target/${pname}-${version}.jar $out/share/java/${pname}-${version}.jar

    makeWrapper ${jre}/bin/java $out/bin/schemaspy \
      --add-flags "-jar $out/share/java/${pname}-${version}.jar" \
      --prefix PATH : "$wrappedPath"
  '';

  meta = with lib; {
    homepage = "https://schemaspy.org";
    description = "Document your database simply and easily";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jraygauthier ];
  };
}

