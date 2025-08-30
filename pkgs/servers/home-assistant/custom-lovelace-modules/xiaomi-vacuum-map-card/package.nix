{
  lib,
  runCommand,
  jq,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "xiaomi-vacuum-map-card";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "lovelace-xiaomi-vacuum-map-card";
    rev = "v${version}";
    hash = "sha256-VBcTcj7SNULusChDAGqheCPkEmpqWDaBt2blCvBVkCc=";
  };

  # The version used upstream is oudated and does not work with our newer nodejs versions.
  patchedPackageJSON = runCommand "package.json" { } ''
    ${lib.getExe jq} '.devDependencies."rollup-plugin-typescript2" = "^0.36.0"' ${src}/package.json > $out
  '';

  postPatch = ''
    cp ${patchedPackageJSON} ./package.json
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-Wr3/8wOpcO/e51C8352O8U4PT73CzXjyTISk1JwkeaU=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/xiaomi-vacuum-map-card.js $out

    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      This card provides a user-friendly way to fully control map-based vacuums in Home Assistant.
      Supported brands include Xiaomi (Roborock/Viomi/Dreame/Roidmi/Valetudo/Valetudo RE), Neato, Wyze, Roomba, Ecovacs (and probably more).
    '';
    homepage = "https://github.com/PiotrMachowski/lovelace-xiaomi-vacuum-map-card";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    platforms = platforms.all;
  };
}
