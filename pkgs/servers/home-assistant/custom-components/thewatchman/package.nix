{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  prettytable,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "dummylabs";
  domain = "watchman";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "dummylabs";
    repo = "thewatchman";
    tag = "v${version}";
    hash = "sha256-y9Qug+ftJDZXUHCsmx+/KqauczoHPPHiCtnnngdJBu8=";
  };

  ignoreVersionRequirement = [
    "prettytable"
  ];

  dontBuild = true;

  dependencies = [
    prettytable
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTests = [
    # flaky
    "test_automations_parsing"
    # Timing sensitive: Should still not be called (T=2.5 < T=3)
    "test_debounce_rescan"
  ];

  meta = {
    description = "Keep track of missing entities and services in your config files";
    homepage = "https://github.com/dummylabs/thewatchman";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
