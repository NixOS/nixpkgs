{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  pytestCheckHook,
  pyyaml,
  nix-update-script,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "Lint-Free-Technology";
  domain = "uix";
  version = "9.0.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "uix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zhve7CSVqTUyOPk8dJCqN9DuZJHdwurLrAfhdx6YDjI=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    name = "uix-${finalAttrs.version}-npm-deps";
    hash = "sha256-9pQIECBd2fMa1qJLGmGsrKoonzHxqAxpRVogwgaLJBQ=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    npmHooks.npmBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  # needs docker and a browser
  pytestFlags = [ "--noconftest" ];

  disabledTestPaths = [
    # need playwright and a Home Assistant container
    "tests/test_console_debug_dom_helpers.py"
    "tests/test_forge_spark_form_data.py"
    "tests/test_forge_spark_map_positions.py"
    "tests/test_ll_custom_actions_popover.py"
    "tests/visual"
  ];

  disabledTests = [
    # broken upstream
    "test_all_doc_images_are_tracked"
  ];

  # drop the prebuilt bundles checked into the repo, so the build regenerates them
  postPatch = ''
    rm custom_components/uix/*.js custom_components/uix/*.js.gz
  '';

  npmBuildScript = "build";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "UI eXtension for Home Assistant, the successor of card-mod";
    homepage = "https://github.com/Lint-Free-Technology/uix";
    changelog = "https://github.com/Lint-Free-Technology/uix/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
