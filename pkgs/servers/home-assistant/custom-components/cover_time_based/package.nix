{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  home-assistant,
  lib,
  pytest-homeassistant,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "Sese-Schneider";
  domain = "cover_time_based";
  version = "4.15.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "ha-cover-time-based";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F9iAQDhDTLPU1XZXCQGELdGsmvdfpI/Va4cFrE48GHM=";
  };

  nativeCheckInputs = [
    home-assistant
    pytest-homeassistant
    pytestCheckHook
  ];

  disabledTestPaths = [
    # no need to test development scripts
    "tests/test_bump_dev_script.py"
    "tests/test_release_script.py"
  ];

  meta = {
    changelog = "https://github.com/Sese-Schneider/ha-cover-time-based/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Integration which allows cover control based on time";
    homepage = "https://github.com/Sese-Schneider/ha-cover-time-based";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
