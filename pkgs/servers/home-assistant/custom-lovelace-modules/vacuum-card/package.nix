{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "vacuum-card";
  version = "2.11.6";

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = "vacuum-card";
    rev = "v${version}";
    hash = "sha256-RBKg92QpfPcrvP1TDOPM8PfjS3NyHwl4By36o4B8yUE=";
  };

  npmDepsHash = "sha256-/M9TRM/wYN0jHigCoE9UVFspxGh5bpCrZvzo42DXgLo=";

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
