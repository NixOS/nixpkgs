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
  version = "2.20.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hacs_waste_collection_schedule";
    tag = "v${version}";
    hash = "sha256-Dt1Ey2vIk5f6AEC9qepUb3S8+1rBwG5o6/6/pEoglcw=";
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
    changelog = "https://github.com/mampfes/hacs_waste_collection_schedule/releases/tag/${src.tag}";
    description = "Home Assistant integration framework for (garbage collection) schedules";
    homepage = "https://github.com/mampfes/hacs_waste_collection_schedule";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
  };
}
