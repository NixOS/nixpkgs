{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, wrapGAppsHook
, jre
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mcaselector";
  version = "2.2.2";

  src = fetchurl {
    url = "https://github.com/Querz/mcaselector/releases/download/${finalAttrs.version}/mcaselector-${finalAttrs.version}.jar";
    hash = "sha256-tOSdzLFxvEJ9LXliwfosMkgcrQLsrW7qDS8vrgPzQoI=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ jre makeWrapper wrapGAppsHook ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/mcaselector}
    cp $src $out/lib/mcaselector/mcaselector.jar
    makeWrapper ${jre}/bin/java $out/bin/mcaselector \
      --add-flags "-jar $out/lib/mcaselector/mcaselector.jar" \
      ''${gappsWrapperArgs[@]}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Querz/mcaselector";
    description = "A tool to select chunks from Minecraft worlds for deletion or export";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = [ maintainers.Scrumplex ];
    platforms = platforms.linux;
  };
})
