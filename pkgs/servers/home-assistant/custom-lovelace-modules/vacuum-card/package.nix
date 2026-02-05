{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "vacuum-card";
  version = "2.11.7";

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = "vacuum-card";
    rev = "v${version}";
    hash = "sha256-qlAgkEMEwTq9vc6DoOwf5AhdlS2ezyXxjZQEhkhdrBs=";
  };

  npmDepsHash = "sha256-+vNnManvjv8suqgbsj/XnoDLLGyUGjBLsUUDrDKPXqY=";

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
