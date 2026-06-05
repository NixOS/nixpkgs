{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "multiple-entity-row";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "benct";
    repo = "lovelace-multiple-entity-row";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CXRgXyH1NUg7ssQhenqP0tXr1m2qOkHna3Rf30K3SjI=";
  };

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-8YIcQhbYf0e2xO620zVHEk/0sssBmzF/jCq+2za+D6E=";
  };

  nativeBuildInputs = [
    yarnBuildHook
    yarnConfigHook
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 ./multiple-entity-row.js $out

    runHook postInstall
  '';

  meta = {
    description = "Show multiple entity states and attributes on entity rows in Home Assistant's Lovelace UI";
    homepage = "https://github.com/benct/lovelace-multiple-entity-row";
    changelog = "https://github.com/benct/lovelace-multiple-entity-row/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
