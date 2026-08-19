{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pymitsubishi,
  pytest-cov-stub,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
}:

buildHomeAssistantComponent rec {
  owner = "pymitsubishi";
  domain = "mitsubishi";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "pymitsubishi";
    repo = "homeassistant-mitsubishi";
    tag = "v${version}";
    hash = "sha256-8/zB1jbMoabd+pkIOUgY7bJ5lu2nCLkjS28Ru6bsKOw=";
  };

  dependencies = [
    pymitsubishi
  ];

  ignoreVersionRequirement = [ "pymitsubishi" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    pytest-homeassistant-custom-component
  ];

  disabledTests = [
    # tests try to open sockets
    "test_form_success"
    "test_form_already_configured"
    "test_form_with_options"
  ];

  meta = {
    description = "Home Assistant Mitsubishi Air Conditioner Integration";
    changelog = "https://github.com/pymitsubishi/homeassistant-mitsubishi/releases/tag/v${version}";
    homepage = "https://github.com/pymitsubishi/homeassistant-mitsubishi";
    maintainers = with lib.maintainers; [ uvnikita ];
    license = lib.licenses.mit;
  };
}
