{
  lib,
  buildHomeAssistantComponent,
  cronsim,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-freezer,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:
buildHomeAssistantComponent rec {
  owner = "frenck";
  domain = "spook";
  version = "5.11.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = "v${version}";
    hash = "sha256-LO4WnmsPlvc26e4Sx/RxrZVIgEUak1oVm7Qa+SKkYUo=";
  };

  patches = [ ./remove-sub-integration-symlink-hack.patch ];

  postPatch = ''
    substituteInPlace custom_components/spook/manifest.json \
      --replace-fail '"version": "0.0.0"' '"version": "${version}"'
  '';

  dependencies = [
    cronsim
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-freezer
    pytest-homeassistant-custom-component
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
    changelog = "https://github.com/frenck/spook/releases/tag/v${version}";
    description = "Toolbox for Home Assistant";
    homepage = "https://spook.boo/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kkoniuszy ];
  };
}
