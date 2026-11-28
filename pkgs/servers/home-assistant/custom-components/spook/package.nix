{
  lib,
  buildHomeAssistantComponent,
  cronsim,
  fetchFromGitHub,
  home-assistant,
  pytest-cov-stub,
  pytest-freezer,
  pytest-homeassistant,
  pytestCheckHook,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "frenck";
  domain = "spook";
  version = "5.12.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = finalAttrs.domain;
    tag = "v${finalAttrs.version}";
    hash = "sha256-hQ0yfPUNoWMYL0gGuyqesH0YP4AvMHR8jhWgBJZpt8Q=";
  };

  patches = [
    ./remove-sub-integration-symlink-hack.patch
  ];

  postPatch = ''
    substituteInPlace custom_components/spook/manifest.json \
      --replace-fail '"version": "0.0.0"' '"version": "${finalAttrs.version}"'
  '';

  dependencies = [
    cronsim
  ];

  nativeCheckInputs = [
    home-assistant
    pytest-cov-stub
    pytest-freezer
    pytest-homeassistant
    pytestCheckHook
  ];

  disabledTests = [
    # The sub-integration symlink hack is patched out by us
    "test_remove_entry_unlinks_sub_integrations"
    "test_setup_entry_loads_freshly_linked_sub_integration"
    "test_setup_entry_restarts_for_helpers_left_without_their_link"

    # snapshot is outdated
    "test_automation_case[conversation-trigger-slots-and-response-template]"
  ];

  meta = {
    changelog = "https://github.com/frenck/spook/releases/tag/${finalAttrs.src.tag}";
    description = "Toolbox for Home Assistant";
    homepage = "https://spook.boo/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kkoniuszy ];
  };
})
