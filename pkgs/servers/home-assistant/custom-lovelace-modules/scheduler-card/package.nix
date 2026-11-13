{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "scheduler-card";
  version = "4.0.20";

  src = fetchFromGitHub {
    owner = "nielsfaber";
    repo = "scheduler-card";
    tag = "v${version}";
    hash = "sha256-jiluTfuiAjd0W6rsERiNNxId/lB89VKsAW7nxa6JQCw=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    substituteInPlace package.json \
      --replace-fail '"rollup-plugin-visualizer": "^5.12.0"' '"rollup-plugin-visualizer": "^5.12.0", "tslib": "^2.8.1"'
  '';

  npmDepsHash = "sha256-IGzm0SW6741g0++whtRcZ+yoqw5xxZ2559mcg6p3pLA=";

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
    license = licenses.asl20;
  };
}
