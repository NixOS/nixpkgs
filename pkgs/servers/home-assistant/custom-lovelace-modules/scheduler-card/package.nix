{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "scheduler-card";
  version = "4.0.14";

  src = fetchFromGitHub {
    owner = "nielsfaber";
    repo = "scheduler-card";
    tag = "v${version}";
    hash = "sha256-cW46bxD50p1kkCP729GsUDMO+iLkXJcil3lNgjrCsh0=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-UvErPy3jgbaGBZnqix6fm8BhZp1he0z5JJj8kzE+Sbc=";

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
