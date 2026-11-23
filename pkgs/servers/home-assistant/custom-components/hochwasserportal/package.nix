{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pytest-homeassistant-custom-component,

  # dependency
  lhpapi,
}:

buildHomeAssistantComponent rec {
  owner = "stephan192";
  domain = "hochwasserportal";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "stephan192";
    repo = "hochwasserportal";
    tag = "v${version}";
    hash = "sha256-WNWNYnlTPPljccol1/rsU5YTSZtO/v16yUN6a9kE6RU=";
  };

  dependencies = [
    lhpapi
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
  ];

  meta = {
    changelog = "https://github.com/stephan192/hochwasserportal/releases/tag/${version}";
    description = "Home Assistant integration for Länderübergreifendes Hochwasser Portal";
    homepage = "https://github.com/stephan192/hochwasserportal";
    maintainers = with lib.maintainers; [ _9R ];
    license = lib.licenses.mit;
  };
}
