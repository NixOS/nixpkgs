{ lib
, stdenv
, fetchzip
, jre
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "schemacrawler";
  version = "16.20.4";

  src = fetchzip {
    url = "https://github.com/schemacrawler/SchemaCrawler/releases/download/v${finalAttrs.version}/schemacrawler-${finalAttrs.version}-bin.zip";
    hash = "sha256-wNvFutxB34gjBCwVPIj/5jjjk0/IjH0EbD++FxxuweM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r {config,lib} $out/

    makeWrapper ${jre}/bin/java $out/bin/schemacrawler \
      --add-flags "-cp $out/lib/*:$out/config" \
      --add-flags schemacrawler.Main

    runHook postInstall
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "Database schema discovery and comprehension tool";
    homepage = "https://www.schemacrawler.com/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = with licenses; [ epl10 gpl3Only lgpl3Only ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ elohmeier ];
  };
})
