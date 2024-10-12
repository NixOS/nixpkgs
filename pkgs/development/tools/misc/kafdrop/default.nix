{ stdenv, maven, fetchFromGitHub, makeWrapper, jre, lib }:
let
  version = "3.29.0";

  src = fetchFromGitHub {
    owner = "obsidiandynamics";
    repo = "kafdrop";
    rev = "${version}";
    sha256 = "sha256-38ysop/WcV+eHJCdzryTZOdtik6vfSfS5hy5RYRfAFw=";
  };

  deps = stdenv.mkDerivation {
    name = "kafdrop-${version}-deps";
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
    outputHash = "sha256-dTPxk1CuLENJGSAN9RML0DKaRqliFpWgtFuP9XE2nHc=";
  };

in
stdenv.mkDerivation rec {
  pname = "kafdrop";
  inherit version;
  inherit src;
  buildInputs = [ maven makeWrapper ];
  buildPhase = ''
    echo "Using repository ${deps}"
    mvn --offline -Dmaven.repo.local=${deps} package;
  '';
  installPhase =''
    mkdir -p $out/bin
    mkdir -p $out/share/java
    mv target/${pname}-${version}.jar $out/share/java/
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${pname}-${version}.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/obsidiandynamics/kafdrop";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ heph2 ];
  };
}
