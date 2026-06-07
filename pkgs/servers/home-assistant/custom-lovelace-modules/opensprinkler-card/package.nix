{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
}:

buildNpmPackage (finalAttrs: {
  pname = "opensprinkler-card";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "rianadon";
    repo = "opensprinkler-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ds5x/Ktughi1/jO3mSo0yALJoD+okl4W68EYlHqsMEg=";
  };

  makeCacheWritable = true;

  npmDepsHash = "sha256-6zze/SzgZGaFOtGO/aEzX3JO+NdAI1H6nVuvILE74HI=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 dist/opensprinkler-card.js $out

    runHook postInstall
  '';

  meta = {
    description = "Home Assistant card for collecting OpenSprinkler status";
    homepage = "https://github.com/rianadon/opensprinkler-card";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jfly ];
  };
})
