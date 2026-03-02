{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "scheduler-card";
  version = "4.0.13";

  src = fetchFromGitHub {
    owner = "nielsfaber";
    repo = "scheduler-card";
    tag = "v${version}";
    hash = "sha256-VeuIn9C+xnfB8wSPTCHP/MxFsr1HrIUlHk186QWDXv0=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-RiCOUJlFHhMWLAXkT+nwPBnVE77cU+6s0YRbyUqpRYI=";

  npmBuildScript = "rollup";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -v dist/scheduler-card.js* $out/

    runHook postInstall
  '';

  passthru.entrypoint = "scheduler-card.js";

  meta = with lib; {
    description = "HA Lovelace card for control of scheduler entities";
    homepage = "https://github.com/nielsfaber/scheduler-card";
    changelog = "https://github.com/nielsfaber/scheduler-card/releases/tag/v${version}";
    maintainers = with maintainers; [ SuperSandro2000 ];
    license = licenses.gpl3Plus;
  };
}
