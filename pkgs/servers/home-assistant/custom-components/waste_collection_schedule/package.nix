{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  beautifulsoup4,
  curl-cffi,
  homeassistant,
  icalendar,
  icalevents,
  jinja2,
  lxml,
  pdfminer-six,
  pycryptodome,
  pypdf,
  pytestCheckHook,
  pyyaml,
  requests,
}:

buildHomeAssistantComponent rec {
  owner = "mampfes";
  domain = "waste_collection_schedule";
  version = "2.13.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hacs_waste_collection_schedule";
    tag = version;
    hash = "sha256-Tl9Z48d+OjyHmk0e6ALz/ywWHgzUhX+rhKjwZh4INo4=";
  };

  dependencies = [
    beautifulsoup4
    curl-cffi
    icalendar
    icalevents
    lxml
    pdfminer-six
    pycryptodome
    pypdf
  ];

  nativeCheckInputs = [
    homeassistant
    jinja2
    pytestCheckHook
    pyyaml
    requests
  ];

  meta = {
    changelog = "https://github.com/mampfes/hacs_waste_collection_schedule/releases/tag/${version}";
    description = "Home Assistant integration framework for (garbage collection) schedules";
    homepage = "https://github.com/mampfes/hacs_waste_collection_schedule";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
  };
}
