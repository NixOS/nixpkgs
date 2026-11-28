{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "windrose-card";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "aukedejong";
    repo = "lovelace-windrose-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0g4YU6xdAUuzNygojS5As9HAvKHF5gQkdB0jUu4Qq8Y=";
  };

  npmDepsHash = "sha256-lqp6U4HY/oHuiJnd5b7bULmBApij003YY5Pse9d6CI4=";

  npmBuildScript = "esbuild";

  doCheck = true;

  # the `test` script is a placeholder, run jest directly
  checkPhase = ''
    runHook preCheck

    # FullTimeMatcher tests were not updated for the v2.0.0 rewrite of the matcher
    npx jest --testPathIgnorePatterns FullTimeMatcher

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/windrose-card.js $out/windrose-card.js

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Home Assistant Lovelace card showing wind speed and direction in a windrose diagram";
    homepage = "https://github.com/aukedejong/lovelace-windrose-card";
    changelog = "https://github.com/aukedejong/lovelace-windrose-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
