{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  ant,
  makeWrapper,
  stripJavaArchivesHook,
  jdk,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "beatoraja";

  # upstream stops tagging new releases; the actual version in the source repo is 0.8.7 as of 2025-09-29
  version = "0.7.6-unstable-2025-09-29";

  src = fetchFromGitHub {
    owner = "exch-bms2";
    repo = "beatoraja";
    rev = "17c57c39b9a714ef4b2040100bc0726a04b9ce2a";
    hash = "sha256-AvgaBSUnsZKdpca44Ke1fJ/mX6KyZhQv/RuuUYvMaic=";
  };

  nativeBuildInputs = [
    ant
    jdk
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild

    ant create_run_jar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/beatoraja
    install -Dm644 build/beatoraja.jar $out/share/beatoraja/beatoraja.jar
    cp -ar folder skin defaultsound font random $out/share/beatoraja

    # otherwise the game cannot load the font; upstream bug???
    ln -s $out/share/beatoraja/font/* -t $out/share/beatoraja/skin/default

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cross-platform rhythm game based on Java and libGDX";
    homepage = "https://github.com/exch-bms2/beatoraja";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
      binaryNativeCode
    ];
  };
})
