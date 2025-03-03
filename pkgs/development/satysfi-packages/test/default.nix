{
  lib,
  stdenv,
  fetchFromGitHub,
  satyrographosInstallHook,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "satysfi-test";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "zeptometer";
    repo = "satysfi-test";
    tag = finalAttrs.version;
    hash = "sha256-pA2lwAnmGyfa1Q2k906S3WXMOSxMCaU1G1Bq+LMDyUg=";
  };

  dontBuild = true;
  dontUnpack = true;

  nativeBuildInputs = [ satyrographosInstallHook ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/satysfi
    satyrographosInstallHook $src $out/share/satysfi
    runHook postInstall
  '';

  meta = {
    description = "Write tests for SATySFi code";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ momeemt ];
  };
})
