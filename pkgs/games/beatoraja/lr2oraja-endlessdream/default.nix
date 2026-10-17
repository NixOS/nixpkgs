{
  lib,
  stdenvNoCC,
  gradle,
  fetchFromGitHub,
  nix-update-script,
}:

# TODO: Endless Dream seems to have some audio issues with OpenAL, but PortAudio still works (tested with PipeWire).

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lr2oraja-endlessdream";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "seraxis";
    repo = "lr2oraja-endlessdream";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Ugvbq/1nvzDp3pPpFJyuXHuonvrdmrbZUHE8K0aqB4c=";
  };

  postPatch = ''
    # support jdk newer than 17
    substituteInPlace core/build.gradle.kts --replace-fail 'languageVersion.set(JavaLanguageVersion.of(17))' ""
  '';

  nativeBuildInputs = [ gradle ];

  gradleFlags = [
    "-Dplatform=${if stdenvNoCC.hostPlatform.isDarwin then "macos" else "linux"}"
    "-Darch=${if stdenvNoCC.hostPlatform.isAarch64 then "aarch64" else "x86-64"}"
  ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  gradleBuildTask = "core:shadowJar";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/beatoraja
    install -Dm644 dist/lr2oraja-*.jar $out/share/beatoraja/beatoraja.jar
    cp -ar assets/{folder,skin,defaultsound,font,random} $out/share/beatoraja

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v(\\d+\\.\\d+\\.\\d+)" ];
    attrPath = "lr2oraja-endlessdream.unwrapped";
  };

  meta = {
    description = "Fork of beatoraja with new features, based on LR2oraja";
    homepage = "https://github.com/seraxis/lr2oraja-endlessdream";
    changelog = "https://github.com/seraxis/lr2oraja-endlessdream/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
      binaryNativeCode
    ];
  };
})
