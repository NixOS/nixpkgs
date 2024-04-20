{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, jre
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mcaselector";
  version = "2.3";

  src = fetchurl {
    url = "https://github.com/Querz/mcaselector/releases/download/${finalAttrs.version}/mcaselector-${finalAttrs.version}.jar";
    hash = "sha256-8ivqTqgO6hvEgwnAfnPXuruFGS3s/wD/WKt+5Bg/5Z0=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ jre makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/mcaselector}
    cp $src $out/lib/mcaselector/mcaselector.jar
    makeWrapper ${jre}/bin/java $out/bin/mcaselector \
      --add-flags "-jar $out/lib/mcaselector/mcaselector.jar"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Querz/mcaselector";
    description = "A tool to select chunks from Minecraft worlds for deletion or export";
    mainProgram = "mcaselector";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = [ maintainers.Scrumplex ];
    platforms = platforms.linux;
  };
})
