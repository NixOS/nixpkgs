{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  gradle,
  beatoraja,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bokutachi-ir";
  version = "3.1.1-unstable-2026-01-24";

  src = fetchFromGitHub {
    owner = "zkldi";
    repo = "tachi-beatoraja-ir";
    rev = "9726c558d9b4baa588b25cfe5ec14271f930096e";
    hash = "sha256-ccGB74SsOT74SsgAZWrCb29wvl8J5z/mnEZbJhcLIMA=";
  };

  nativeBuildInputs = [ gradle ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  preBuild = ''
    mkdir external
    ln -s ${beatoraja}/share/beatoraja/beatoraja.jar -t external

    # set env var TCHIR_HOME, TCHIR_NAME, TCHIR_BASE_URL
    source <(echo -n 'export '; sed -n 's| ./build.sh||p' bokutachi.sh)
  '';

  gradleBuildTask = "build";

  installPhase = ''
    runHook preInstall

    install -Dm644 "$(find build/libs -name 'bokutachiIR-*-all.jar' | head -n1)" $out/share/beatoraja/ir/bokutachiIR.jar

    runHook postInstall
  '';

  meta = {
    description = "Tachi Internet Ranking implementation for the LR2oraja variant of beatoraja";
    homepage = "https://github.com/zkldi/tachi-beatoraja-ir";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
