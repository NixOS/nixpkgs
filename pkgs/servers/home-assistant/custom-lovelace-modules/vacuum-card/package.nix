{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "vacuum-card";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = "vacuum-card";
    rev = "v${version}";
    hash = "sha256-AkwtKh24a2zOkP3MyqxSPbzYWujwj6nIcMyUWMgcdeM=";
  };

  npmDepsHash = "sha256-/kUed3z6eqiLy9klErmEx3yvOO1jlmlKu2F8aPbFOek=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/vacuum-card.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "vacuum-card.js";

  meta = {
    description = "Vacuum cleaner card for Home Assistant Lovelace UI";
    homepage = "https://github.com/denysdovhan/vacuum-card";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ baksa ];
    platforms = lib.platforms.all;
  };
}
