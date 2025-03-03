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

  meta = {
    description = "Write tests for SATySFi code";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ momeemt ];
  };
})
