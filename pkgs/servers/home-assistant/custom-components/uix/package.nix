{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  nix-update-script,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "Lint-Free-Technology";
  domain = "uix";
  version = "8.4.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "uix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+JRkonJeBBY7O9rSG/HQK1+HU1lktSvUuWYWyvSv1yo=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "uix-${finalAttrs.version}-npm-deps";
    hash = "sha256-lWJiCetV3oJz9EsZ7a7pFsOXdZKKOTfHyoh5emhaHK0=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  # drop the prebuilt bundles checked into the repo, so the build regenerates them
  postPatch = ''
    rm custom_components/uix/*.js custom_components/uix/*.js.gz
  '';

  buildPhase = ''
    runHook preBuild

    npm run build

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "UI eXtension for Home Assistant, the successor of card-mod";
    homepage = "https://github.com/Lint-Free-Technology/uix";
    changelog = "https://github.com/Lint-Free-Technology/uix/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
