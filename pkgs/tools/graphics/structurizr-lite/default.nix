{ stdenv
, fetchurl
, lib
, makeWrapper
, jre
, graphviz
}:
stdenv.mkDerivation rec {
  pname = "structurizr-lite";
  version = "2024.03.03";

  src = fetchurl {
    url = "https://github.com/structurizr/lite/releases/download/v${version}/${pname}.war";
    hash = "sha256-rLqMj+tYPxYE86Wp07w2/QTSTn2XrwGT73MKrGiHE+o=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
  
    mkdir -p $out/bin

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
        --prefix PATH : ${lib.makeBinPath [ graphviz ]} \
        --add-flags "-Djdk.util.jar.enableMultiRelease=false" \
        --add-flags "-jar $src"
        
    runHook postInstall
  '';

  meta = with lib; {
    description = "Structurizr builds upon “diagrams as code”, allowing you to create multiple software architecture diagrams, in a variety of rendering tools, from a single model.";
    homepage = "https://github.com/structurizr/lite";
    license = licenses.mit;
    maintainers = with maintainers; [ deemp ];
    mainProgram = pname;
  };
}
