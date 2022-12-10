{ stdenv, lib, fetchFromGitHub, makeWrapper, jre, maven }:

let
  pname = "spdx-to-osv";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "spdx-to-osv";
    rev = "v${version}";
    sha256 = "tC79cIHsSyYQ5qtqmxS7352F8cpHXhdKDSb4mEIYa30=";
  };

  repository = stdenv.mkDerivation {
    name = "${pname}-${version}-repository";
    inherit src;

    buildInputs = [ maven ];

    buildPhase = ''
      mvn package -Dmaven.repo.local=$out
    '';

    installPhase = ''
      find $out -type f \
        -name \*.lastUpdated -or \
        -name resolver-status.properties -or \
        -name _remote.repositories \
        -delete
    '';

    dontFixup = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-sgzt280FmPEgD3dpOM/jmjp4uh0rCOs00qstS1TExSo=";
  };
in stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ maven ];

  # Tests are requiring Internet access.
  buildPhase = ''
    mvn --offline -Dmaven.repo.local=${repository} package -Dmaven.test.skip
  '';

  installPhase = ''
    install -D \
      target/${pname}-${version}-jar-with-dependencies.jar \
      $out/share/${pname}-${version}.jar

    mkdir $out/bin
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/${pname}-${version}.jar"
  '';

  meta = with lib; {
    description = "Produce an Open Source Vulnerability JSON file based on information in an SPDX document";
    homepage = "https://github.com/spdx/spdx-to-osv";
    license = licenses.asl20;
    maintainers = with maintainers; [ oxzi ];
  };
}
