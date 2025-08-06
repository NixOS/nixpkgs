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
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "pymitsubishi";
    repo = "homeassistant-mitsubishi";
    tag = "v${version}";
    hash = "sha256-cJBhIck33gyFTITQKlLZSdKDA3VXeVJFGcQoD49BgWQ=";
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
