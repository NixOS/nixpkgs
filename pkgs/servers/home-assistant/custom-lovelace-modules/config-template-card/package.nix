{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "config-template-card";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "iantrich";
    repo = "config-template-card";
    tag = finalAttrs.version;
    hash = "sha256-Vly812iOkER7XUDcAYgxCipfX/j4slVUaX+QFqZSobA=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-xXU/0od1FTge40S4slwL1gpTKrH0Y/JgcUP+kvcon8o=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
  ];

  # rollup-plugin-typescript2 tries to require tslib/package.json, but the bundled tslib 2.1.0 uses the legacy "./": "./" exports subpath pattern,
  # which newer Node no longer honours. Rewrite it to the supported wildcard form.
  preBuild = ''
    substituteInPlace node_modules/rollup-plugin-typescript2/node_modules/tslib/package.json \
      --replace-fail '"./": "./"' '"./*": "./*"'
  '';

  # `build` also runs eslint
  yarnBuildScript = "rollup";

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/config-template-card.js $out/config-template-card.js

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Templatable Lovelace configurations";
    homepage = "https://github.com/iantrich/config-template-card";
    changelog = "https://github.com/iantrich/config-template-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
