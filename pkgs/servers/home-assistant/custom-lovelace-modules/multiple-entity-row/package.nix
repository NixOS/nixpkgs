{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
}:

mkYarnPackage rec {
  pname = "multiple-entity-row";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "benct";
    repo = "lovelace-multiple-entity-row";
    rev = "v${version}";
    hash = "sha256-CXRgXyH1NUg7ssQhenqP0tXr1m2qOkHna3Rf30K3SjI=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-8YIcQhbYf0e2xO620zVHEk/0sssBmzF/jCq+2za+D6E=";
  };

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 ./deps/multiple-entity-row/multiple-entity-row.js $out

    runHook postInstall
  '';

  doDist = false;

  meta = with lib; {
    description = "Show multiple entity states and attributes on entity rows in Home Assistant's Lovelace UI";
    homepage = "https://github.com/benct/lovelace-multiple-entity-row";
    changelog = "https://github.com/benct/lovelace-multiple-entity-row/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
