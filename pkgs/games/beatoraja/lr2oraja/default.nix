{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  ant,
  stripJavaArchivesHook,
  jdk,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lr2oraja";

  version = "11611350155";

  src = fetchFromGitHub {
    owner = "wcko87";
    repo = "lr2oraja";
    tag = "build${finalAttrs.version}";
    hash = "sha256-an7SEp4m0dyfI9iiZU/Tw4cVu2hkVxG9O4YIyF2vBhg=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=build(\\d+)" ];
    attrPath = "lr2oraja.unwrapped";
  };

  meta = {
    description = "beatoraja but compiled using LR2 judges and gauges";
    homepage = "https://github.com/exch-bms2/beatoraja";
    changelog = "https://github.com/wcko87/lr2oraja/releases/tag/${finalAttrs.src.tag}";
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
