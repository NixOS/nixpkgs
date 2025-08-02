{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
}:

let
  # TODO: remove once <https://github.com/rianadon/opensprinkler-card/pull/27> has landed.
  packageLockJson = fetchurl {
    url = "https://raw.githubusercontent.com/rianadon/opensprinkler-card/8fa77b10f48ccb3b4dba30bd44976518d5c3d945/package-lock.json";
    hash = "sha256-qAnH+u0FMiZFAQFs+ATkMTM73A5Crf3/o/1J6WCbgLY=";
  };
in
buildNpmPackage (finalAttrs: {
  pname = "opensprinkler-card";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "rianadon";
    repo = "opensprinkler-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zOyElj/6XVsFY+z9aNWdJQZQ1KB6uwS2x+YhiBTT3tU=";
  };

  postPatch = ''
    ln -sf ${packageLockJson} package-lock.json
  '';

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
