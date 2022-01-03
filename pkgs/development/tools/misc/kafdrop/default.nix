{ stdenv, maven, fetchgit, makeWrapper, jre, lib }:
let
  version = "3.28.0";

  src = fetchgit {
    url = "https://github.com/obsidiandynamics/kafdrop.git";
    rev = "d2f0bf10cce8e842dab7b8bcca27ac00b2752abb";
    sha256 = "0jnkkchc2hqvsn7hhq9ayhnbl8wqby9mhmr7yrxakddy2rlwbgh1";
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
    outputHash = "sha256-X67wCwxC1Z7H+vDUKPsjx8PGSm7O5JVA7/f9tvKobyA=";
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
    mv target/${pname}-${version}-SNAPSHOT.jar $out/share/java/           
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
        --add-flags "-jar $out/share/java/${pname}-${version}-SNAPSHOT.jar"
                '';

  meta = with lib; {
    homepage = "https://github.com/obsidiandynamics/kafdrop";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ heph2 ];
  };
}
