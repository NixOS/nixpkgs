{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  prettytable,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "dummylabs";
  domain = "watchman";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "dummylabs";
    repo = "thewatchman";
    tag = "v${version}";
    hash = "sha256-qMsCkUf8G9oGWHTg1w2j8T5cvmAtk5bmeXEMXRXuOCk=";
  };

  postPatch = ''
    substituteInPlace custom_components/watchman/manifest.json \
      --replace-fail "prettytable==3.12.0" "prettytable"
  '';

  dontBuild = true;

  dependencies = [
    prettytable
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Keep track of missing entities and services in your config files";
    homepage = "https://github.com/dummylabs/thewatchman";
    maintainers = with maintainers; [ SuperSandro2000 ];
    license = licenses.mit;
  };
}
