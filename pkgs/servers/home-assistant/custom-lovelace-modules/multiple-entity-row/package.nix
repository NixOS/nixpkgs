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
  version = "4.10.1";

  src = fetchFromGitHub {
    owner = "benct";
    repo = "lovelace-multiple-entity-row";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6fZpiqQyya0I8GOw5EHGlkXXZ/j1cuKDXlYu7GQBtWE=";
  };

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-LuXzfRV/jXe4jt9whkHRjAUxvLyhzikQ3WoXzpTQWe0=";
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
