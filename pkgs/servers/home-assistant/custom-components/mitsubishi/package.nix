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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pymitsubishi";
    repo = "homeassistant-mitsubishi";
    tag = "v${version}";
    hash = "sha256-V8fT/w7a/uUN4yKJ+jB6UUQDP6dif80MvlqV9n4KENc=";
  };

  dependencies = [
    pymitsubishi
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    pytest-homeassistant-custom-component
  ];

  meta = with lib; {
    description = "Home Assistant Mitsubishi Air Conditioner Integration";
    changelog = "https://github.com/pymitsubishi/homeassistant-mitsubishi/releases/tag/v${version}";
    homepage = "https://github.com/pymitsubishi/homeassistant-mitsubishi";
    maintainers = with maintainers; [ uvnikita ];
    license = licenses.mit;
  };
}
