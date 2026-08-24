{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "Sese-Schneider";
  domain = "cover_time_based";
  version = "4.11.0";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "ha-cover-time-based";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x6+xQCR3UmoIDp9JCnl86g8HTJMlo9Jz+eXXpu/oMGU=";
  };

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
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
